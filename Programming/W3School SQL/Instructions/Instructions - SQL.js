/* Introduction SQL

We Have to know what is SQL

SQL - Structured Query Language

SQL: Structured Query Language
1. Structured (S)
Definition: Refers to the organized format of data stored in tables (rows and columns).

Key Features:
Data is arranged in relations (tables) with defined schemas.
Ensures consistency and easy access to information.

Purpose:
To enable precise querying and manipulation of well-organized data.

2. Query (Q)
Definition: A request to perform operations like retrieving, modifying, or defining data in a database.

Key Operations:
Retrieve Data: Using commands like SELECT.
Manipulate Data: Using commands like INSERT, UPDATE, and DELETE.
Modify Structure: Using commands like CREATE TABLE, ALTER TABLE.

Query Types:
Data Query: Extracts specific data (e.g., all employees earning > $50,000).
Action Query: Performs operations like adding or removing records.
Schema Query: Changes database structures like tables and relationships.

Declarative Nature:
Focuses on what data is needed, not how to retrieve it.

Example:
SELECT name, age FROM employees WHERE age > 30;

3. Language (L)
Definition: A domain-specific computer language designed for database tasks.

Key Components:
DDL (Data Definition Language): Defines/changes database structure (CREATE, ALTER, DROP).
DML (Data Manipulation Language): Interacts with data in tables (SELECT, INSERT, UPDATE, DELETE).
DCL (Data Control Language): Controls database access (GRANT, REVOKE).
TCL (Transaction Control Language): Manages transactions (COMMIT, ROLLBACK, SAVEPOINT).

Why It's a Language:
SQL has a structured grammar, syntax, and vocabulary for database communication.
*/

/*SQL Syntax :

SQL Statements
Most of the actions you need to perform on a database are done with SQL statements.
SQL statements consist of keywords that are easy to understand.

Example : SELECT * FROM CUSTOMER;

Database Tables
A database most often contains one or more tables. Each table is identified by a name (e.g. "Customers" or "Orders"), and contain records (rows) with data.
In this tutorial we will use the well-known Northwind sample database (included in MS Access and MS SQL Server).

| **CustomerID** | **CustomerName**                   | **ContactName**    | **Address**                   | **City**    | **PostalCode** | **Country** |
| -------------- | ---------------------------------- | ------------------ | ----------------------------- | ----------- | -------------- | ----------- |
| 1              | Alfreds Futterkiste                | Maria Anders       | Obere Str. 57                 | Berlin      | 12209          | Germany     |
| 2              | Ana Trujillo Emparedados y helados | Ana Trujillo       | Avda. de la Constitución 2222 | México D.F. | 05021          | Mexico      |
| 3              | Antonio Moreno Taquería            | Antonio Moreno     | Mataderos 2312                | México D.F. | 05023          | Mexico      |
| 4              | Around the Horn                    | Thomas Hardy       | 120 Hanover Sq.               | London      | WA1 1DP        | UK          |
| 5              | Berglunds snabbköp                 | Christina Berglund | Berguvsvägen 8                | Luleå       | S-958 22       | Sweden      |

Note: SQL is not case sensitive, select is also same as SELECT

Semicolons at SQL :

Some database systems require a semicolon at the end of each SQL statement.
Semicolon is the standard way to separate each SQL statement in database systems that allow more than one SQL statement to be executed in the same call to the server.
In this tutorial, we will use semicolon at the end of each SQL statement.

Note: It is not absolute requirement, you can also use SQL without semicolons but is good programming practice

Some of The Most Important SQL Commands

SELECT - extracts data from a database
UPDATE - updates data in a database
DELETE - deletes data from a database
INSERT INTO - inserts new data into a database
CREATE DATABASE - creates a new database
ALTER DATABASE - modifies a database
CREATE TABLE - creates a new table
ALTER TABLE - modifies a table
DROP TABLE - deletes a table
CREATE INDEX - creates an index (search key)
DROP INDEX - deletes an index
*/

