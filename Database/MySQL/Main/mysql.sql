/*Database Commands */

CREATE DATABASE saisakthi12;
/* We can create Databases using CREATE command */
use saisakthi12; /* Don't forget to use "use" command before creating a table */
drop database saisakthi12;
show databases;
CREATE DATABASE myDb;
alter database myDb read only = 1;
alter DATABASE myDb read only = 0;
use myDb;

/* Table Commnads */

CREATE table employee_main(emp_id int(20), emp_name varchar(100), salary float(10));
INSERT into employee_main VALUES(1,"sai", 23456.233);
SELECT * from employee_main;




