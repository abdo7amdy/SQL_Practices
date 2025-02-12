---------------------------------------Practices
---------------------------------------Part 01
Use ITI 
--1.	Write a query to select the highest two salaries in Each Department for instructors who have salaries.
--      “Using one of Ranking Functions”
go
SELECT Dept_Id, Ins_Id, Salary
FROM (  SELECT ins.Dept_Id,ins.Ins_Id,ins.Salary,
        RANK() OVER (PARTITION BY ins.Dept_Id ORDER BY ins.Salary DESC) AS Rank
        FROM Instructor as ins 
        WHERE Salary IS NOT NULL
     )  as RankedSalaries
WHERE Rank <= 2
ORDER BY Dept_Id, Rank;
go
--2.	 Write a query to select a random student from each department.  “Using one of Ranking Functions”
go
SELECT Dept_Id, St_Id
FROM ( SELECT s.Dept_Id, s.St_Id,
       ROW_NUMBER() OVER (PARTITION BY s.Dept_Id ORDER BY NEWID()) AS RowNum
       FROM Student s
     )  as RandomizedStudents
WHERE RowNum = 1;


----------------------------Part 02(Functions)

--1.	Create a scalar function that takes a date and returns the Month name of that date.
go
create function GetMonthNameByDATE( @Date Date ) 
returns nvarchar(25)
begin 
     declare @Month_Name nvarchar(25)
	 SET @Month_Name = DATENAME(MONTH, @Date);
     RETURN @Month_Name;
end 
go
SELECT dbo.GetMonthName('2024-11-26') AS MonthName;

--2.	 Create a multi-statements table-valued function that takes 2 integers and returns the values between them.
go
create function GetValuesBetween( @Start int, @End int)
returns @ValuesTable table([Value] int)
AS
begin
    declare @Current int = @Start + 1;
    while @Current < @End
    begin
        insert into @ValuesTable ([Value])
        values (@Current);
		SET @Current = @Current + 1;
    end;
	return;
end;
go
SELECT * FROM dbo.GetValuesBetween(1,7) 

--3.	 Create a table-valued function that takes Student No and returns Department Name with Student full name.
go
create function GetDeptNameAndStdFullName(@StdNo int)
returns table 
as
return( SELECT S.St_Id, CONCAT(S.St_Fname, ' ', S.St_Lname) AS FullName, D.Dept_Name
        FROM Student S  INNER JOIN Department D ON S.Dept_Id = D.Dept_Id
        WHERE S.St_Id = @StdNo
	  )
go
select * from GetDeptNameAndStdFullName(2)

--4.	Create a scalar function that takes Student ID and returns a message to user. 
--         a. If first name and Last name are null, then display 'First name & last name     are null.'
--         b. If First name is null, then display 'first name is null'
--         c. If Last name is null, then display 'last name is null.'
--         d. Else display 'First name & last name are not null'
go
create function ReturnMsg2User(@Std_Id int)
returns nvarchar (50)
AS
begin
     declare @UserMsg nvarchar(66) ;
	 declare @FName nvarchar(44) ;
	 declare @LName nvarchar(44) ;

	 select @FName = s.St_Fname , @LName = s.St_Lname
	 from Student s
	 where s.St_Id = @Std_Id

	 if @FName is null and @LName is null 
	 Set @UserMsg = 'First name & last name are null.'

	 else if @FName is null 
	 Set @UserMsg = 'first name is null'

	 else if @LName is null 
	 Set @UserMsg = 'last name is null.'
	 
	 else 
	 Set @UserMsg = 'First name & last name are not null'

	 return @UserMsg ;
end 
go

select dbo.ReturnMsg2User(12) AS NameStatus;

--5.	Create a function that takes an integer which represents the format of the Manager hiring date 
--      and displays department name, Manager Name and hiring date with this format. 
use MyCompany
go
CREATE FUNCTION GetManagerDetailsByFormat(@DateFormat INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        D.Dname,CONCAT(M.Fname, ' ', M.Lname) AS ManagerName,
        CASE 
            WHEN @DateFormat = 1 THEN FORMAT(D.[MGRStart Date], 'MM/dd/yyyy') 
            WHEN @DateFormat = 2 THEN FORMAT(D.[MGRStart Date], 'dd-MM-yyyy') 
            WHEN @DateFormat = 3 THEN FORMAT(D.[MGRStart Date], 'yyyy/MM/dd') 
            ELSE FORMAT(D.[MGRStart Date], 'yyyy-MM-dd') 
        END AS HiringDateFormatted
    FROM Departments D
    INNER JOIN Employee M ON D.MGRSSN = M.SSN
);
go

