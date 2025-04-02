import pendulum
from airflow import DAG
from airflow.operators.bash import BashOperator

with DAG(
    dag_id="My_DBT_Pipeline",
    #schedule="@daily"
    schedule="0 0 * * *",
    start_date=pendulum.datetime(2025, 1, 1, tz="Asia/Bangkok"),
    catchup=False,
    tags=["Sales_Report"]
) as dag:
    
    step_1 = BashOperator(
        task_id="dbt_seed",
        bash_command="/home/ec2-user/dbt_lab/.env/bin/dbt seed --project-dir /home/ec2-user/dbt_lab/dbt_supermarket_project",
    )
    step_2 = BashOperator(
        task_id="dbt_run",
        bash_command="/home/ec2-user/dbt_lab/.env/bin/dbt run --project-dir /home/ec2-user/dbt_lab/dbt_supermarket_project",
    )
    step_3 = BashOperator(
        task_id="dbt_test",
        bash_command="/home/ec2-user/dbt_lab/.env/bin/dbt test --project-dir /home/ec2-user/dbt_lab/dbt_supermarket_project",
        
    )

    step_1 >> step_2 >> step_3