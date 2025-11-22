"""


mysql-connector-python : 
        It is a module in python used to connect mysql.
        

---------------------------------------------------------------------------------------------------------------

Connecting to MySQL Using Connector/Python
The connect() constructor creates a connection to the MySQL server and returns a MySQLConnection object.

The following example shows how to connect to the MySQL server:



import mysql.connector
from mysql.connector import errorcode

try:
    cnx = mysql.connector.connect(user='root',password='saisakthi@2008',
                                host='127.0.0.1')
    print("Connection Was Successful")
except mysql.connector.Error as err:
    if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print("Something is wrong with your user name or password")
    elif err.errno == errorcode.ER_BAD_DB_ERROR:
        print("Database does not exist")
    else:
        print(err)
else:
    cnx.close()
    
    
    
There are different ways to connect 
one of the ways is like


import mysql.connector

config = {
  'user': 'scott',
  'password': 'password',
  'host': '127.0.0.1',
  'database': 'employees',
  'raise_on_warnings': True
}

cnx = mysql.connector.connect(**config)

cnx.close()

---------------------------------------------------------------------------------------------------------------

Creating Tables Using Connector/Python : 

All DDL (Data Definition Language) statements are executed using a handle structure known as a cursor. 
The following examples show how to create the tables of the Employee Sample Database. 
You need them for the other examples.
In a MySQL server, tables are very long-lived objects, and are often accessed by multiple applications written in different languages.
You might typically work with tables that are already set up, rather than creating them within your own application. 
Avoid setting up and dropping tables over and over again, as that is an expensive operation. 
The exception is temporary tables, which can be created and dropped quickly within an application.


from __future__ import print_function

import mysql.connector
from mysql.connector import errorcode

DB_NAME = 'employees'

TABLES = {}
TABLES['employees'] = (
    "CREATE TABLE `employees` ("
    "  `emp_no` int(11) NOT NULL AUTO_INCREMENT,"
    "  `birth_date` date NOT NULL,"
    "  `first_name` varchar(14) NOT NULL,"
    "  `last_name` varchar(16) NOT NULL,"
    "  `gender` enum('M','F') NOT NULL,"
    "  `hire_date` date NOT NULL,"
    "  PRIMARY KEY (`emp_no`)"
    ") ENGINE=InnoDB")
    
    
    


The preceding code shows how we are storing the CREATE statements in a Python dictionary called TABLES. 
We also define the database in a global variable called DB_NAME, which enables you to easily use a different schema.




---------------------------------------------------------------------------------------------------------------

using a database in python : 

def use_database(cursor,DB_NAME):
    try:
        cursor.execute("USE {}".format(DB_NAME))
        print("Database is in use!")
    except mysql.connector.Error as err:
        print("Database {} does not exists.".format(DB_NAME))
        if err.errno == errorcode.ER_BAD_DB_ERROR:
            create_database(cursor)
            print("Database {} created successfully.".format(DB_NAME))
            cnx.database = DB_NAME
        else:
            print(err)
            exit(1)

use_database(cursor,"saisakthi")
                
We first try to change to a particular database using the database property of the connection object cnx. 
If there is an error, we examine the error number to check if the database does not exist. 
If so, we call the create_database function to create it for us.
On any other error, the application exits and displays the error message.
After we successfully create or change to the target database, we create the tables by iterating over the items of the TABLES dictionary:


------------------------------------------------------------------------------------------------------------------------------


Inserting or updating data is also done using the handler structure known as a cursor. 
When you use a transactional storage engine such as InnoDB (the default in MySQL 5.5 and higher), you must commit the data after a sequence of INSERT, DELETE, and UPDATE statements.

This example shows how to insert new data. 
The second INSERT depends on the value of the newly created primary key of the first. 
The example also demonstrates how to use extended formats. 
The task is to add a new employee starting to work tomorrow with a salary set to 50000.











































"""