SELECT * FROM dbo.GetManagerDetailsByFormat(1);


--6.	Create multi-statement table-valued function that takes a string.
--        a.	If string='first name' returns student first name
--        b.	If string='last name' returns student last name 
--        c.    If string='full name' returns Full Name from student table  
--              Note: Use “ISNULL” function
use ITI
go
CREATE FUNCTION GetStudentNameDetail(@InputString NVARCHAR(50))
RETURNS @Result TABLE(StudentID INT,Name NVARCHAR(40))
AS
BEGIN
    IF @InputString = 'first name'
    BEGIN
        INSERT INTO @Result (StudentID, Name)
        SELECT St_Id, ISNULL(St_Fname, 'No First Name') AS Name
        FROM Student;
    END
    ELSE IF @InputString = 'last name'
    BEGIN
        INSERT INTO @Result (StudentID, Name)
        SELECT St_Id, ISNULL(St_Lname, 'No Last Name') AS Name
        FROM Student;
    END
       ELSE IF @InputString = 'full name'
    BEGIN
        INSERT INTO @Result (StudentID, Name)
        SELECT St_Id,ISNULL(St_Fname, 'No First Name') + ' ' + ISNULL(St_Lname, 'No Last Name') AS Name
        FROM Student;
    END
    RETURN;
END;
go

SELECT * FROM dbo.GetStudentNameDetail('first name');


--7.	Create function that takes project number and display all employees in this project (Use MyCompany DB)

USE MyCompany;
GO
CREATE FUNCTION dbo.GetEmployeesByProject( @ProjectNumber INT)
RETURNS TABLE
AS
RETURN ( SELECT E.SSN,CONCAT(E.Fname, ' ', E.Lname) AS FullName,P.Pname,w4.Hours
    FROM Employee E
    INNER JOIN Works_for w4 ON E.SSN = w4.ESSn
    INNER JOIN Project P ON w4.Pno = P.Pnumber
    WHERE P.Pnumber = @ProjectNumber
);
GO

SELECT * FROM dbo.GetEmployeesByProject(100);



---------------------------------Part 03 (Views)
-- Note : # means number and for example d2 means department which has id or number 2

Use ITI 
--1.	 Create a view that displays the student's full name, 
--       course name if the student has a grade more than 50. 
go
create view DisplayStudentCrsInfoView
as
       select CONCAT( s.St_Fname , ' ' , s.St_Lname ) as  FullName , Crs.Crs_Name
	   from Student s inner join Stud_Course Std_Crs on s.St_Id= Std_Crs.St_Id
	   inner join Course Crs on Crs.Crs_Id = Std_Crs.Crs_Id
	   where Std_Crs.Grade > 50
go
select * from dbo.DisplayStudentCrsInfoView

--2.	 Create an Encrypted view that displays manager names and the topics they teach. 
go
create view ManagerTopicView
with encryption 
as
      select ins.Ins_Name as manager_names , t.Top_Name as topic
	  from Instructor ins inner join Ins_Course insCrs on ins.Ins_Id = insCrs.Ins_Id
	  inner join Course crs on crs.Crs_Id = insCrs.Crs_Id
	  inner join Topic t on t.Top_Id = crs.Top_Id
go
select * from ManagerTopicView

--3.	 Create a view that will display Instructor Name, 
--       Department Name for the ‘SD’ or ‘Java’ Department “use Schema binding” 
--       and describe what is the meaning of Schema Binding
go
Create View dbo.InstructorDepartmentView
with schemabinding
as
     SELECT I.Ins_Name , D.Dept_Name
	 FROM dbo.Instructor I INNER JOIN dbo.Department  D ON I.Dept_Id = D.Dept_Id
     WHERE D.Dept_Name IN ('SD', 'Java');
