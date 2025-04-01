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
   ```bash
    dbt init
    ```
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


4. **DBT automatically creates tables and DDL in Redshift**  
   - **Check Redshift Tables**
   ![redshift_seeds_table](DBT/dbt_seed/4_redshift_seeds_table.png)

  
### Step 3: DBT Model - Raw and Serving

- **Navigate to the `models` directory**
    ```bash
     /home/ec2-user/dbt_lab/dbt_supermarket_project/models/supermarket_raw
     ```
     ![dbt_models](DBT/dbt_models/dbt_raw/dbt_raw_images/1_dbt_models.png)
#### Raw Models  
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
#### **Serving Models**
 - Serving models are transformed models that are ready for use in analytics or reporting. These models aggregate or join raw data to create business-relevant view tables
    ```bash
     /home/ec2-user/dbt_lab/dbt_supermarket_project/models/supermarket_serving
     ```
     ![S3_Sync](DBT/dbt_models/dbt_serving/dbt_serving_images/1_S3_Sync.png)

   - [supermarket_view_dim_branches.sql](DBT/dbt_models/dbt_serving/supermarket_view_dim_branches.sql)
   - [supermarket_view_dim_customers.sql](DBT/dbt_models/dbt_serving/supermarket_view_dim_customers.sql)
   - [supermarket_view_dim_products.sql](DBT/dbt_models/dbt_serving/supermarket_view_dim_products.sql)
   - [supermarket_view_fact_sales.sql](DBT/dbt_models/dbt_serving/supermarket_view_fact_sales.sql)
   - [supermarket_view_sales_report.sql](DBT/dbt_models/dbt_serving/supermarket_view_sales_report.sql)

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
 - This model is created by joining the fact view table with the dimension view tables
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
    
 - **Run dbt**  
     Run the following command to build the models:  
     ```bash
     dbt run
     ```   
    ![dbt_run_serving](DBT/dbt_models/dbt_serving/dbt_serving_images/2_dbt_run_serving.png)

 - **Check Redshift Tables**  
     After running `dbt run`, verify the serving view tables created in Redshift
     ![redshift_view](DBT/dbt_models/dbt_serving/dbt_serving_images/3_redshift_view.png)

   ### **QuickSight Dashboard Report**
    This dashboard is built using **Amazon QuickSight** to display sales data from the dbt model in the `serving` schema. It focuses on sales insights for **March** and includes the following components:

    ![QuickSight Dashboard](DBT/dbt_models/dbt_serving/dbt_serving_images/4_quicksight_dashboard.png)

    #### Dashboard Components

    #### 1. Total Sales by Branch
    - Shows the total sales (`sum(total_amount)`) for each `branch_name`
    - Helps compare sales performance across branches

    #### 2. Total Sales by Product Category
    - Displays total sales (`sum(total_amount)`) for each `category_name`
    - Highlights which product categories are performing best

    #### 3. Top Products
    - Lists the top-selling products based on `sum(total_amount)` or `sum(quantity)`

    #### 4. Sales Trend (March)
    - **Visual Type**: Line Chart
    - Shows daily sales trends for the month of March

### Step 4: dbt Web Browser

This section explains how to generate and serve dbt documentation using the dbt web browser interface. The dbt docs feature allows you to visualize your data models and their lineage in a browser

#### 1. Generate dbt Documentation
Run the following command to generate the dbt documentation files:
```bash
dbt docs generate
 ```
#### 2. Serve dbt Documentation
```bash
dbt docs serve --port 8080 --host 0.0.0.0
 ```
![dbt_docs_generate](DBT/dbt_docs_web_browser/1_dbt_docs_generate.png)
- port 8080: Sets the port to 8080
- host 0.0.0.0: Allows access from external IPs (make sure your Security Group allows traffic on port 8080)
After running the command, open your browser and go to http://your-ec2-public-ip:8080 ( http://47.128.228.216:8080) to see the dbt docs

- dbt Web Browser Detail
Here’s an example of the dbt documentation interface in the browser
![dbt_web_browser_detail](DBT/dbt_docs_web_browser/2_dbt_web_browser_detail.png)
#### 3. dbt Lineage Graph
The dbt docs interface includes a Lineage Graph that shows the relationships between your models, sources, and other nodes in the project
![dbt_dag_Lineage_Graph](DBT/dbt_docs_web_browser/3_dbt_dag_Lineage_Graph.png)

### Step 5: Data Quality with dbt-expectations

In this step, we use dbt-expectations to ensure data quality in our supermarket database. It checks that key columns are not null and unique, verifies specific formats for certain fields, and ensures numeric values and dates fall within reasonable ranges. This helps catch errors and maintain reliable data

- Create the [schema.yml](DBT/dbt_models/dbt_serving/schema.yml) File
![schema_test](DBT/dbt_great_expectations/dbt_expectations_images/1_schema_test.png)
- Run the following command to test the data:
  ```bash
   dbt test
   ```
- Check the Test Results
![dbt_test](DBT/dbt_great_expectations/dbt_expectations_images/2_dbt_test.png)

In real projects, we can apply data quality checks at every step for better data reliability








    



