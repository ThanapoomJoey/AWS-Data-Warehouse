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

- EC2 Setup : [AWS-EC2-Setup.md](AWS-EC2-Setup/AWS-EC2-Setup.md)

- IAM User Access Keys Setup : [AWS-IAM-User-Access-keys-Setup.md](AWS-IAM-User-Access-keys-Setup/AWS-IAM-User-Access-keys-Setup.md)

- Redshift Setup : [AWS-Redshift-Setup.md](AWS-Redshift-Setup/AWS-Redshift-Setup.md)

- S3 Setup : [S3_setup.md](import_data_to_s3/S3_setup_images/S3_setup.md)