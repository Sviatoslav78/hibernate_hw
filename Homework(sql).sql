create database homework_sql;

create table developer
(id int auto_increment primary key,
name varchar(300),
age int,
sex varchar(30));

create table skill
(id int auto_increment primary key,
branch varchar(50),
level varchar(50));

create table customer
(id int auto_increment primary key,
name varchar(300),
age int);

create table project
(id int auto_increment primary key,
name varchar(100),
customer_id int,
foreign key(customer_id) references customer(id));

create table company
(id int auto_increment primary key,
name varchar(300),
developers_number int);

create table company_developer
(company_id int,
developer_id int,
primary key(company_id, developer_id),
foreign key(company_id) references company(id),
foreign key(developer_id) references developer(id));

create table project_developer_company
(project_id int,
developer_id int,
company_id int,
primary key(project_id, developer_id, company_id),
foreign key(project_id) references project(id),
foreign key(developer_id) references developer(id),
foreign key(company_id) references company(id));

create table developer_skill
(developer_id int,
skill_id int,
primary key(developer_id, skill_id),
foreign key(developer_id) references developer(id),
foreign key(skill_id) references skill(id));

--------------------------------------------------

insert into company (name, developers_number)
values ('Microsoft', 1000), ('Oracle', 800), ('Ubisoft', 700);

insert into customer (name, age)
values ('Ivan', 27), ('Maksim', 35), ('Anna', 28);

insert into developer (name, age, sex)
values ('Natalia', 29, 'female'), ('Ksenia', 27, 'female'), ('Katerina', 17, 'female'), ('Sviatoslav', 17, 'male'), ('Ivan', 26, 'male');

insert into skill (branch, level)
values ('Java', 'Junior'), ('Java', 'Senior'), ('C++', 'Junior'), ('C#', 'Middle');

insert into project (name, customer_id)
values ('Smart Glasses', 1), ('Red Hat', 2), ('Watch Dogs 3', 3);

-- Natalia works in Ubisoft
-- Ksenia works in Oracle
-- Katerina doesn't work
-- Sviatoslav works in Ubisoft
-- Ivan works in Microsoft and in Oracle
insert into company_developer (company_id, developer_id)
values (3 , 1), (2 , 2), (3 , 4), (1 , 5), (2, 5);

-- smart glasses - Microsoft
-- red hat - Oracle
-- watch dogs 3 - Ubisoft
insert into project_developer_company (project_id, developer_id, company_id)
values (1, 5, 1), (2, 2, 2), (2, 5, 2), (3, 1, 3), (3, 4, 3);

-- Natalia - C++(Junior)
-- Ksenia - Java(Junior)
-- Katerina - C#(Junior)
-- Sviatoslav - Java(Junior), C++(Junior)
-- Ivan - Java(Senior), C++(Junior)
insert into developer_skill (developer_id, skill_id)
values (1, 3), (2, 1), (3, 4), (4, 1), (4, 3), (5, 2), (5, 3);

---------------------------------------------------------------------------
select * from project;
-- 1)
alter table developer add salary int;

update developer set salary = 1000  where name = 'Natalia';
update developer set salary = 800  where name = 'Ksenia';
update developer set salary = 0  where name = 'Katerina';
update developer set salary = 1000  where name = 'Sviatoslav';
update developer set salary = 1500  where name = 'Ivan';

-- 2)
-- из-за слегка неправильной структуры моих таблиц у меня не получается 2-ой запрос

-- 3)
select sum(d.salary)
from developer d, developer_skill ds, skill s
where d.id = ds.developer_id and s.id = ds.skill_id and s.branch = 'Java';

-- 4) 
alter table project add cost int;

update project, developer set cost = 1500 where project.name = 'Smart Glasses';
update project, developer set cost = 1300 where project.name = 'Red Hat';
update project, developer set cost = 2000 where project.name = 'Watch Dogs 3';

-- 5)
-- Red Hat
select name, cost
from project
where cost = (select min(cost) from project);

-- 6)
-- (1500 + 800)/2 = 1150
select avg(d.salary)
from developer d, project p, project_developer_company pdc
where d.id = pdc.developer_id and p.id = pdc.project_id and p.name = (select p.name from project p where cost = (select min(cost) from project));