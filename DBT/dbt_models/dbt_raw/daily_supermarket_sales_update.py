import boto3
import psycopg2
from datetime import datetime


s3_client = boto3.client('s3')

data_today = datetime.today().strftime('%Y%m%d')

response = s3_client.list_objects_v2(
    Bucket='data-warehouse-project-supermarket',
    Prefix=f"csv_supermarket/{data_today}/"
)

csv_files = [obj['Key'] for obj in response['Contents'] if obj['Key'].lower().endswith('.csv')]

print("CSV files found:", csv_files)

redshift_client = boto3.client('redshift')
response = redshift_client.get_cluster_credentials(
    DbUser='awsuser', 
    DbName='supermarket',
    ClusterIdentifier='data-warehouse-project',
    AutoCreate=False
)


redshift_conn = psycopg2.connect(
    dbname='supermarket',
    host='data-warehouse-project.cn7cimzrfkqf.ap-southeast-1.redshift.amazonaws.com',
    port=5439,
    user=response['DbUser'],
    password=response['DbPassword']
)

cursor = redshift_conn.cursor()


iam_role = 'arn:aws:iam::302263044480:role/service-role/AmazonRedshift-CommandsAccessRole-20250224T143611'

for csv_file in csv_files:
    s3_path = f"s3://data-warehouse-project-supermarket/{csv_file}"
    copy_query = f"""
    COPY supermarket.supermarket_sales
    FROM '{s3_path}'
    IAM_ROLE '{iam_role}'
    CSV
    IGNOREHEADER 1;
    """
    print(f"Loading {csv_file} into Redshift...")
    cursor.execute(copy_query)
    redshift_conn.commit()
    print(f"Loaded {csv_file} successfully")

cursor.close()
redshift_conn.close()
