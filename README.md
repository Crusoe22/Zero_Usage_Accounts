# Zero_Usage_Accounts

# Zero-Usage-Accounts
SQL code to find accounts with a zero usage

# SQL Code README

Overview

This SQL code is designed to retrieve data from the [database_name].[table_name].[history_water] table and related tables in the [database_name].[table_name] schema. The primary goal is to identify specific records based on various conditions and filter the results to only include the records with the highest read_date for each unique account_no.

Code Explanation

Common Table Expression (CTE) - RankedData
Columns Selected:

- account_no: Account number.
- occupant_code: Occupant code.
- mtyr_period: Meter year period.
- read_date: Date of the meter reading.
- meter_no: Meter number.
- no_of_days: Number of days.
- usage_hi: High usage.
- usage_low: Low usage.
- billcode: Billing code.
- name: Name from the pa table.
- callername: Caller name from the cs table.
- workorder: Work order from the cs table.
- note: Note from the cs table.
- calltype: Call type from the cs table.
- row_rank: Row number assigned based on the descending order of occupant_code within each account_no partition.

#### Joins:

Joins with [database_name].[table_name].[acc_water] pa on account_no.
Joins with [database_name].[table_name].[car_call_water] cs on account_no.

#### Conditions:
Records where usage_hi is equal to 0.
Records where no_of_days is either greater than 60 and less than 365, or greater than 1095.
Excludes records where name contains '%CLOSED ACCOUNT%' or '%VACANT%'.
Includes only records where note contains '%STUCK%' and calltype is 'WDEFLT'.
Filters records where read_date is the maximum read_date for each account_no.

#### Final Query
Selects all columns from the RankedData CTE.
Filters the results to only include rows with row_rank equal to 1, which represents the records with the highest read_date for each unique account_no.

#### Usage Instructions
Execute the code in a SQL environment connected to the [database_name] database.
Review the results to obtain relevant information for accounts meeting the specified conditions.

#### Notes
Ensure that the database connection details and permissions are correctly set up before executing the code.
Adjust the conditions in the WHERE clause if different criteria are needed for the analysis.