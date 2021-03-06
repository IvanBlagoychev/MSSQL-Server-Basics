Built-in Functions Homework

01. -- select FirstName, LastName from Employees where left(Firstname, 2) = 'SA'

02. -- select FirstName, LastName from Employees where LastName like '%ei%'

03. -- select FirstName from Employees where (DepartmentID = 3 or DepartmentID = 10) or HireDate between 1995 and 2005

04. -- select FirstName, LastName from Employees where not JobTitle like '%engineer%'

05. -- select Name from Towns where len(Name) = 5 or len(Name) = 6 order by Name

06. -- select TownId, Name from Towns where left(Name,1) = 'M' or left(Name,1) = 'K' or left(Name,1) = 'B' or left(Name,1) = 'E' order by Name

07. -- select TownId, Name from Towns where not (left(Name,1) = 'R' or left(Name,1) = 'B' or left(Name,1) = 'D') order by Name

08. -- create view V_EmployeesHiredAfter2000 as select FirstName, LastName from Employees
where datepart(year, HireDate) > 2000

09. -- select FirstName, LastName from Employees where len(LastName) = 5

10. -- select CountryName, IsoCode FROM Countries
where (len(CountryName) - LEN(replace(lower(CountryName), 'a', ''))) >= 3
order by IsoCode

11. -- select PeakName, RiverName, LOWER(PeakName+ cast(SUBSTRING(RiverName,2,len(RiverName)-1) as varchar)) as Mix
from Peaks, Rivers where right(PeakName,1) = left(RiverName,1)
order by Mix

12. -- select top(50) Name, format(Start, 'yyyy-MM-dd') as Started from Games
where datepart(year, Start) between 2011 and 2012
order by Start, Name

13. -- select Username, replace(Email,substring(Email,1,CHARINDEX('@', Email, 1)) ,'')as EmailProvider from Users
order by EmailProvider, Username

14. -- select Username , IpAddress from Users where IpAddress like '___.1%.%.___'
order by Username

15. -- select Name as Game, 
case
WHEN datepart(hour, Start) between 0 and 11 then 'Morning'
WHEN datepart(hour, Start) between 12 and 17 then 'Afternoon'
WHEN datepart(hour, Start) between 18 and 23 then 'Evening'
end as [Part of the Day],
case
when Duration <= 3 then 'Extra Short'
when Duration between 4 and 6 then 'Short'
when Duration > 6 then 'Long'
when Duration is null then 'Extra Long'
end as [Duration]
 from Games
 order by Game,Duration,[Part of the Day]

16. -- select ProductName, OrderDate, dateadd(day,3,OrderDate) as PayDue, dateadd(month, 1, OrderDate) as DeliverDue from Orders

17. -- 