Commands:

dbt init - initialising the dbt project
-give all the necessary details of the cluster we are using

dbt --version - for checking the dbt version

dbt debug - to check whether the connection with cluster (Databricks/Snowflake) is working fine or not

dbt run -> run all the models
dbt run --select "models/silver" - run the model for the selected folder

dbt snapshot -> For running all the snapshots

dbt clean -> destroy the target and dbt packages directory