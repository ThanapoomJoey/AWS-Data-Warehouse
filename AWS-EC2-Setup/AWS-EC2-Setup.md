## EC2 Setup for Dbt and Redshift

- Step1 : Launch_instances
![Launch_instances](EC2-Setup-images/1_Launch_instances.png)

- Step2 : Create_name
![Create_name](EC2-Setup-images/2_Create_name.png)

- Step3 : Instance_type
![Instance_type](EC2-Setup-images/3_Instance_type.png)
    -  Note : Select t4g.medium because instance types with only 1-2 GB of RAM are not enough to run the Airflow web server

- Step4 : Create_key_pair
![Create_key_pair](EC2-Setup-images/4_Create_key_pair.png)
    - Note: The key for accessing the instance should be securely stored. Use .pem for Mac and .ppk for Windows.

- Step5 : Create_vpc
![Create_vpc](EC2-Setup-images/5_Create_vpc.png)
    Note: The VPC must have at least 3 Availability Zones for using Redshift

- Step6 : Setup_Network
![Setup_Network](EC2-Setup-images/6_Setup_Network.png)
    - Note: Enable Auto-assign Public IP for the EC2 instance, as a fixed IP has additional charges
    - Note: Add port 8080 for DBT

- Step7 : Connect_instance
    - click connect
    ![Connect_instance](EC2-Setup-images/7_Connect_instance.png)
    - and connect_instance
    ![Connect_instance2](EC2-Setup-images/8_Connect_instance2.png)

- Step 8 : Start using the instance server
![Start_EC2](EC2-Setup-images/9_Start_EC2.png)

- Step 9: Setup Python, DBT, and Redshift Environment
![Setup_EC2_python_env](EC2-Setup-images/10_Setup_EC2_python_env.png)
    -Use the following command for installation    
    ```bash
    python -m pip install dbt-core dbt-redshift