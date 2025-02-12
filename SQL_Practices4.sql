--------------------------------Practices 4 
--------------------------------Part 01

--Use ITI DB :
use ITI
--Create an index on column (Hiredate) that allows you to cluster the data in table Department.
--What will happen?
create clustered index index_Hiredate 
on Department(Manager_hiredate);
--result is : Cannot create more than one clustered index on table 'Department'.
--            Drop the existing clustered index 'PK_Department' before creating another.
------------------------------------------------------------------------------------------------
--Create an index that allows you to enter unique ages in the student table. What will happen?
create clustered index index_UniqueAge 
on Student(St_Age);
--result is : Cannot create more than one clustered index on table 'Student'.
--            Drop the existing clustered index 'PK_Student' before creating another.
--------------------------------------------------------------------------------------------------
--Try to Create Login Named(RouteStudent) who can access Only student and Course tables from ITI DB 
--then allow him to select and insert data into tables and deny Delete and update
-- Create a Login for RouteStudent
create login RouteStudent
with password = 'Aa@RouteStd';

-- Create a database user for the login
create user RouteStudentUser for login RouteStudent;

-- Grant select and insert permissions on Student table
grant select, insert on Student to RouteStudentUser;

-- Grant select and insert permissions on Course table
grant select, insert on Course to RouteStudentUser;

-- Deny Delete and update on Student table
deny delete, update on Student to RouteStudentUser;

-- Deny delete and update on Course table
deny delete, update on Course to RouteStudentUser;

----------------------------------------------------------------------------------------------
--------------------------------Part 02
--Create a table named ‘ReturnedBooks’ With the Following Structure :
--User SSN
--Book Id
--Due Date
--Return
--Date
--fees
--then create A trigger that instead of inserting the data of returned book 
--checks if the return date is the due date  or not if not so the user must pay a fee 
--and it will be 20% of the amount that was paid before.
create table ReturnedBooks (
    UserSSN int not null,
    BookID int not null,
	primary key (UserSSN, BookID) ,-- Assuming UserSSN and BookID uniquely identify a return.
    DueDate date not null,
    ReturnDate date not null,
    Fees decimal default 0.00
    );

create trigger TriggerOfCheckReturnDate
on ReturnedBooks
instead of insert
as
    declare @UserSSN int;
    declare @BookID int;
    declare @DueDate date;
    declare @ReturnDate date;
    declare @Fees decimal(10, 2);
    declare @NewFees decimal(10, 2);

    -- Get the inserted values
    select @UserSSN = UserSSN,@BookID = BookID,@DueDate = DueDate,@ReturnDate = ReturnDate,@Fees = Fees
    from inserted;

    -- Check if the return date is after the due date
    if @ReturnDate > @DueDate
    -- Calculate the new fee as 20% of the previous fee
        set @NewFees = @Fees * 0.20;
    else
    -- No additional fee
        set @NewFees = 0.00;
    -- Insert the record into the table with the calculated fee
    insert into ReturnedBooks (UserSSN, BookID, DueDate, ReturnDate, Fees)
    Values (@UserSSN, @BookID, @DueDate, @ReturnDate, @NewFees);


--Create a trigger to prevent anyone from Modifying or Delete or Insert in the Employee table ( Display a message for user to tell him that he can’t take any action with this Table)
use MyCompany

create trigger Preventtrigger
on Employee
instead of insert , delete , update
as select 'u can not do any operation in this table '

insert into Employee(Fname,Lname)
Values('abdo','7amdy')

--Testing Referential Integrity , Mention What Will Happen When: 
--Create an index on column (Salary) that allows you to cluster the data in table Employee.
create nonclustered index indx_Salary
ON Employee(Salary);
----------------------------------------------------------------------------------------------------
--Try to Create Login With Your Name And give yourself access Only to Employee and Floor tables 
--then allow this login to select and insert data into tables and deny Delete and update 
--(Don't Forget To take screenshot to every step)

