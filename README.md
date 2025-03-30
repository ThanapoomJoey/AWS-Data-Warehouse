# AWS Data Warehouse Project

This project sets up a data warehouse system on the AWS cloud using simulated supermarket data. The primary database is Amazon Redshift, and DBT is used for data transformation and management. The goal is to create an efficient, scalable, and manageable data pipeline for processing and analyzing supermarket data

## Tools and Services
- **DBT**: Handles data transformation and modeling within the warehouse
- **DBT-GreatExpectations**: Integrates data quality checks and validation with DBT
- **Airflow**: Manages and schedules the ETL workflows
- **AWS EC2**: Provides compute resources to run Airflow and other processes
- **Redshift**: A fully managed data warehouse service for storing and querying data
- **IAM**: Manages permissions and access control for AWS resources
- **QuickSight**: A BI tool for visualizing data and generating reports

## Setup

- **EC2 Setup** : [AWS-EC2-Setup.md](AWS-EC2-Setup/AWS-EC2-Setup.md)

- **IAM User Access Keys Setup** : [AWS-IAM-User-Access-keys-Setup.md](AWS-IAM-User-Access-keys-Setup/AWS-IAM-User-Access-keys-Setup.md)

- **Redshift Setup** : [AWS-Redshift-Setup.md](AWS-Redshift-Setup/AWS-Redshift-Setup.md)

- **S3 Setup** : [S3_setup.md](import_data_to_s3/S3_setup_images/S3_setup.md)

### Step1 : Setup Environment

Set up the environment to allow the EC2 instance to work with other AWS services, such as S3 , Redshift

1. **Configure AWS CLI**
Run the AWS CLI configuration to set up credentials and access permissions
   ![aws_configure](DBT/EC2_dbt_setup_images/1_aws_configure.png)
    - Use the Access Key from [AWS-IAM-User-Access-keys-Setup.md](AWS-IAM-User-Access-keys-Setup/AWS-IAM-User-Access-keys-Setup.md)
    ![9_Download_access_key)](AWS-IAM-User-Access-keys-Setup/IAM-User-Access-keys-images/9_Download_access_key.png)

2. **Set Up Python Environment and Install dbt-redshift**
    ![python_environment)](AWS-EC2-Setup/EC2-Setup-images/10_Setup_EC2_python_env.png)

3. **Initialize dbt**
    - ```bash 
        dbt init
    - Use the Redshift endpoint when setting up dbt
    ![redshift_endpoint](DBT/EC2_dbt_setup_images/2_redshift_endpoint.png)
        - Note : Use only this part : data-warehouse-project.cn7cimzrfkqf.ap-southeast-1.redshift.amazonaws.com
    - Modify Security Groups to allow EC2 to connect to Redshift : Add an Inbound Rule to allow port 5439 for the private IP of the EC2 instance
    ![edit_inbound_rules](DBT/EC2_dbt_setup_images/3_edit_inbound_rules.png)
    - Check the dbt profile configuration in .dbt/profiles.yml
    ![dbt_profile](DBT/EC2_dbt_setup_images/4_dbt_profile.png)

### Step 2: DBT Seed for Creating Tables in Redshift

1. **Copy the S3 URI** of your data source  
   ![S3_path](DBT/dbt_seed/1_S3_path.png)  

2. **Sync data to the `seeds` folder using AWS S3 Sync**  
   - Navigate to the path:  
     `/home/ec2-user/dbt_lab/dbt_supermarket_project/seeds`  
     ![seeds_path](DBT/dbt_seed/3_seeds_path.png)  
   - Run the following command:  
     ```bash
     aws s3 sync s3://data-warehouse-project-supermarket/data/ .
     ```
     ![S3_sync](DBT/dbt_seed/2_S3_sync.png)

3. **Run dbt `dbt seed`**
   - Run the following command:  
     ```bash
     dbt seed
     ```
     ![dbt_seed](DBT/dbt_seed/5_dbt_seed.png)


3. **DBT automatically creates tables and DDL in Redshift**  
   ![redshift_seeds_table](DBT/dbt_seed/4_redshift_seeds_table.png)

  
### Step 3: 







    



