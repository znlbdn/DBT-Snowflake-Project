# DBT Snowflake Projects

This project is for hand-ons learning at Digital Schola which is building an ELT process to load data from csv file to snowflake and visualizing the data to reporting service with DBT to transform data.
In this project, I will use the SnowSQL CLI to load CSV file data to Snowflake.

![etl architecture diagram](https://github.com/znlbdn/DBT-Snowflake-Project/blob/master/assets/dbt_etl_diagram.png)

# Table of Project Content

1. Login to your Snowflake Account
2. Setup Configuration to Make Warehouse, Database, Schema and Role
3. Download the SnowSQL CLI from Snowflake
4. Setup SnowSQL to Connect to your Snowflake Account
5. Install dbt core and dbt-snowflake as adapter
6. Initialize your project and setup Snowflake Configuration

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
CREATE OR REPLACE SCHEMA DBTSNOW_DB.DBTSNOW_SCHEMA;
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
