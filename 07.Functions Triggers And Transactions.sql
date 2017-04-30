Functions Triggers And Transactions Homework




01. Employees with Salary Above 35000

create proc usp_GetEmployeesSalaryAbove35000 
as select FirstName, LastName from Employees
where Salary > 35000



02. Employees with Salary Above Number

create proc usp_GetEmployeesSalaryAboveNumber (@parameter money)
as select FirstName, LastName from Employees
where Salary >= @parameter



03. Town Names Starting With

create proc usp_GetTownsStartingWith (@parameter varchar(max))
as select Name from Towns
where SUBSTRING(Name,1,len(@parameter)) = @parameter


04. Employees from Town

create proc usp_GetEmployeesFromTown (@townName varchar(max))
as select FirstName, LastName from Employees as e
join Addresses as a
on e.AddressID = a.AddressID
join Towns as t
on a.TownID = t.TownID
where t.Name = @townName



05. Salary Level Function

create function ufn_GetSalaryLevel (@salary MONEY)
returns nvarchar(10) as
begin
declare @SalaryLevel nvarchar(20)
if (@salary < 30000)
	set @SalaryLevel = 'Low'
else if (@salary between 30000 and 50000)
	 set @SalaryLevel = 'Average'
else set @SalaryLevel = 'High'

return @SalaryLevel
end



06. Employees by Salary Level

create procedure usp_EmployeesBySalaryLevel (@parameter nvarchar(10))
as 
	begin 
		select s.FirstName as 'First Name', s.LastName as 'Last Name' 
          from (SELECT FirstName, LastName, Salary, dbo.ufn_GetSalaryLevel(Salary) as SalaryLevel
  FROM Employees) as s
  where s.SalaryLevel = @parameter
  end



07. Define Function

create function ufn_IsWordComprised (@setOfLetters nvarchar(20), @word nvarchar(20))
returns bit
as
begin
	declare @comprised bit = 1
	declare @index int = 1
 	while (@comprised = 1) and (@index <= len(@word))
	begin
		if(charindex(lower(substring(@word, @index, 1)), lower(@setOfLetters)) not between 1 and len(@setOfLetters))
			begin
				set @comprised = 0	
			end
		else set @index += 1
	end
	return @comprised
end



08. Delete Employees and Departments

begin tran
alter table [dbo].[EmployeesProjects]
drop constraint [FK_EmployeesProjects_Employees]
alter table Departments
drop constraint FK_Departments_Employees
alter table Employees
drop constraint FK_Employees_Employees
delete from Employees
where DepartmentID in (7,8)
delete from Departments
where DepartmentID in (7,8)



09. Employees with Three Projects

create proc usp_AssignProject(@emloyeeId int, @projectID int)
as
 begin
	begin tran
		insert into EmployeesProjects(EmployeeID,ProjectID)
		values(@emloyeeId, @projectID)
		if (select count(EmployeeID) from EmployeesProjects where EmployeeID = @emloyeeId) > 3 
				begin
					raiserror ('The employee has too many projects!', 16, 1)
					rollback
				end
	commit

 end




10. Find Full Name

create proc usp_GetHoldersFullName 
as
begin
select FirstName + ' ' + LastName as 'Full Name' from AccountHolders
end



11. People with Balance Higher Than

create proc usp_GetHoldersWithBalanceHigherThan (@num money) as
begin
	select ah.FirstName, ah.LastName from AccountHolders as ah
	join Accounts as c on ah.Id = c.AccountHolderId
	group by ah.FirstName, ah.LastName
	having sum(c.Balance) > @num
end




12. Future Value Function

create function ufn_CalculateFutureValue (@sum money, @yearlyInterestRate float, @years int)
returns money
as
	begin

		declare @futureValue money = @sum * (power((1 + @yearlyInterestRate),@years))
		return @futureValue
	end




13. Calculating Interest

create proc usp_CalculateFutureValueForAccount (@AccountId int, @interestRate money)
as
	begin
		
		select a.Id as [Account Id], 
				ah.FirstName, 
				ah.LastName, 
				sum(a.Balance) as [Current Balance], 
				dbo.[ufn_CalculateFutureValue](sum(a.Balance), @interestRate, 5) 
			from AccountHolders as ah
		join Accounts as a
		on ah.Id = a.AccountHolderId
		where a.Id = @AccountId
		group by a.Id, ah.FirstName, ah.LastName

	end



14. Deposit Money Procedure

create proc usp_DepositMoney (@AccountId int, @moneyAmount money)
as
	begin

	begin tran
		update Accounts
		set Balance = Balance + @moneyAmount
		where Accounts.Id = @AccountId
		commit

	end





15. Withdraw Money Procedure

