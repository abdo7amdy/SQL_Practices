---------------------------- Practices -----------------------------------------------------------
----------------------------------------------------------------------------------------------------
--                          Part 01

 Use ITI 

--1.	Retrieve a number of students who have a value in their age. 

select Count(*)
from Student S
where S.St_Age is not null

--2.	Display number of courses for each topic name 

select T.Top_Name , Count(*) AS Crs_Count
from Course Crs inner join Topic T
on Crs.Top_Id = T.Top_Id
Group by T.Top_Name ;

--3.	Select Student first name and the data of his supervisor 

select Std.St_Fname , inst.*
from Student Std inner join Instructor Inst
on Std.St_super = Inst.Ins_Id

--4.	Display student with the following Format (use isNull function)
--      Student ID	Student Full Name	Department name
		
select s.St_Id as 'Student ID', ISNULL(s.St_Fname , '')+ ' ' + ISNULL(s.St_Lname , '') as 'Student Full Name' ,
 isnull(d.Dept_Name , 'unknown') As 'Department name'
from Student s left join Department d
on s.Dept_Id = d.Dept_Id 

--5.	Select instructor name and his salary but if there is no salary display value ‘0000’ . “use one of Null Function” 

select ins.Ins_Name , ISNULL(CAST( ins.Salary as varchar), '0000')
from Instructor ins

--6.	Select Supervisor first name and the count of students who supervises on them

select ins.Ins_Name as InstructorName, count(std.St_Id) As NumOfStudent
from Instructor ins inner join Student std
on std.St_super = ins.Ins_Id
group by ins.Ins_Name

--7.	Display max and min salary for instructors

select MAX(Salary) as maxSalaary ,MIN(Salary) as minSalary
from Instructor

--8.	Select Average Salary for instructors 

 select AVG(Salary)
 from Instructor

--9.	Display instructors who have salaries less than the average salary of all instructors.

select Ins_Name , Salary
from Instructor 
where Salary < (select AVG(Salary) from Instructor)

--10.	Display the Department name that contains the instructor who receives the minimum salary

Select d.Dept_Name
from Department d join Instructor ins
on d.Dept_Id = ins.Dept_Id
where ins.Salary = (select MIN(s.Salary) from Instructor s)

----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------

--                                               Part 02

Use MyCompany 
-----------------------------------  DQL:
--1.	For each project, list the project name and the total hours per week (for all employees) spent on that project.

select P.Pname AS 'project name',SUM(w4.Hours) AS 'total hours per week'
from project P inner join Works_for  w4
on w4.Pno = P.Pnumber
group by P.Pname ;

--2.	For each department, retrieve the department name and the maximum, minimum and average salary of its employees.

select d.Dname as Dname, MAX(e.Salary) As MaxSalary , MIN(e.Salary) AS MinSalary, AVG(e.Salary) AsgSalary
from Departments d left join Employee e
on e.Dno = d.Dnum
group by d.Dname

--3.	Retrieve a list of employees and the projects they are working on ordered by department and within each department,
--      ordered alphabetically by last name, first name.

select e.Fname + ' ' + e.Lname AS Emp_Name , p.Pname as ProjectName,d.Dname as DeptName
from Employee e join Departments d 
on e.Dno = d.Dnum 
join Works_for w4
on e.SSN = w4.ESSn 
join Project p
on w4.Pno = p.Pnumber
order by d.Dname , e.Fname , e.Lname 

--4.	Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30% 

UPDATE Employee
SET Salary = Salary*1.3
where SSN IN (select E.SSN
from Employee E join Works_for w4
on w4.ESSn = E.SSN 
join Project P
on w4.Pno = p.Pnumber
where p.Pname = 'Al Rabwah'
);

-----------------------------------  DML:
--1.	In the department table insert a new department called "DEPT IT" ,
--      with id 100, employee with SSN = 112233 as a manager for this department. The start date for this manager is '1-11-2006'.

insert into Departments 
values('DEPT IT' , 100 , 112233 , '1-11-2006')