go
-- Schema Binding it ensures that: The structure of the underlying objects (tables) 
--                                 cannot be modified as long as the view or function exists.
--                                 This includes:Adding or dropping columns , Renaming columns , Dropping tables. 
--                                 The view or function cannot reference objects from another database or server
SELECT * FROM dbo.InstructorDepartmentView;


--4.	 Create a view “V1” that displays student data for students who live in Alex or Cairo. 
--                       Note: Prevent the users to run the following query 
--                           Update V1 set st_address=’tanta’
--                            Where st_address=’alex’;
go
create view V1 
as
     select * from Student s
	 where s.St_Address in ( 'Alex ','Cairo')
	 WITH CHECK OPTION;
go

select * from V1

update  V1
set St_Address = 'tanta' Where St_Address='alex';

--5.	Create a view that will display the project name and the number of employees working on it.
--      (Use Company DB)
use MyCompany 
go
create view ProjectInfo
with encryption 
as 
      select p.Pname , COUNT(w4.ESSn) AS EmployeeCount
	  from Project p left join Works_for w4 on p.Pnumber = w4.Pno 
	  group by p.Pname
go
select * from ProjectInfo


--use CompanySD32_DB:
--1.	Create a view named   “v_clerk” that will display employee Number ,project Number,
--      the date of hiring of all the jobs of the type 'Clerk'.
use [SD32-Company]
go
create view v_clerk
as 
       select e.EmpFname+' '+e.EmpLname as FullName , p.ProjectNo , w4.Enter_Date
	   from HR.Employee e inner join dbo.Works_on w4 on e.EmpNo = w4.EmpNo
	   inner join HR.Project p on p.ProjectNo =w4.ProjectNo
	   where w4.Job =  'Clerk'
go
select * from v_clerk

--2.	Create view named  “v_without_budget” that will display all the projects data without budget
go
create view v_without_budget
as 
	select p.ProjectName as Project_Name,p.ProjectNo as Project_Number
	from HR.Project p
go
select * from v_without_budget

--3.	Create view named  “v_count “ that will display the project name and the Number of jobs in it
go
create view v_count 
as
   select p.ProjectName , COUNT(w4.Job) as NumberOfJob
   from HR.Project p inner join Works_on w4 on p.ProjectNo = w4.ProjectNo 
   group by p.ProjectName
go
select * from  v_count

--4.	Create view named ” v_project_p2” that will display the emp# s for the project# ‘p2’ .
--      (use the previously created view  “v_clerk”)
go
create view v_project_p2 
as
	select FullName	from v_clerk 
	where  ProjectNo = '2'
go
select* from v_project_p2

--5.	modify the view named  “v_without_budget”  to display all DATA in project p1 and p2.
use [SD32-Company]
go
create view v_without_budget 
AS
SELECT *
FROM HR.Project
WHERE HR.Project.ProjectNo IN (1, 2);
go
select * from v_without_budget

--6.	Delete the views  “v_ clerk” and “v_count”
Drop view v_clerk  

--7.	Create view that will display the emp# and emp last name who works on deptNumber is ‘d2’
go
create view EmpInfo
as
	select e.EmpNo as EmpNumber , e.EmpLname as EmpLastName 
	from HR.Employee e 
	where e.DeptNo = 2
go
select * from EmpInfo