create proc usp_WithdrawMoney (@AccountId int, @moneyAmount money)
as
	begin
		begin tran
			update Accounts
			set Balance = Balance - @moneyAmount
			where Accounts.Id = @AccountId
			commit
	end





16. Money Transfer

create proc usp_TransferMoney (@senderId int, @recieverId int, @amount money)
as
begin
	begin tran
	
		exec [dbo].[usp_WithdrawMoney] @senderId,@amount
		exec [dbo].[usp_DepositMoney] @recieverId, @amount
		if (select Balance from Accounts where Accounts.Id = @senderId) < 0
			rollback
		else
			commit
	
end




17. Create Table Logs

create trigger tr_SumChanges on [Accounts] after update
as
begin

	insert into [Logs] (AccountId, OldSum, NewSum)
	select i.Id, d.Balance, i.Balance  from inserted as i
	inner join deleted as d
	on i.AccountHolderId = d.AccountHolderId

end




18. Create Table Emails

create trigger tr_LogToEmail on Logs after insert
as
begin
	insert into NotificationEmails
		(Recipient, Subject, Body)
	select AccountId,
		'Balance change for account: ' 
		+ convert(varchar(10), AccountId),
		'On ' + convert(varchar(30), getdate()) + ' your balance was changed from '
		+ convert(varchar(30), OldSum) + ' to ' 
		+ convert(varchar(30), NewSum) 
	  from Logs
end



19. *Cash in User Games Odd Rows

CREATE FUNCTION ufn_CashInUsersGames (@gameName NVARCHAR(50))
RETURNS @Result TABLE(
SumCash MONEY
)
AS
BEGIN
	INSERT INTO @Result
	SELECT SUM(sc.Cash) as SumCash
	FROM
		(SELECT Cash,
		ROW_NUMBER() OVER(ORDER BY Cash DESC) AS RowNumber
		FROM UsersGames ug
		RIGHT JOIN Games g
		ON ug.GameId = g.Id
		WHERE g.Name = @gameName) sc
	WHERE RowNumber % 2 != 0
	RETURN
END




21. *Massive Shopping

BEGIN TRANSACTION
DECLARE @sum1 MONEY = (SELECT SUM(i.Price)
						FROM Items i
						WHERE MinLevel BETWEEN 11 AND 12)

IF (SELECT Cash FROM UsersGames WHERE Id = 110) < @sum1
ROLLBACK
ELSE BEGIN
		UPDATE UsersGames
		SET Cash = Cash - @sum1
		WHERE Id = 110

		INSERT INTO UserGameItems (UserGameId, ItemId)
		SELECT 110, Id 
		FROM Items 
		WHERE MinLevel BETWEEN 11 AND 12
		COMMIT
	END

BEGIN TRANSACTION
DECLARE @sum2 MONEY = (SELECT SUM(i.Price)
						FROM Items i
						WHERE MinLevel BETWEEN 19 AND 21)

IF (SELECT Cash FROM UsersGames WHERE Id = 110) < @sum2
ROLLBACK
ELSE BEGIN
		UPDATE UsersGames
		SET Cash = Cash - @sum2
		WHERE Id = 110

		INSERT INTO UserGameItems (UserGameId, ItemId)
			SELECT 110, Id 
			FROM Items 
			WHERE MinLevel BETWEEN 19 AND 21
		COMMIT
	END

SELECT i.Name AS 'Item Name' 
FROM UserGameItems ugi
JOIN Items i
ON ugi.ItemId = i.Id
WHERE ugi.UserGameId = 110




22. Number of Users for Email Provider

SELECT SUBSTRING(Email, CHARINDEX('@', Email)+1, len(Email))  AS [Email Provider], 
	COUNT(Email) AS [Number Of Users]
FROM Users
GROUP BY SUBSTRING(Email, CHARINDEX('@', Email)+1, len(Email))
ORDER BY COUNT(Email) DESC, SUBSTRING(Email, CHARINDEX('@', Email)+1, len(Email)) 





23. All Users in Games

SELECT g.Name, gt.Name AS [Game Type], 
	u.Username, ug.Level, ug.Cash, c.Name
FROM Games g
JOIN GameTypes gt
ON gt.Id = g.GameTypeId
JOIN UsersGames ug
ON ug.GameId = g.Id
JOIN Users u
ON u.Id = ug.UserId
JOIN Characters c
ON ug.CharacterId = c.Id
ORDER BY ug.Level DESC, u.Username, g.Name



24. Users in Games with Their Items

SELECT u.Username, g.Name AS Game, COUNT(i.Name), SUM(i.Price)
FROM Users u
JOIN UsersGames ug
ON u.Id = ug.UserId
JOIN Games g
ON ug.GameId = g.Id
JOIN UserGameItems ugi
ON ugi.UserGameId = ug.Id
JOIN Items i
ON i.Id = ugi.ItemId
GROUP BY u.Username, g.Name
HAVING COUNT(i.Name) >= 10
ORDER BY COUNT(i.Name) DESC,
	SUM(i.Price) DESC,
	u.Username





