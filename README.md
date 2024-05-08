# DBT Snowflake Projects

This project is for building an ELT process to load data from csv file to snowflake and visualizing the data to reporting service with DBT. In this project, I will use the SnowSQL CLI to load CSV file data to Snowflake.

![etl architecture diagram](https://github.com/znlbdn/DBT-Snowflake-Project/blob/master/assets/dbt_etl_diagram.png)

# Table of Project Content

1. Login to your Snowflake Account
2. Setup Configuration to Make Warehouse, Database, Schema and Role
3. Download the SnowSQL CLI from Snowflake
4. Setup SnowSQL to Connect to your Snowflake Account
5. Install dbt core and dbt-snowflake as adapter
6. Initialize your project and setup Snowflake Configuration
7. Creating Models (Bronze, Silver and Gold)
8. Load Data to Snowflake with SnowSQL CLI
9. Configure the source data in dbt
10. Transform data (Silver and Gold)
11. Testing (Generic Test)
12. Create Documentation
13. Dbt Lineage Graph
14. Connecting to Power BI

# Login to Snowflake Account

Kindly login to your Snowflake account, if you are not register yet, you can follow this link to register first (https://signup.snowflake.com/). After you successfully register, you get free trial for 30 days or equal to USD $400 credit.

# Setup Warehouse, Database, Shcema and Role

Create compute or warehouse named DBT_WH, database named DBTSNOW_DB, DBTSNOW_SCHEMA for schema, and DBTSNOW_ROLE for role and assign the role to your user. You can follow my sql query below.

```
-- Use ACCOUNTADMIN Role
USE ROLE ACCOUNTADMIN;

-- Create Warehouse named DBT_WH
CREATE OR REPLACE WAREHOUSE DBT_WH WITH
WAREHOUSE_SIZE = 'X-Small'
AUTO_SUSPEND = 300
AUTO_RESUME = TRUE;

-- Create Database to Store the CSV Data
CREATE OR REPLACE DATABASE DBTSNOW_DB;

-- Create Role DBTSNOW Role
CREATE OR REPLACE ROLE DBTSNOW_ROLE;

-- Grant Warehouse DBT_WH to Role DBTSNOW_ROLE
GRANT USAGE ON WAREHOUSE DBT_WH TO ROLE DBTSNOW_ROLE;

-- Grant Role to User
GRANT ROLE DBTSNOW_ROLE TO USER ZNLBDN;

-- Grant Role to Database DBTSNOW_DB
GRANT ALL ON DATABASE DBTSNOW_DB TO ROLE DBTSNOW_ROLE;

-- Show Grant
SHOW GRANTS ON WAREHOUSE DBT_WH;
SHOW GRANTS ON DATABASE DBTSNOW_DB;

-- Use DBTSNOW_ROLE
USE ROLE DBTSNOW_ROLE;

-- Create Schema on Database DBTSNOW_DB
CREATE OR REPLACE SCHEMA DBTSNOW_DB.BRONZE;
```

# Download SnowSQL CLI

In this projects, I use the SnowSQL for Ingest or load data to Snowflake. You can donwload the SnowSQL using this link (https://developers.snowflake.com/snowsql).

# Setup SnowSQL CLI

After the download finish, kindly run the downloaded file and wait until the installation proccess have done.
You must complate the configuration by following below

1. Open your terminal window
2. Execute command below to test you connection, when prompted enter your password:

```
snowsql -a <account_name> -u <login_name>
```

3. Add conneciton to the ~/snowsql/config file

```
accountname = <account_name>
usernmae = <user_name>
passowrd = <your_password>
```

4. Execute the command to connect to Snowflake

```
snowsql
```

Note : you can see the account_name of your snowflake on snowflake dahsboard, in the left corner, click your profile, hover your account and then copy the url link (chain icon). Paste on notepad and the account_name is in the https://<account_name>.snowflakecomputing.com/

# Install dbt core and dbt-snowflake

Open your directory project in visual studio and open the terminal. Before you install, create a python virtual environtment first.

- Create VE named dbt-env

```
python -m venv dbt-env
```

- Activate the VE

```
dbt-env\Scripts\activate.ps1
```

- Install dbt core

```
python -m pip install dbt-core
```

- Install dbt-snowflake

```
python -m pip install dbt-snowflake
```

- Chek version

```
dbt --version
```

# Initialize dbt Project and Configure Snowflake Connection

It's pretty simple to initialize dbt project, follow me below

- Run dbt init command

```
dbt init
```

- Named the project 'dbt_snow' and then enter
- Chose Snowflake as adapter by fill 1 in the promp
- Enter your username
- Enter your password for username
- Role : DBTSNOW_ROLE
- Warehouse : DBT_WH
- Database : DBTSNOW_DB
- Schema : DBTSNOW_SCHEMA
- Threads : 10

Test your configuration above by running this command, but makesure that you are in the file of project.

```
cd dbt_snow
```

Run the command dbt config after you are in the dbt_snow directory

```
dbt config
```

# Create Models (Staging, Warehouse and Mart)

Open your dbt_projects.yml and configuring the model. In this projects, I will difine 3 models that refer to Medallion Architecture (Bronze, Silver and Gold). The bronze model have defined before to store data using CLI.

- Bronze
  Storing raw data loaded from your system's data (in my projects from CSV file).
- Silver
  Intermediate stage of dataset, joins and column cleaning.
- Gold
  Storing data modelled for analysis, like star schmea, aggregate tables.

This is my dbt_project.yml configuration, and don't forget to create sub-folder in folder models

```
models:
  dbt_snow:
    silver:
      schema: silver
      snowflake_warehouse: dbt_wh
      +materialized: table
    gold:
      schema: gold
      snowflake_warehouse: dbt_wh
      +materialized: view
```

# Load Data with SnowSQL CLI

Open your terminal and connect with your Snowflake account using SnowSQL by following this command below

```
snowsql -a <account_name> -u <user_name>
```

When prompted enter your password. If you are already log in to your Snowflake account via SnowSQL, navigate to use your Warehouse, Databse, Schema and Role that use to store raw csv data (bronze).

```
USE WAREHOUSE DBT_WH; # press enter for every command
USE DATABSE DBTSNOW_DB;
USE SCHEMA BRONZE;
USE ROLE DBTSNOW_ROLE;
```

Then create the destination table of raw data in bronze schma for every csv file data, for example, to create the customer table schema you can use the sql command below

```
CREATE OR REPLACE TABLE customer (
    id               NUMBER,
    company          VARCHAR(255),
    last_name        VARCHAR(255),
    first_name       VARCHAR(255),
    email_address    VARCHAR(255),
    job_title        VARCHAR(255),
    business_phone   VARCHAR(20),
    home_phone       VARCHAR(20),
    mobile_phone     VARCHAR(20),
    fax_number       VARCHAR(20),
    address          VARCHAR(255),
    city             VARCHAR(255),
    state_province   VARCHAR(255),
    zip_postal_code  VARCHAR(20),
    country_region   VARCHAR(255),
    web_page         VARCHAR(255),
    notes            TEXT,
    attachments      VARIANT
); # then press enter to create customer table
```

After that, make sure your csv datasets in the same folder name, for I store all csv dataset in

```
D:\datasets\
```

Stage all csv datasets above, stage is used to store data file internally within snowflake (each user and table in Snowflake gets internal stage by default for staging data files). The command below is use to stage all my csv datasets internally

```
put file://D:\datasets\*.csv @~
```

- \*.csv --> store all csv dataset format to stage, the stage is define by @~

Then the result in your CLI must be
![result put cli](https://github.com/znlbdn/DBT-Snowflake-Project/blob/master/assets/result_cli_put.png)

- To show all cvs in the stage @~ use the command below

```
list @~
```

Then the result in your CLI must be
![result put list](https://github.com/znlbdn/DBT-Snowflake-Project/blob/master/assets/result_cli_list.png)

After that, use COPY INTO command to load your stage data to target table that created before, use the command below (example for customer table target from customer stage)

```
COPY INTO CUSTOMER
    FROM @~
    FILES = ('customer.csv.gz')
    FILE_FORMAT= (type='ÇSV' field_delimiter=',' skip_header=1 compression= GZIP null_if='NULL' )
    on_error= 'CONTINUE' # this means that you want to load as much data as possible
```

Then the result of executing the command above must be
![result put cust](https://github.com/znlbdn/DBT-Snowflake-Project/blob/master/assets/result_cli_cust.png)

with the same scenario, create all table target of your dataset first, then load the data that have been in the stage to your target table.

# Configure the Source Data

In my projects, the sources.yml file is to make a dataset refrerance from the bronze stage (staging area). Kindly you can open it in my models direcotry.

# Transform Data

Silver stage is the cleaned dataset from the bronze or staging area, and the silver stage including joins and column cleaning. After that the final dataset stage is on gold schema and ready to use in BI tools. Kindly you can open it in my models direcotry.

After you finish building model within silver and gold, you can execute the command below

```
dbt run
```

# Testing (Generic Test)

Generic Tests are put in place by calling a macro. Defined in a .yaml file within the folder where the model is. In my project the test including not_null, unique and relationships.

```
models:
  - name: dim_customers
    columns:
      - name: cust_id
        tests:
          - unique
          - not_null
          - relationships:
              to: ref('int_orders')
              field: customer_id
              severity: warn
  - name: dim_employees
    columns:
      - name: emp_id
        tests:
          - unique
          - not_null
          - relationships:
              to: ref('fact_orders')
              field: employee_id
              severity: warn
  - name: dim_products
    columns:
      - name: prod_id
        tests:
          - unique
          - not_null
          - relationships:
              to: ref('fact_orders')
              field: product_id
              severity: warn
              to: ref('fact_inventory')
              field: product_id
              severity: warn
              to: ref('fact_purchase_orders')
              field: product_id
              severity: warn

```

To test this, you can easily run this command below

```
dbt test
```

# Create Project Documentation

Generating documentation in dbt is a crucial step in managing and maintaining a healthy data analytics workflow. It improves collaboration, understanding, and the overall quality of your data transformation processes.

To generate the project documentation, execute this command below

```
dbt docs generate
```

# Dbt Web Server (Lineage Graph)

Run the command below, to see the documentation within catalog and lineage graph of your model design befor

```
dbt docs serve --port 8001
```

![dbt-dag](https://github.com/znlbdn/DBT-Snowflake-Project/blob/master/assets/dbt-dag.png)

# Connet to Power BI

By the end of the project, Power BI used to present the data that have been design before, by using the gold stage of data.

- Kindly open the Power BI App (if you don't have already, you can donwload using this link https://www.microsoft.com/id-id/download/details.aspx?id=58494)
- Open new report
- Go to the home tab, and get data
- Choose Snowflake and the connect
  ![snow-connect](https://github.com/znlbdn/DBT-Snowflake-Project/blob/master/assets/sow_connect.jpg)
- Fill the form connection field (account name, warehouse, role and database)
  ![snow-connect-form](https://github.com/znlbdn/DBT-Snowflake-Project/blob/master/assets/sow_connect_form.jpg)
- Insert your username and password and then connect
- In the navigator, select all tabel (fact and dimension view) within Gold Schema and load
  ![snow-connect-data](https://github.com/znlbdn/DBT-Snowflake-Project/blob/master/assets/sow_connect_data.jpg)
- In the connection string, select import option and ok
  ![snow-connect-ok](https://github.com/znlbdn/DBT-Snowflake-Project/blob/master/assets/sow_connect_ok.jpg)
- Make a relationship between fact and dimension
  ![snow-connect-star](https://github.com/znlbdn/DBT-Snowflake-Project/blob/master/assets/sow_connect_star.jpg)
- Dashboarding!
  ![simple-dashboard](https://github.com/znlbdn/DBT-Snowflake-Project/blob/master/assets/simple_dashboard.jpg)

You can donwload the simpe dahsboard and using this simple .pbix file
![PBI-Projects](https://github.com/znlbdn/DBT-Snowflake-Project/blob/master/assets/PBI_Projects.pbix)

Thank you!
