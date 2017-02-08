Joins, Subqueries, CTE and Indices Homework

01. -- Employee Address

select top 5 e.EmployeeID, e.JobTitle, e.AddressID, a.AddressText from Employees as e
join Addresses as a
on e.AddressID = a.AddressID
order by AddressID

----------------------------------------------------------------------------------------------------------------
02. -- Addresses with Towns

select top 50 e.FirstName, e.LastName, t.Name as Town, AddressText from Employees as e
join Addresses as a 
on a.AddressID = e.AddressID
join Towns as t
on t.TownID = a.TownID
order by e.FirstName, e.LastName

-----------------------------------------------------------------------------------------------------------------
03. -- Sales Employees

select e.EmployeeID, e.FirstName, e.LastName, d.Name as DepartmentName from Employees as e
join Departments as d
on e.DepartmentID = d.DepartmentID
where d.Name = 'Sales'
order by EmployeeID

----------------------------------------------------------------------------------------------------------------
04. -- Employee Departments

select top 5 e.EmployeeID, e.FirstName, e.Salary, d.Name as DepartmentName from Employees as e
join Departments as d
on e.DepartmentID = d.DepartmentID
where e.Salary > 15000
order by e.DepartmentID

----------------------------------------------------------------------------------------------------------------
05. -- Employees Without Projects

select top 3 e.EmployeeID, e.FirstName from Employees as e
full join EmployeesProjects as ep
on e.EmployeeID = ep.EmployeeID
where ep.EmployeeID is null
order by e.EmployeeID

----------------------------------------------------------------------------------------------------------------
06. -- Employees Hired After

select e.FirstName, e.LastName, HireDate, d.Name as DeptName from Employees as e
join Departments as d
on e.DepartmentID = d.DepartmentID
where e.HireDate > '1999-01-01' and (d.Name = 'Sales' or d.Name = 'Finance')

----------------------------------------------------------------------------------------------------------------
07. -- Employees With Project

select top 5 e.EmployeeID, e.FirstName, p.Name as ProjectName from Employees as e
join EmployeesProjects as ep
on e.EmployeeID = ep.EmployeeID
join Projects as p
on ep.ProjectID = p.ProjectID
where p.StartDate > '2002-08-13' and p.EndDate is null
order by e.EmployeeID

----------------------------------------------------------------------------------------------------------------
08. -- Employee 24


select e.EmployeeID, e.FirstName, 
	case
		when p.StartDate > '2005-01-01'
		then NULL
		else p.Name
	end as ProjectName from Employees as e
join EmployeesProjects as ep
on e.EmployeeID = ep.EmployeeID
join Projects as p
on ep.ProjectID = p.ProjectID
where e.EmployeeID = 24

----------------------------------------------------------------------------------------------------------------
09. -- Employee Manager

select e.EmployeeID, e.FirstName, e.ManagerId, m.FirstName as ManagerName from Employees as e
join Employees as m
on e.ManagerID = m.EmployeeID
where e.ManagerID = 3 or e.ManagerID = 7
order by e.EmployeeID

----------------------------------------------------------------------------------------------------------------
10. -- Employees Summary

select top 50 
		e.EmployeeID, 
		e.FirstName + ' ' + e.LastName as EmployeeName, 
		m.FirstName + ' ' + m.LastName as ManagerName, 
		d.Name as DepartmentName 
	from Employees as e
join Employees as m
on e.ManagerID = m.EmployeeID
join Departments as d
on e.DepartmentID = d.DepartmentID
order by e.EmployeeID

----------------------------------------------------------------------------------------------------------------
11. -- Min Average Salary

select top 1 avg(Salary) as MinAverageSalary from Employees
group by DepartmentID
order by avg(Salary)

----------------------------------------------------------------------------------------------------------------
12. -- Highest Peaks in Bulgaria

SELECT c.CountryCode, m.MountainRange, 
	p.PeakName, p.Elevation
FROM MountainsCountries as c
JOIN Mountains as m
ON c.MountainId = m.Id
RIGHT JOIN Peaks p
ON p.MountainId = m.Id
WHERE c.CountryCode = 'BG'
	AND p.Elevation > 2835
ORDER BY p.Elevation DESC


----------------------------------------------------------------------------------------------------------------
13. -- Count Mountain Ranges

SELECT c.CountryCode, count(m.MountainRange) as MountainRanges
FROM MountainsCountries as c
JOIN Mountains as m
ON c.MountainId = m.Id
WHERE c.CountryCode in ('BG', 'RU', 'US')
group by C.CountryCode
	
----------------------------------------------------------------------------------------------------------------
14. -- Countries With or Without Rivers

select top 5 c.CountryName, r.RiverName from Countries as c
full join CountriesRivers as cr
on c.CountryCode = cr.CountryCode
full join Rivers as r
on cr.RiverId = r.Id
where c.ContinentCode = 'AF'
order by c.CountryName

----------------------------------------------------------------------------------------------------------------
15. -- *Continents and Currencies

select c.ContinentCode, cc.CurrencyCode, COUNT(cc.CountryCode) AS CurrencyUsage from Continents as c
join Countries as cc
on c.ContinentCode = cc.ContinentCode
group by c.ContinentCode, cc.CurrencyCode
having count(cc.CountryCode) = (select max(xxx.CurrencyXX) from (SELECT cx.ContinentCode, ccx.CurrencyCode, 
				COUNT(ccx.COUNTryCode) AS CurrencyXX
			FROM Continents cx
			JOIN Countries ccx 
			ON cx.ContinentCode = ccx.ContinentCode 
			WHERE c.ContinentCode = cx.ContinentCode 
			GROUP BY cx.ContinentCode , ccx.CurrencyCode) AS xxx)
AND COUNT(cc.CountryCode) > 1
ORDER BY c.ContinentCode

----------------------------------------------------------------------------------------------------------------
16. -- Countries Without any Mountains

SELECT count(c.CountryCode) - count(e.MountainId) as CountryCode FROM MountainsCountries as e
full join Countries as c
on e.CountryCode = c.CountryCode

----------------------------------------------------------------------------------------------------------------
17. -- Highest Peak and Longest River by Country


SELECT TOP 5 c.CountryName, 
	MAX(p.Elevation) AS HighestPeakElevation, 
	MAX(r.Length) AS LongestRiverLength
FROM Countries as c
LEFT JOIN MountainsCountries as mc
ON c.CountryCode = mc.CountryCode
LEFT JOIN Peaks as p
ON mc.MountainId = p.MountainId
LEFT JOIN CountriesRivers as cr
ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers as r
ON cr.RiverId = r.Id
GROUP BY c.CountryName
ORDER BY HighestPeakElevation DESC, 
	LongestRiverLength DESC, c.CountryName


----------------------------------------------------------------------------------------------------------------
18. -- *Highest Peak Name and Elevation by Country


SELECT TOP 5
	c.CountryName AS Country,
	ISNULL(p.PeakName, '(no highest peak)') AS HighestPeakName,
	ISNULL(MAX(p.Elevation), 0) AS HighestPeakElevation,
	ISNULL(m.MountainRange, '(no mountain)') AS Mountain
FROM Countries c
LEFT JOIN MountainsCountries mc
ON c.CountryCode = mc.CountryCode
LEFT JOIN Peaks p
ON mc.MountainId = p.MountainId
LEFT JOIN Mountains m
ON mc.MountainId = m.Id
GROUP BY c.CountryName, p.Elevation, p.PeakName, m.MountainRange
ORDER BY c.CountryName, p.PeakName