25. * User in Games with Their Statistics

SELECT u.Username, g.Name AS Game, MAX(c.Name) AS Character,
SUM(its.Strength) + MAX(gts.Strength) + MAX(cs.Strength) AS Strength,
SUM(its.Defence) + MAX(gts.Defence) + MAX(cs.Defence) AS Defence,
SUM(its.Speed) + MAX(gts.Speed) + MAX(cs.Speed) as Speed,
SUM(its.Mind) + MAX(gts.Mind) + MAX(cs.Mind) AS Mind,
SUM(its.Luck) + MAX(gts.Luck) + MAX(cs.Luck) AS Luck
FROM Users u
JOIN UsersGames ug
ON u.Id = ug.UserId
JOIN Games g
ON ug.GameId = g.Id
JOIN GameTypes gt
ON gt.Id = g.GameTypeId
JOIN [dbo].[Statistics] gts
ON gts.Id = gt.BonusStatsId
JOIN Characters c
ON ug.CharacterId = c.Id
JOIN [dbo].[Statistics] cs
ON cs.Id = c.StatisticId
JOIN UserGameItems ugi
ON ugi.UserGameId = ug.Id
JOIN Items i
ON i.Id = ugi.ItemId
JOIN [dbo].[Statistics] its
ON its.Id = i.StatisticId
GROUP BY u.Username, g.Name
ORDER BY Strength DESC, Defence DESC, Speed DESC, Mind DESC, Luck DESC



26. All Items with Greater than Average Statistics

SELECT i.Name, i.Price, i.MinLevel, 
	s.Strength, s.Defence, s.Speed, s.Luck, s.Mind
FROM Items i
JOIN [Statistics] s
ON i.StatisticId = s.Id
WHERE s.Speed > (SELECT AVG(s.Speed)
					FROM Items i
					JOIN [Statistics] s
					ON i.StatisticId = s.Id
					)
AND s.Luck > (SELECT AVG(s.Luck)
					FROM Items i
					JOIN [Statistics] s
					ON i.StatisticId = s.Id
					)
AND s.Mind > (SELECT AVG(s.Mind)
					FROM Items i
					JOIN [Statistics] s
					ON i.StatisticId = s.Id
					)
ORDER BY i.Name





27. Display All Items about Forbidden Game Type

SELECT i.Name AS Item, i.Price, i.MinLevel,
gt.Name AS [Forbidden Game Type]
FROM Items i
LEFT JOIN GameTypeForbiddenItems gtfi
ON gtfi.ItemId = i.Id
LEFT JOIN GameTypes gt
ON gt.Id = gtfi.GameTypeId
ORDER BY [Forbidden Game Type] DESC,
i.Name





28. Buy Items for User in Game

DECLARE @sumCash MONEY = (SELECT SUM(Price)
					FROM Items
					WHERE Name IN ('Blackguard', 'Bottomless Potion of Amplification',
					'Eye of Etlich (Diablo III)', 'Gem of Efficacious Toxin', 
					'Golden Gorget of Leoric', 'Hellfire Amulet'))

BEGIN TRAN
IF (SELECT SUM(Cash) FROM UsersGames 
	WHERE UserId = (SELECT Id FROM Users
					WHERE Username = 'Alex')) < @sumCash	
ROLLBACK
ELSE
	UPDATE UsersGames
	SET Cash = Cash - @sumCash
	WHERE UserId = (SELECT Id FROM Users
					WHERE Username = 'Alex')

	INSERT INTO UserGameItems (ItemId, UserGameId)
	(SELECT i.Id, 235
	FROM Items i
	WHERE Name IN ('Blackguard', 'Bottomless Potion of Amplification',
	'Eye of Etlich (Diablo III)', 'Gem of Efficacious Toxin', 
	'Golden Gorget of Leoric', 'Hellfire Amulet'))
COMMIT

SELECT u.Username, g.Name, ug.Cash, i.Name AS [Item Name]
FROM UserGameItems ugi
JOIN Items i
ON ugi.ItemId = i.Id
JOIN UsersGames ug
ON ug.Id = ugi.UserGameId
JOIN Users u
ON ug.UserId = u.Id
JOIN  Games g
ON ug.GameId = g.Id
WHERE g.Name = 'Edinburgh'
ORDER BY i.Name






29. Peaks and Mountains

SELECT p.PeakName, m.MountainRange AS Mountain, p.Elevation
FROM Peaks p
JOIN Mountains m
ON p.MountainId = m.Id 
ORDER BY p.Elevation DESC, p.PeakName





30. Peaks with Mountain, Country and Continent