--8.	Display the employee  lastname that contains letter “J” (Use the previous view created in Q#7)
select E.EmpLastName
from EmpInfo E
where E.EmpLastName LIKE '%J%'

--9.	Create view named “v_dept” that will display the department# and department name
go
create view v_dept
as 
	select d.DeptNo as DeptNumber, d.DeptName as DeptName
	from Department d
go
select * from v_dept
--10.	using the previous view try enter new department data where dept# is ’d4’ and dept name is ‘Development’
insert into v_dept
values (4,'Development')

--11.	Create view name “v_2006_check” that will display employee Number,
--      the project Number where he works and the date of joining the project 
--      which must be from the first of January and the last of December 2006.
--      this view will be used to insert data so make sure that the coming new data must match the condition
go
create view My_v_2006_check 
with Encryption
as
	select E.EmpNo as EmpNumber, W0.ProjectNo as ProjNumber, w0.Enter_Date as JoiningDate
	from HR.Employee E inner join Works_on w0 on E.EmpNo = w0.EmpNo
	WHERE w0.Enter_Date >= '2006-01-01' AND w0.Enter_Date <= '2006-12-31'
	with check option ;
go
select * from v_2006_check 


-------------------------Part 04A:Stored Procedure ------------------------------------------------------

--1.Create a stored procedure to show the number of students per department.[use ITI DB]
use ITI
go
create proc NumOfStdPerDept @DeptID int
as
	select s.Dept_Id as DepartmentID, COUNT(s.St_Id) as NumberOfStudentPerDepartment
	from Student s group by s.Dept_Id
	having s.Dept_Id = @DeptID ;

	NumOfStdPerDept 10

--2.Create a stored procedure that will check for the Number of employees 
--  in the project 100 if they are more than 3 print message to the user
--  “'The number of employees in the project 100 is 3 or more'” 
--  if they are less display a message to the user “'The following employees work for the project 100'” 
--  in addition to the first name and last name of each one. [use MyCompany DB] 
use MyCompany
go
create proc CheckEmployeesInProject100
as
    declare @emp_count int; -- Declare a variable to hold the employee count

    -- Count the number of employees working on project 100
    select COUNT(*) into emp_count
    from Work_for w4
    WHERE w4.Pno = 100;

    if @emp_count >= 3 
        select 'The number of employees in the project 100 is 3 or more' as message;
    else
        select 'The following employees work for the project 100'as message;
		select E.Fname, E.Lname
        from Employee E
        where E.SSN in (select ESSn from Works_for where Pno = 100)
    return ;
go


--3.Create a stored procedure that will be used in case an old employee has left the project,
--  and a new one becomes his replacement. The procedure should take 3 parameters (old Emp. number, new Emp.
--  number and the project number) and it will be used to update works_on table. [MyCompany DB]
go
create proc ReplaceEmployeeInProject(@old_emp_number int,@new_emp_number int,@project_number int)
as
    -- Update the works_on table to replace the old employee with the new employee
    update [dbo].[Works_for]
    set ESSn = @new_emp_number
    where ESSn = @old_emp_number and Pno = @project_number;

    -- Return a confirmation message
    SELECT CONCAT('Employee ', @old_emp_number, ' has been replaced by employee ', @new_emp_number,
	              ' in project ', @project_number) AS Message;
go



--———————————————————————————————————___________________________________________________________________

--Part 04B:Stored Procedure

--1.Create a stored procedure that calculates the sum of a given range of numbers
go
create proc CalculateSumOfRange(@start_num int,@end_num int )
as
    declare @total_sum int = 0
    declare @current_num int          

    -- Initialize the current number with the starting value
    set @current_num = @start_num;

    -- Loop through the range and calculate the sum
    while @current_num <= @end_num 
        set @total_sum = @total_sum + @current_num;  -- Add the current number to the total sum
        set @current_num = @current_num + 1          -- Increment the current number
        return ;
    SELECT @total_sum AS SumOfRange;
go

 use MyCompany
--2.Create a stored procedure that calculates the area of a circle given its radius
go

create proc CalculateCircleArea(@radius float )
as
    declare @area float; -- Variable to hold the calculated area

    -- Calculate the area of the circle using the formula πr²
    set @area = PI() * POWER(@radius, 2);

    -- Return the calculated area
    select @area as CircleArea;
go

--3.Create a stored procedure that calculates the age category based on a person's age 
--( Note: IF Age < 18 then Category is Child and if  Age >= 18 
--  AND Age < 60 then Category is Adult otherwise  Category is Senior)
go
create proc GetAgeCategory(@Age int )
as
    declare @category varchar(10) ; 
    if @age < 18 
	set @category = 'Child' ;
    else if @age >= 18 and @Age < 60 
        set @category = 'Adult';
    else
        set @category = 'Senior';
    select @category as AgeCategory;
go
--4.Create a stored procedure that determines the maximum, minimum,
--  and average of a given set of numbers ( Note : set of numbers as Numbers = '5, 10, 15, 20, 25')
-- ...?????????????????????????????????????????????????????????????????????????????????????????????