/*SQL LANGUAGES

Definition of SQL and SQL Language Types

Structured Query Language (SQL) is a standardized programming language designed for managing and manipulating relational databases. SQL facilitates a wide range of operations such as querying data, modifying data, and managing database structures.
SQL is divided into various sub-languages based on its functionalities. These sub-languages define the different types of operations that can be performed. Below are the primary types of languages in SQL:

1. Data Definition Language (DDL)
Definition:
DDL deals with the structure or schema of the database. It includes commands that define and modify database objects such as tables, indexes, and views.

Key Commands:
CREATE: Used to create new database objects.
ALTER: Used to modify existing database objects.
DROP: Used to delete database objects permanently.
TRUNCATE: Used to delete all rows from a table while retaining its structure.

2. Data Manipulation Language (DML)
Definition:
DML is responsible for the manipulation of data stored in database tables. It is used to retrieve, insert, update, and delete data.

Key Commands:
SELECT: Used to query data from tables.
INSERT: Used to add new rows of data into a table.
UPDATE: Used to modify existing data in a table.
DELETE: Used to remove rows from a table.

3. Data Control Language (DCL)
Definition:
DCL is used to control access to data stored in the database by managing permissions.

Key Commands:

GRANT: Provides specific privileges to users or roles.
REVOKE: Removes previously granted privileges.

4. Transaction Control Language (TCL)
Definition:
TCL is used to manage transactions in a database, ensuring data integrity and consistency.

Key Commands:
COMMIT: Saves all changes made during the current transaction permanently.
ROLLBACK: Reverts all changes made during the current transaction to the previous state.
SAVEPOINT: Sets a point within a transaction to which a rollback can occur.
SET TRANSACTION: Defines transaction properties such as isolation level.

5. Data Query Language (DQL)
Definition:
DQL is specifically focused on querying data from a database. In practice, it is often treated as a subset of DML.

Key Command:
SELECT: The only command in DQL, used to fetch data.

6. Embedded SQL and Procedural SQL
Embedded SQL: Embedding SQL queries into programming languages like C, Java, or Python.
Procedural SQL (PL/SQL or T-SQL): Extends SQL with procedural capabilities like loops, conditions, and variables, primarily used in database-specific systems like Oracle or SQL Server.

| **SQL Sub-Language** | **Purpose**                          | **Examples of Commands**                     |
| -------------------- | ------------------------------------ | -------------------------------------------- |
| DDL                  | Define and manage database structure | CREATE, ALTER, DROP, TRUNCATE                |
| DML                  | Manipulate data in tables            | SELECT, INSERT, UPDATE, DELETE               |
| DCL                  | Control access to the database       | GRANT, REVOKE                                |
| TCL                  | Manage transactions                  | COMMIT, ROLLBACK, SAVEPOINT, SET TRANSACTION |
| DQL                  | Query data                           | SELECT                                       |




*/

/* SQL Select : Data Query Language (DQL)
It is one and only DQL command used to query or fetch data
The SELECT statement is used to select data from a database.

Eg : 
SELECT CustomerName, City FROM Customers;

Syntax
SELECT column1, column2, ...
FROM table_name;

Note: To select all columns, we have to use * (like SELECT * FROM CUSTOMER)


The SQL SELECT DISTINCT Statement
The SELECT DISTINCT statement is used to return only distinct (different) values.

Example
SELECT DISTINCT Country FROM Customers;
Inside a table, a column often contains many duplicate values; and sometimes you only want to list the different (distinct) values.

SELECT DISTINCT column1, column2, ...
FROM table_name;


Count Distinct
By using the DISTINCT keyword in a function called COUNT, we can return the number of different countries.

Example
SELECT COUNT(DISTINCT Country) FROM Customers;
Note: The COUNT(DISTINCT column_name) is not supported in Microsoft Access databases.

*/


