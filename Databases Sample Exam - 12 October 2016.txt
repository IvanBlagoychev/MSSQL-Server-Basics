Databases Sample Exam - 12 October 2016 Practise


Section 1: DDL

create table DepositTypes
(
	DepositTypeID int primary key,
	Name varchar(20)
)

create table Deposits
(
	DepositID int primary key identity,
	Amount decimal(10,2),
	StartDate date,
	EndDate date,
	DepositTypeID int foreign key references DepositTypes(DepositTypeID),
	CustomerID int foreign key references Customers(CustomerID)
)

create table EmployeesDeposits
(
	EmployeeID int,
	DepositID int,
	constraint PK_EmployeesDeposits primary key (EmployeeID, DepositID),
	constraint FK_EmployeeID_EmployeeID foreign key (EmployeeID) references Employees(EmployeeID),
	constraint FK_DepositID_DepositID foreign key (DepositID) references Deposits(DepositID)
)

create table CreditHistory
(
	CreditHistoryID int primary key,
	Mark char(1),
	StartDate date,
	EndDate date,
	CustomerID int foreign key references Customers(CustomerID)	
)

create table Payments
(
	PayementID int primary key,
	Date date,
	Amount decimal(10,2),
	LoanID int foreign key references Loans(LoanID)
)

create table Users
(
	UserID int primary key,
	UserName varchar(20),
	Password varchar(20),
	CustomerID int foreign key references Customers(CustomerID) unique
)

alter table Employees
add ManagerID int foreign key references Employees(EmployeeID)


----------------------------------------------------------------------------------------------------------------

Section 2: DML - P01. Inserts

insert into DepositTypes(DepositTypeID, Name)
	values ( 1, 'Time Deposit'), (2, 'Call Deposit'), (3, 'Free Deposit')

insert into Deposits (Amount, StartDate, EndDate, DepositTypeID, CustomerID)
select case 
			when c.DateOfBirth > '1980-01-01' then 1000
			else 1500
		end 
			+
		case 
			when c.Gender = 'M' then 100
			when c.Gender = 'F' then 200
		end as Amount,
			GETDATE() as StartDate,
			NULL as EndDate,
			case when c.CustomerID > 15 then 3
				 when c.CustomerID % 2 = 0 then 2
				 when c.CustomerID % 2 != 0 then 1				
				end as DepositTypeID,
				c.CustomerID from Customers as c where c.CustomerID < 20
 
 insert into EmployeesDeposits (EmployeeID,DepositID)
values (15,	4), (20, 15), (8, 7), (4, 8), (3, 13), (3, 8), (4, 10), (10, 1), (13, 4), (14,9)


----------------------------------------------------------------------------------------------------------------

Section 2: DML - P02. Update

update Employees
set ManagerID = case when EmployeeID between 2 and 10 then 1
					 when EmployeeID between 12 and 20 then 11
					 when EmployeeID between 22 and 30 then 21
					 when EmployeeID = 11 or EmployeeID = 21 then 1
					 end

----------------------------------------------------------------------------------------------------------------

Section 2: DML - P03. Delete

delete from EmployeesDeposits
where DepositID = 9 or EmployeeID = 3

----------------------------------------------------------------------------------------------------------------

Section 3: Querying - P01. Employees’ Salary

select EmployeeID, HireDate, Salary, BranchID from Employees
where Salary > 2000 and HireDate > '2009-06-15'

----------------------------------------------------------------------------------------------------------------

Section 3: Querying - P02. Customer Age

select FirstName, DateOfBirth, datediff(year, DateOfBirth, '2016-10-01') as Age from Customers
where datediff(year, DateOfBirth, '2016-10-01') between 40 and 50

----------------------------------------------------------------------------------------------------------------

Section 3: Querying - P03. Customer City

select c.CustomerID, c.FirstName, LastName, c.Gender, ct.CityName from Customers as c
join Cities as ct on c.CityID = ct.CityID
where (substring(FirstName,len(FirstName), 1) = 'a' or substring(LastName,1, 2) = 'Bu') and len(ct.CityName) >= 8
  order by CustomerID

----------------------------------------------------------------------------------------------------------------

Section 3: Querying - P04. Employee Accounts

select top 5 e.EmployeeID, e.FirstName, a.AccountNumber from Employees as e
join EmployeesAccounts as ea on e.EmployeeID = ea.EmployeeID
join Accounts as a on ea.AccountID = a.AccountID
where a.StartDate > '2012'
order by e.FirstName desc

