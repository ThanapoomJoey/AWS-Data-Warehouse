## Redshift Cluster Setup


- Step1 : Create cluster
![Create_cluster](Redshift-Setup-images/1_Create_cluster.png)
    - Note: dc2.large is the smallest instance type, and selecting only 1 node is sufficient for small projects

- Step2 : Database configurations
![Database configurations](<Redshift-Setup-images/2_Database configurations.png>)

- Step3 : Add permission
![Add_permission](Redshift-Setup-images/3_Add_permission.png)

- Step4 : Create subnet group
![Create_subnet_group](Redshift-Setup-images/4_Create_subnet_group.png)

- Step5 : Network security
![Network_security](Redshift-Setup-images/5_Network_security.png)
    - Note: Turn on Publicly Accessible if you are using an instance outside the VPC, such as a local machine
- Step6 : Database name
![Database_name](Redshift-Setup-images/6_Database_name.png)

- Step7 : Check Cluster
![Check_cluster](Redshift-Setup-images/7_Check_cluster.png)

- Step8 : Start Redshift Query Editor v2 and Connect to the Database
![Connect](Redshift-Setup-images/8_Connect.png)

- Step9 : Creck database
![Creck_database](Redshift-Setup-images/9_Creck_database.png)