/*                     Practices
Part 01
1)	From The Previous Assignment insert at least 2 rows per table. 
*/
use  Airline

insert into Airline(Id ,name , Address , ContactPerson)
values(10 ,'sea king' , 'cairo', 'Ahmed Diaa')

insert into Airline
values(20 ,'Madrid Travel' , 'Giza', 'Ahmed Ali')


insert into AirlinePhones(AirlineID , phone)
values(10,19570)

insert into AirlinePhones
values(20,19470)


insert into Employee( Name ,Address ,Gender , Position , DB_Day ,DB_Month ,DB_Year,AirlineID)-- id by identity
values( 'Ahmed' ,'cairo', 'M' , 'Head', 2000, 11,11  ,10)

insert into Employee
values( 'mona' ,'Giza', 'M' , 'depotManager', 1988, 3,21  ,20)-- id by identity


insert into EmpQualifications(EmpID,Qualifications)
values(20202, 'Computer Science')

insert into EmpQualifications
values(20201, 'Mec Engineering')


insert into Route(Id,Origin,Distance,Destination, Classification)
values(20241, 'Egy' ,24.3 ,'Moroco', 'Eco')


insert into Route
values(20242, 'Egy' ,24.3 ,'SoudiArabic', 'High')


insert into [Transaction] 
values(222222223, 'Vip' ,22000 ,'3-11-2002', 10)

insert into [Transaction] 
values(222222224, 'Vip' ,24400 ,'2001-4-12', 20)
----------------------------------------------------------------
use Hospital

insert into Consultant
values ('morad')  -- id by identity


insert into Consultant
values ('gamal')  -- id by identity

insert into Drugs
values(3)   -- id by identity


insert into Drugs
values(1)   -- id by identity
----------------------------------------------------------------
use Musicana

insert into Musician
values ('wael jassar',201010212710,'cairo','elmoez')

insert into Musician
values ('Amr Diab',201010200000,'Alex','megaStreet')

insert into Album
values('elkeif','3-11-2002',2)

insert into Album
values('moal','3-12-2022',1)
-----------------------------------------------------------------
use MyITI

 insert into Topics
 values('CS')

 insert into Topics
 values('IS')

 insert into Courses
 values('DS',12,'Data Structure',1)

 insert into Courses
 values('Algorithms',6,'Many Algorithms will be teached',2)

 --------------------------------------------------------------------
 use SalesOffice


 insert into Owner
 Values(1,'naguiba Ahmed')
 
 insert into Owner
 Values(2,'Mohamed Ahmed')

-------------------------------------------------------------------------------------------------------------------
/*
2) Data Manipulation Language:

1.Insert your personal data to the student table as a new Student in department number 30.
*/
use MyITI
insert into Students
values('Abdelrahman', 'Hamdy', 23, 'Ayat-Giza',30) -- id by identity
/*
2.Insert Instructor with personal data of your friend as new Instructor in department number 30,
Salary= 4000, but don’t enter any value for bonus.
*/
insert into Instructors 
values('NaderFarag','Giza-Ayat',null,4000,7.7,30) -- id by identity

/*
3.Upgrade Instructor salary by 20 % of its last value.
*/
UPDATE Instructors
SET Salary = Salary * 1.2
WHERE Dept_Id = 30;


------------------------------------------------------------------------------------------------------------------------------
-------------------------------------
------------------------------------------------------------------------------------------------------------------------------
/*                   Part 02

⮚	Restore MyCompany Database and then:
1.	Try to create the following Queries:
*/
use MyCompany
--1.	Display all the employees Data.
select *
from Employee

--2.	Display the employee First name, last name, Salary and Department number.
select Fname ,Lname , Salary ,Dno
from Employee

--3.	Display all the projects names, locations and the department which is responsible for it.
select Pname ,Plocation,Dnum
from Project

--4.	If you know that the company policy is to pay an annual commission for each employee with specific percent equals 10% of his/her annual salary .
--      Display each employee full name and his annual commission in an ANNUAL COMM column (alias).
SELECT CONCAT(Fname, ' ', Lname) AS FullName, 
    (Salary * 12 * 0.1) AS Annual_Comm
FROM Employee;

--5.	Display the employees Id, name who earns more than 1000 LE monthly.
SELECT SSN, CONCAT(Fname, ' ', Lname) AS FullName
FROM Employee
WHERE Salary > 1000;

--6.	Display the employees Id, name who earns more than 10000 LE annually.
SELECT SSN, CONCAT(Fname, ' ', Lname) AS FullName
FROM Employee 
WHERE Salary*12 > 10000;

--7.	Display the names and salaries of the female employees 
select CONCAT(Fname, ' ', Lname) AS [Name] ,Salary
from Employee
where Sex = 'F'

