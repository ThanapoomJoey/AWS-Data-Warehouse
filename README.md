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

  
### Step 3: DBT Model - Raw and Serving

1. **Navigate to the `models` directory**
    ```bash
     /home/ec2-user/dbt_lab/dbt_supermarket_project/models/supermarket_raw
     ```
     ![dbt_models](DBT/dbt_models/dbt_raw/dbt_raw_images/1_dbt_models.png)
2. **Raw Models (`supermarket_raw/`)**  
 - Raw models are created from the source data  
 - Inside the `supermarket_raw/` folder, define `.sql` files for raw tables and a `sources.yml` file for source definitions
   - [supermarket_raw_branches.sql](DBT/dbt_models/dbt_raw/supermarket_raw_branches.sql)
   - [supermarket_raw_categories.sql](DBT/dbt_models/dbt_raw/supermarket_raw_categories.sql)
   - [supermarket_raw_customers.sql](DBT/dbt_models/dbt_raw/supermarket_raw_customers.sql)
   - [supermarket_raw_locations.sql](DBT/dbt_models/dbt_raw/supermarket_raw_locations.sql)
   - [supermarket_raw_products.sql](DBT/dbt_models/dbt_raw/supermarket_raw_products.sql)
   - [supermarket_raw_sales.sql](DBT/dbt_models/dbt_raw/supermarket_raw_sales.sql)
   - [sources.yml](DBT/dbt_models/dbt_raw/sources.yml)
 - Example SQL file (`supermarket_raw_branches.sql`):  
   ```sql
    {{
        config(
        materialized = 'table',
        schema = 'raw'
        )
    }}

    select
        *
    from {{ source('supermarket','supermarket_branches') }}
    ```
 - Example sources.yml file:
   ```sql
    version: 1
    sources:
      - name: supermarket
        schema: supermarket
        tables:
        - name: supermarket_branches
        - name: supermarket_categories
        - name: supermarket_customers
        - name: supermarket_locations
        - name: supermarket_products
        - name: supermarket_sales
    ```
 - **Run dbt**  
     Run the following command to build the models:  
     ```bash
     dbt run
     ```
     ![dbt_run_raw_models](DBT/dbt_models/dbt_raw/dbt_raw_images/2_dbt_run_raw_models.png)
 - **Check Redshift Tables**  
     After running `dbt run`, verify the raw tables created in Redshift 
     ![Redshift_raw_table](DBT/dbt_models/dbt_raw/dbt_raw_images/3_Redshift_raw_table.png)
4. **Serving Models (`supermarket_serving/`)**
 - Serving models are transformed models that are ready for use in analytics or reporting. These models aggregate or join raw data to create business-relevant tables
   - [supermarket_view_dim_branches.sql](DBT/dbt_models/dbt_serving/supermarket_view_dim_branches.sql)
   - [supermarket_view_dim_customers.sql](DBT/dbt_models/dbt_serving/supermarket_view_dim_customers.sql)
   - [supermarket_view_dim_products.sql](DBT/dbt_models/dbt_serving/supermarket_view_dim_products.sql)
   - [supermarket_view_fact_sales.sql](DBT/dbt_models/dbt_serving/supermarket_view_fact_sales.sql)

 - **Example: [supermarket_view_fact_sales.sql](DBT/dbt_models/dbt_serving/supermarket_view_fact_sales.sql)**
    ```sql
    {{
        config(
        materialized = 'view',
        schema = 'serving'
        )
    }}
    SELECT
        s.sale_id,
        s.customer_id,
        s.product_id,
        s.branch_id,
        s.sale_date,
        s.quantity,
        p.unit_price,
        s.total_amount,
        p.unit_cost,
        ROUND((p.unit_price - p.unit_cost) * s.quantity,2) AS profit,
        CASE 
            WHEN s.unit_price = 0 THEN 0
            ELSE ROUND(((p.unit_price - p.unit_cost) / p.unit_price) * 100, 2)
        END AS "margin(%)"
    FROM {{ ref('supermarket_raw_sales')}} s
    LEFT JOIN {{ ref('supermarket_raw_products')}} p 
        ON s.product_id = p.product_id
     ```
 - **Sales report for data analytics**  
 - This model is created by joining the fact table with the dimension tables
 - [supermarket_view_sales_report.sql](DBT/dbt_models/dbt_serving/supermarket_view_sales_report.sql)
    ```sql
    {{
        config(
        materialized = 'view',
        schema = 'serving'
        )
    }}
    SELECT
        s.sale_id,
        s.customer_id,
        s.product_id,
        s.branch_id,
        s.sale_date,
        s.quantity,
        s.total_amount,
        p.product_name,
        p.category_name,
        p.unit_cost,
        p.unit_price,
        c.first_name,
        c.last_name,
        b.branch_name,
        b.manager_name,
        b.city,
        b.region
    FROM {{ ref('supermarket_view_fact_sales')}} s
    LEFT JOIN {{ ref('supermarket_view_dim_products')}} p ON s.product_id = p.product_id
    LEFT JOIN {{ ref('supermarket_view_dim_customers')}} c ON s.customer_id = c.customer_id
    LEFT JOIN {{ ref('supermarket_view_dim_branches')}} b ON s.branch_id = b.branch_id
     ```












    



