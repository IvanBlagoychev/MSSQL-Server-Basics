Basic CRUD Homework

02. -- Find All Information About Departments

select * from Departments

------------------------------------------------------------------------------------------------------------------

03. -- Find all Department Names

select Name from Departments

-------------------------------------------------------------------------------------------------------------------

04. Find Salary of Each Employee

select FirstName, LastName, Salary from Employees

-------------------------------------------------------------------------------------------------------------------

05. -- Find Full Name of Each Employee

select FirstName, MiddleName, LastName from Employees

-------------------------------------------------------------------------------------------------------------------

06. -- Find Email Address of Each Employee

select FirstName + '.' + LastName + '@softuni.bg'  as "Full Email Addres" from Employees

-------------------------------------------------------------------------------------------------------------------

07. -- Find All Different Employee’s Salaries

select distinct Salary from Employees

-------------------------------------------------------------------------------------------------------------------

08. -- Find all Information About Employees

select * from Employees
where JobTitle = 'Sales Representative'

-------------------------------------------------------------------------------------------------------------------

09. -- Find Names of All Employees by Salary in Range

select FirstName, LastName, JobTitle from Employees
where Salary between 20000 and 30000

-------------------------------------------------------------------------------------------------------------------

10. -- Find Names of All Employees

select FirstName + ' ' + MiddleName + ' ' + LastName  as "Full Name" from Employees
where Salary = 25000 or Salary = 14000 or Salary = 12500 or Salary = 23600

-------------------------------------------------------------------------------------------------------------------

11. -- Find All Employees Without Manager

select FirstName, LastName from Employees
where ManagerID is null

-------------------------------------------------------------------------------------------------------------------

12. -- Find All Employees with Salary More Than

select FirstName, LastName, Salary from Employees
where Salary >= 50000
order by Salary desc

-------------------------------------------------------------------------------------------------------------------

13. -- Find 5 Best Paid Employees

select top(5) FirstName, LastName from Employees
order by Salary desc

-------------------------------------------------------------------------------------------------------------------

14. -- Find All Employees Except Marketing

select FirstName, LastName from Employees
where not DepartmentID = 4

-------------------------------------------------------------------------------------------------------------------

15. --Sort Employees Table

select * from Employees
order by Salary desc,  FirstName , LastName desc, MiddleName

-------------------------------------------------------------------------------------------------------------------

16. -- Create View Employees with Salaries

create view V_EmployeesSalaries as 
	select FirstName, LastName, Salary from Employees

-------------------------------------------------------------------------------------------------------------------

17. -- Create View Employees with Job Titles

CREATE VIEW V_EmployeeNameJobTitle AS
SELECT FirstName + ' ' + ISNULL(MiddleName, '') + ' ' + LastName AS [Full Name], JobTitle 
FROM Employees

-------------------------------------------------------------------------------------------------------------------

18. -- Distinct Job Titles

select distinct JobTitle from Employees

-------------------------------------------------------------------------------------------------------------------

19. -- Find First 10 Started Projects

select top(10) *  from Projects
order by StartDate, Name

-------------------------------------------------------------------------------------------------------------------

20. -- Last 7 Hired Employees

select top(7) FirstName, LastName, HireDate from Employees
order by HireDate desc

-------------------------------------------------------------------------------------------------------------------

21. -- Increase Salaries

update Employees
set Salary = Salary + (Salary * 0.12)
where DepartmentID = 1 or DepartmentID = 2 or DepartmentID = 4 or DepartmentID = 11

select Salary from Employees

-------------------------------------------------------------------------------------------------------------------

22. -- All Mountain Peaks

select PeakName from Peaks
order by PeakName

-------------------------------------------------------------------------------------------------------------------

23. -- Biggest Countries by Population

select top(30) CountryName, Population from Countries
where ContinentCode = 'EU'
order by [Population] desc, [CountryName] asc

-------------------------------------------------------------------------------------------------------------------

24. -- Countries and Currency (Euro / Not Euro)

SELECT CountryName, CountryCode, Currency =  
      CASE CurrencyCode  
         WHEN 'EUR' THEN 'Euro'            
         ELSE 'Not Euro'  
      END  FROM Countries
ORDER BY CountryName; 

-------------------------------------------------------------------------------------------------------------------

25. -- All Diablo Characters

select Name from Characters
  order by Name