----------------------------------------------------------------------------------------------------------------

Section 3: Querying - P05. Count Cities

select c.CityName,b.Name, count(e.EmployeeID) as EmployeesCount from Cities as c
join Branches as b on c.CityID = b.CityID
join Employees as e on b.BranchID = e.BranchID
where c.CityID not in (4,5)
group by c.CityName, b.Name
having count(e.EmployeeID) > 2

----------------------------------------------------------------------------------------------------------------

Section 3: Querying - P06. Loan Statistics

select sum(l.Amount) as TotalLoanAmount, max(l.Interest) as MaxInterest, min(e.Salary) as MinEmployeeSalary from Loans as l
join EmployeesLoans as el on l.LoanID = el.LoanID
join Employees as e on el.EmployeeID = e.EmployeeID

----------------------------------------------------------------------------------------------------------------

Section 3: Querying - P07. Unite People

select top 3 e.FirstName,c.CityName from Employees as e
join Branches as b on e.BranchID = b.BranchID
join Cities as c on b.CityID = c.CityID 
union all
select top 3 cu.FirstName, c.CityName from Customers as cu 
join Cities as c on cu.CityID = c.CityID


----------------------------------------------------------------------------------------------------------------

Section 3: Querying - P08. Customers w/o Accounts

select CustomerID , Height from Customers
where CustomerID not in (select CustomerID from Accounts) and Height between 1.74 and 2.04

----------------------------------------------------------------------------------------------------------------

Section 3: Querying - P09. Average Loans

select top 5 c.CustomerID, l.Amount from Customers as c
join Loans as l on c.CustomerID = l.CustomerID
where l.Amount > (select avg(l.Amount) from Loans  as l
join Customers as c on l.CustomerID = c.CustomerID
 where c.Gender = 'M')
order by c.LastName

----------------------------------------------------------------------------------------------------------------

Section 3: Querying - P10. Oldest Account

select top 1 c.CustomerID, c.FirstName, a.StartDate from Customers as c
join Accounts as a on c.CustomerID = a.CustomerID
order by a.StartDate 

----------------------------------------------------------------------------------------------------------------

Section 4: Programmability - P01. String Joiner

create function udf_ConcatString (@Str1 varchar(max), @Str2 varchar(max))
returns varchar(max)
as
begin	 
	return CONCAT(reverse(@Str1), reverse(@Str2))
end

----------------------------------------------------------------------------------------------------------------

Section 4: Programmability - P02. Inexpired Loans

create proc usp_CustomersWithUnexpiredLoans (@CustomerID int)
as 
begin
if @CustomerID in (select c.CustomerID from Customers as c
				join Loans as l on c.CustomerID = l.CustomerID
				where l.ExpirationDate is NULL)
	begin
		select c.CustomerID, c.FirstName, l.LoanID from Customers as c
		join Loans as l on c.CustomerID = l.CustomerID
		where l.ExpirationDate is NULL and c.CustomerID = @CustomerID
	end
else 
	begin
		select c.CustomerID, c.FirstName, l.LoanID from Customers as c
		join Loans as l on c.CustomerID = l.CustomerID
		where 0=1
		end

end

----------------------------------------------------------------------------------------------------------------

Section 4: Programmability - P03. Take Loan

create proc usp_TakeLoan (@CustomerID int, @LoanAmount money, @Interest money, @StartDate date)
as
	begin
	begin tran
		if @LoanAmount not between 0.01 and 100000 
			begin
				raiserror ('Invalid Loan Amount.',16,1)
				rollback
			end
		else
			begin
				insert into Loans(StartDate, Amount, Interest, ExpirationDate, CustomerID)
				values(@StartDate, @LoanAmount, @Interest, null, @CustomerID)
				commit
			end
	end

----------------------------------------------------------------------------------------------------------------

Section 4: Programmability - P04. Hire Employee

create trigger TR_HireEmployee on Employees after insert
as
	begin
		update EmployeesLoans
		set EmployeeID = i.EmployeeId
		from EmployeesLoans as e
		join inserted as i 
  		on e.EmployeeID + 1 = i.EmployeeID
	end


----------------------------------------------------------------------------------------------------------------

Section 5: Bonus - P01. Delete Trigger

create trigger TR_DelTrig on Accounts instead of  delete
as begin
	delete from EmployeesAccounts where AccountID in (select d.AccountID from deleted as d)
	insert into AccountLogs
	select * from deleted
	delete Accounts
	where AccountID in (select d.AccountID from deleted as d)
end