SELECT p.PeakName, m.MountainRange, c.CountryName, con.ContinentName
FROM Peaks p
JOIN Mountains m
ON p.MountainId = m.Id 
JOIN MountainsCountries mc
ON mc.MountainId = m.Id
JOIN Countries c
ON mc.CountryCode = c.CountryCode
JOIN Continents con
ON con.ContinentCode = c.ContinentCode
ORDER BY p.PeakName, c.CountryName




31. Rivers by Country

SELECT c.CountryName, con.ContinentName, 
ISNULL(COUNT(r.Id), 0) AS RiversCount,
ISNULL(SUM(r.Length), 0)  AS TotalLength
FROM Countries c
JOIN Continents con
ON con.ContinentCode = c.ContinentCode
LEFT JOIN CountriesRivers cr
ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers r
ON cr.RiverId = r.Id
GROUP BY c.CountryName, con.ContinentName
ORDER BY RiversCount DESC, TotalLength DESC, c.CountryName







32. Count of Countries by Currency

SELECT c.CurrencyCode, c.Description AS Currency, 
COUNT(ctr.CountryCode) AS NumberOfCountries
FROM Currencies c
LEFT JOIN Countries ctr
ON c.CurrencyCode = ctr.CurrencyCode
GROUP BY c.CurrencyCode, c.Description
ORDER BY NumberOfCountries DESC, c.Description



33. Population and Area by Continent

SELECT cnt.ContinentName, 
SUM(cntr.AreaInSqKm) AS CountriesArea,
SUM(CAST (cntr.Population AS BIGINT)) AS CountriesPopulation 
FROM Countries cntr
JOIN Continents cnt
ON cntr.ContinentCode = cnt.ContinentCode
GROUP BY cnt.ContinentName
ORDER BY CountriesPopulation DESC




34. Monasteries by Country

CREATE TABLE Monasteries(
Id INT IDENTITY PRIMARY KEY,
Name NVARCHAR(50),
CountryCode CHAR(2) 
FOREIGN KEY (CountryCode) REFERENCES Countries(CountryCode)
)

INSERT INTO Monasteries(Name, CountryCode) VALUES
('Rila Monastery “St. Ivan of Rila”', 'BG'), 
('Bachkovo Monastery “Virgin Mary”', 'BG'),
('Troyan Monastery “Holy Mother''s Assumption”', 'BG'),
('Kopan Monastery', 'NP'),
('Thrangu Tashi Yangtse Monastery', 'NP'),
('Shechen Tennyi Dargyeling Monastery', 'NP'),
('Benchen Monastery', 'NP'),
('Southern Shaolin Monastery', 'CN'),
('Dabei Monastery', 'CN'),
('Wa Sau Toi', 'CN'),
('Lhunshigyia Monastery', 'CN'),
('Rakya Monastery', 'CN'),
('Monasteries of Meteora', 'GR'),
('The Holy Monastery of Stavronikita', 'GR'),
('Taung Kalat Monastery', 'MM'),
('Pa-Auk Forest Monastery', 'MM'),
('Taktsang Palphug Monastery', 'BT'),
('Sümela Monastery', 'TR')


UPDATE Countries
SET IsDeleted = 1
WHERE CountryCode IN (SELECT r.CountryCode 
						FROM (SELECT c.CountryCode, COUNT(cr.RiverId) AS CountR
								FROM Countries c
								JOIN CountriesRivers cr
								ON c.CountryCode = cr.CountryCode
								GROUP BY c.CountryCode
								HAVING COUNT(cr.RiverId) > 3) r
					)

SELECT m.Name AS Monastery, c.CountryName AS Country
FROM Monasteries m
JOIN Countries c
ON m.CountryCode = c.CountryCode
WHERE c.IsDeleted != 1 OR c.IsDeleted IS NULL
ORDER BY Monastery




35. Monasteries by Continents and Countries

UPDATE Countries
SET CountryName = 'Burma'
WHERE CountryName = 'Myanmar'

INSERT INTO Monasteries(Name, CountryCode)
SELECT 'Hanga Abbey', CountryCode 
	FROM Countries
	WHERE CountryName = 'Tanzania'


INSERT INTO Monasteries(Name, CountryCode)
SELECT 'Myin-Tin-Daik', CountryCode 
	FROM Countries
	WHERE CountryName = 'Myanmar'

SELECT cnt.ContinentName, cntr.CountryName, 
COUNT(m.Id) AS MonasteriesCount
FROM Countries cntr
LEFT JOIN Continents cnt
ON cnt.ContinentCode = cntr.ContinentCode
LEFT JOIN Monasteries m
ON cntr.CountryCode = m.CountryCode
WHERE cntr.IsDeleted != 1 OR cntr.IsDeleted IS NULL
GROUP BY cnt.ContinentName, cntr.CountryName
ORDER BY MonasteriesCount DESC, cntr.CountryName
