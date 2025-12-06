create database saisakthi;

/*
used to create a database
 */
use saisakthi;
/*
this is a important command as we cannot use the database if we not mention it
 */
create table employees(
employee_no int(20),
employee_name varchar(20),
hourly_pay decimal(20),
hire_date date
);

/*
this is used to create a table in 
 */

select * from employees;
rename table employees to workers;

/*
This above command is used to rename table name
 */

show tables;

rename table workers to employees;

alter table employees
add phone_no INT(10);

select * from employees;

alter table employees 
rename column phone_no to email;

select * from employees;

alter table employees 
modify column email varchar(20);

alter table employees
modify email varchar(20)
after employee_no;

select * from employees;

alter table employees
modify email varchar(20)
first;

select * from employees;

alter table employees
drop column email;

select * from employees;
insert into employees values(1001,"Indiana",10.4,'24-4-23');

/* 
to insert multiple values , 
select * from employees;
insert into employees values(),(),(),();
*/

select * from employees;
SET SQL_SAFE_UPDATES = 0;

delete from employees where employee_name = "Indiana";
select * from employees;

insert into employees values(1001,"Arun",24.5,'2023-4-10');









