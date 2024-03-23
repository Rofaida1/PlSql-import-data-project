# PlSql-import-data-project
This repository contains a PL/SQL script to import employee data into an Oracle database. It handles job, city, and department checks, ensuring data integrity. Below is an overview of the script's functionality and instructions for its usage.

Table of Contents:
- Purpose
- Requirements
- Setup
- Usage
- Script Overview


1- Purpose:
The purpose of this script is to facilitate the seamless import of employee data from a temporary source into a database schema. It handles the creation of sequences for department and location IDs, checks for the existence of job titles, cities, and departments before inserting data, and ensures data integrity during the import process.

2- Requirements:
- Oracle Database environment
- Access to execute PL/SQL scripts
  
3- Setup:
- Alter Employee Table: Before running the script, ensure that the HR.EMPLOYEES table has its EMAIL column modified to accommodate longer email addresses.
- Sequence Creation: Two sequences are required for generating unique department and location IDs. Run the provided PL/SQL blocks to create these sequences.
- Procedure Creation: Execute the PL/SQL script import_employee_data to create the procedure responsible for importing data.

4- Usage:
- Prepare Temporary Data: Ensure that the temporary data table EMPLOYEES_TEMP contains the necessary employee data.
- Execute the Procedure: Run the import_employee_data procedure to initiate the import process. The script will handle the rest, including checking for existing job titles, cities, and departments, and inserting data accordingly.

5- Script Overview
Data Retrieval: The script retrieves employee data from the EMPLOYEES_TEMP table.
Job, City, and Department Checks: It checks if job titles, cities, and departments already exist in their respective tables to maintain data integrity.
Insertion: If necessary, it inserts new job titles, cities, and departments, along with employee data into the EMPLOYEES table.
Error Handling: The script ensures that only valid email addresses are inserted into the database.