--8.	Display each department id, name which is managed by a manager with id equals 968574.
select Dnum , Dname 
from Departments
where MGRSSN =968574

--9.	Display the ids, names and locations of  the projects which are controlled with department 10.
select Pnumber , Pname , Plocation 
from Project
where Dnum = 10

------------------------------------------------------------------------------------------------------------------
----------------------------------------
------------------------------------------------------------------------------------------------------------------
/*         Part 03

⮚	Restore ITI Database and then:
*/
use MyITI
-- 1.	Get all instructors Names without repetition
Select Distinct Name
from Instructors
-- 2.	Display instructor Name and Department Name  
--      Note: display all the instructors if they are attached to a department or not

SELECT 
    Inst.Name AS InstructorName, 
    Dept.Name AS DepartmentName
FROM 
    Instructors inst
LEFT JOIN 
    Departments Dept
ON 
    inst.Dept_Id = Dept.Id;


-- 3.	Display student full name and the name of the course he is taking
--      For only courses which have a grade  
SELECT   CONCAT(Students.FName, ' ', Students.LName) AS StudentFullName,
         Courses.Name AS CourseName
FROM Std_Crs
     JOIN 
     Students 
	 ON Std_Crs.Std_Id = Students.Id
     JOIN 
     Courses 
	 ON Std_Crs.Crs_Id = Courses.Id
WHERE 
    Std_Crs.Grade IS NOT NULL;

----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
                -- Bouns
/*
Display results of the following two statements and explain what is the meaning of @@AnyExpression
select @@VERSION
select @@SERVERNAME
*/
--   @@ is a special syntax in SQL Server used to represent global variables that return system level information
--   These are predefined system variables not user-defined variables
select @@VERSION
--returns version information about the SQL Server instance you are connected to
--result -- Microsoft SQL Server 2022 (RTM-GDR) (KB5046861) - 16.0.1135.2 (X64)   Oct 18 2024 15:31:58  Copyright (C) 2022 Microsoft Corporation  Developer Edition (64-bit) on Windows 10 Pro 10.0 <X64> (Build 19045: ) 

select @@SERVERNAME
--returns the name of the local server that SQL Server is running on
--result -- DESKTOP-A1088VT\ABDOHAMDY

--------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------
-------------------------- Part 04
-- ⮚	Using MyCompany Database and try to  create the following Queries:
use MyCompany
--1.	Display the Department id, name and id and the name of its manager.
select Dept.Dnum , Dept.Dname , Mngr.SSN  ,(Mngr.Fname + ' ' + Mngr.Lname) As MngrName
from Departments Dept , Employee Mngr 
where Dept.MGRSSN = Mngr.SSN
--2.	Display the name of the departments and the name of the projects under its control.
select P.Pname , D.Dname
from Departments D, Project P
where P.Dnum = D.Dnum
--3.	Display the full data about all the dependence associated with the name of the employee they depend on .
select E.Fname ,D.*
from Dependent D , Employee E
where D.ESSN = E.SSN
--4.	Display the Id, name and location of the projects in Cairo or Alex city.
select P.Pnumber as ID , P.Pname as ProjectName , P.Plocation as Location
from Project P
Where P.City in('Cairo','Alex')
--5.	Display the Projects full data of the projects with a name starting with "a" letter.
select *
from Project P
where P.Pname like 'a%'
--6.	display all the employees in department 30 whose salary from 1000 to 2000 LE monthly
select *
from Employee E
where E.Dno = 30 and E.Salary between 1000 and 2000
--7.	Retrieve the names of all employees in department 10 who work more than or equal 10 hours per week on the "AL Rabwah" project.
select E.Fname + ' ' + E.Lname As Emp_Name
From Employee E inner join Departments D on E.Dno = D.Dnum
                inner join Works_for W4 on W4.ESSn = E.SSN
                inner join Project P on P.Dnum = D.Dnum
              where D.Dnum = 10 
              and 
		      P.Pname = 'AL Rabwah' 
			  and
			  W4.Hours >= 10
--8.	Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name.
select E.Fname , P.Pname
from Employee E inner join Works_for W4 
on W4.ESSn = E.SSN  inner join Project P 
on w4.Pno  = P.Pnumber
Order By P.Pname
--9.	For each project located in Cairo City , find the project number,
--      the controlling department name ,the department manager last name ,address and birthdate.
use MyCompany

Select P.Pnumber , D.Dname , E.Lname as MNGR_Lname, E.Address  as MNGR_Address , E.Bdate  as MNGR_BD
from Project P
 join Departments D  on P.Dnum = D.Dnum
 join Employee E on D.MGRSSN = E.SSN
 where P.City = 'Cairo'