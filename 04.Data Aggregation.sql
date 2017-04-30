Data Aggregation Homework

01. -- select count(Id) as Count from WizzardDeposits

02. -- select MAX(MagicWandSize) as LongestMagicWand from WizzardDeposits

03. -- select DepositGroup, MAX(MagicWandSize) as LongestMgicWand from WizzardDeposits
group by DepositGroup

04. -- select top(1) with ties Depositgroup from WizzardDeposits
group by DepositGroup
order by avg(magicwandsize) asc

05. -- select DepositGroup, sum(DepositAmount) as TotalSum from WizzardDeposits
group by DepositGroup

06. -- select DepositGroup, sum(DepositAmount) as TotalSum from WizzardDeposits
where MagicWandCreator = 'Ollivander Family'
group by DepositGroup


07. -- select DepositGroup, sum(DepositAmount) as TotalSum from WizzardDeposits
where MagicWandCreator = 'Ollivander Family'
group by DepositGroup
having sum(DepositAmount) < 150000
order by TotalSum desc

08. -- select DepositGroup, MagicWandCreator, MIN(DepositCharge) as MinDepositCharge from WizzardDeposits
group by DepositGroup, MagicWandCreator 

09. -- select WizzardDeposits.range as [AgeGroups], count(*) as [WizardCount]
from (
  select case  
    when Age between 0 and 10 then '[0-10]'
    when Age between 11 and 20 then '[11-20]'
	 when Age between 21 and 30 then '[21-30]'
    when Age between 31 and 40 then '[31-40]'
	 when Age between 41 and 50 then '[41-50]'
    when Age between 51 and 60 then '[51-60]'
    else '[61+]' end as range
  from WizzardDeposits) WizzardDeposits
group by WizzardDeposits.range

10. -- select left(FirstName,1) as FirstLetter from WizzardDeposits
where DepositGroup = 'Troll Chest'
group by left(FirstName,1)
order by FirstLetter


11. -- select DepositGroup, IsDepositExpired, avg(DepositInterest) as AverageInterest from WizzardDeposits as w
where DepositStartDate > '1985-01-01'
group by DepositGroup, IsDepositExpired
order by DepositGroup desc

12. -- SELECT SUM(SumDiff.SumDifference)
FROM
    (SELECT h.DepositAmount -
        (SELECT DepositAmount
        FROM WizzardDeposits
        WHERE Id = h.Id + 1
        ) AS SumDifference
    FROM WizzardDeposits h) AS SumDiff


13. -- select DepartmentId, sum(Salary) as TotalSalary from Employees
group by DepartmentID
order by DepartmentID

14. -- select DepartmentId, min(Salary) as MinimumSalary from Employees
where DepartmentID in (2,5,7) and HireDate > '2000-01-01'
group by DepartmentID


15. -- select * into NewTable from Employees
where salary > 30000

delete from NewTable
where ManagerID = 42

update NewTable
set Salary = Salary + 5000
where DepartmentID = 1

select DepartmentID, avg(Salary) as [AverageSalary] from NewTable
group by DepartmentID


16. -- select DepartmentID, max(Salary) as MaxSalary from Employees
group by DepartmentID
having not max(Salary) between 30000 and 70000

17. -- select count(*) as Count from Employees
where ManagerID is null

18. -- select DepartmentId, (select distinct Salary from Employees 
						where DepartmentID = e.DepartmentID
						order by Salary desc OFFSET 2 rows fetch next 1 rows only) as ThirdHighestSalary 
from Employees e
where (select distinct Salary from Employees
		where DepartmentID = e.DepartmentID
		order by Salary desc OFFSET 2 ROWS FETCH NEXT 1 ROWS only ) is not null
group by DepartmentID


19. -- select top(10) FirstName, LastName, DepartmentID from Employees as e
where e.Salary > (select avg(s.Salary) from (select Salary, DepartmentID from Employees) as s where DepartmentID = e.DepartmentID)