--2.	Do what is required if you know that : Mrs.Noha Mohamed(SSN=968574)  moved to be the manager of the new department (id = 100), 
--      and they give you(your SSN =102672) her position (Dept. 20 manager) 

-- a.	First try to update her record in the department table
        update Employee
		set Dno = 100
		where SSN = 968574

        update Departments 
		set MGRSSN = (select SSN from Employee where SSN = 968574 )
		where Dnum = 100

-- b.	Update your record to be department 20 manager.
      	update Employee
		set Dno = 20
		where SSN = 102672

        update Departments
		set MGRSSN = (select SSN from Employee where SSN = 102672)
		where Dnum = 20
-- c.	Update the data of employee number=102660 to be in your teamwork (he will be supervised by you) (your SSN =102672)
        
		update Employee
		set Superssn = 102672
		where SSN = 102660

--3.	Unfortunately the company ended the contract with  Mr.Kamel Mohamed (SSN=223344)
--      so try to delete him from your database in case you know that you will be temporarily in his position.
--      Hint: (Check if Mr. Kamel has dependents, works as a department manager, supervises any employees or works in any projects
--      and handles these cases).

        select * from Dependent  depend where depend.ESSN = 223344
		delete from Dependent where ESSN = 223344

		select * from Departments d  where d.MGRSSN  = 223344

		select SSN from Employee where Superssn = 223344
		update Employee
		set Superssn = 123456
		where SSN = 112233		
		update Employee
		set Superssn = 123456
		where SSN = 123456

        select * from Works_for w4 where w4.ESSn = 223344
		delete from Works_for where ESSn = 223344		
		
		delete from Employee where SSN = 223344

------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
--                                                Part 03

--  ⮚	Using MyCompany Database and try to  create the following Queries:

-- 1.	Retrieve the names of all employees in department 10 who work more than or equal 10 hours per week on the "AL Rabwah" project.

select (e.Fname + ' ' + e.Lname)  as FullName from Employee e 
left join Works_for w4
on w4.ESSn = e.SSN  
left join Project p 
on w4.Pno = p.Pnumber
where e.Dno = 10 AND P.Pname = 'AL Rabwah' AND w4.Hours >= 10


-- 2.	Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name

select p.Pname as ProjectName , (e.Fname +' ' + e.Lname) as EmployeeName
from Employee e inner join Works_for w4 
on w4.ESSn = e.SSN  inner join Project p
on w4.Pno = p.Pnumber 
order by p.Pname

-- 3.	For each project located in Cairo City , find the project number, the controlling department name ,
--      the department manager last name ,address and birthdate.

select p.Pnumber AS Project_Number , d.Dname AS Ctrl_Department_Name , e.Lname AS Mngr_Lname , e.Bdate AS Mngr_BirthDate
from project p inner join Departments d
on p.Dnum = d.Dnum 
inner join Employee e 
on d.MGRSSN = e.SSN
where p.City = 'Cairo'

-- 4.	Display the data of the department which has the smallest employee ID over all employees' ID.

select d.*
from Departments d 
where d.Dnum = (select e.Dno from Employee e
                where e.SSN =  ( select MIN(e.SSN) from Employee e )                
			   )
-- 5.	List the last name of all managers who have no dependents

select Lname 
from Employee e join Departments d 
on e.SSN = d.MGRSSN 
where e.SSN not in (select DISTINCT depend.ESSN from Dependent depend);

-- 6.	For each department-- if its average salary is less than the average salary of all employees display its number,
--      name and number of its employees.

SELECT    d.Dnum,    d.Dname,    COUNT(e.SSN) AS number_of_employees
FROM Departments d INNER JOIN Employee e
ON  d.Dnum = e.Dno
GROUP BY 
    d.Dnum, d.Dname
HAVING 
    AVG(e.salary) < (SELECT AVG(salary) FROM Employee);

-- 7.	Try to get the max 2 salaries using subquery

SELECT   MAX(salary) AS highest_salary
FROM     Employee
UNION All
SELECT   MAX(salary) 
FROM     Employee
WHERE    salary < (SELECT MAX(salary) FROM Employee) ;

