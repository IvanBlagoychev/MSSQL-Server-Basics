Data Definition and Datatypes Homework

04. -- 
INSERT INTO Towns(Id, Name) 
VALUES (1,'Sofia'), (2, 'Plovdiv'), (3, 'Varna')

INSERT INTO Minions(Id, Name, Age, TownId) 
VALUES (1, 'Kevin', 22, 1), (2, 'Bob', 15, 3), (3, 'Steward', NULL, 2)

-----------------------------------------------------------------------------------------------------------------

07. -- 
CREATE TABLE People
(
	Id INT NOT NULL IDENTITY PRIMARY KEY,
	Name nvarchar(200) NOT NULL,
	Picture varbinary,
	Height real,
	Wieght real,
	Gender varchar(1) not null,
	Birthdate date not null,
	Biography nvarchar(MAX)
)

INSERT INTO People(Name, Height, Wieght, Gender, Birthdate, Biography)
VALUES ('Ivan', 183, 73, 'm', '1992-11-17', 'Studying in SoftUni')

INSERT INTO People(Name, Height, Wieght, Gender, Birthdate, Biography)
VALUES ('Ralica', 159, 55, 'f', '1997-03-04', 'Studying in UE-Varna')

INSERT INTO People(Name, Height, Wieght, Gender, Birthdate, Biography)
VALUES ('Dimcho', 175, 62, 'm', '1989-04-25', 'Working at a car garage')

INSERT INTO People(Name, Height, Wieght, Gender, Birthdate, Biography)
VALUES ('Antoaneta', 159, 55, 'f', '1997-01-03', 'Studying in Morskoto Varna')

INSERT INTO People(Name, Height, Wieght, Gender, Birthdate, Biography)
VALUES ('Dobata', 178, 68, 'm', '1991-11-25', 'Studying in TU Varna')

-----------------------------------------------------------------------------------------------------------------

08. -- 

CREATE TABLE Users
(
	Id INT IDENTITY NOT NULL PRIMARY KEY,
	Username VARCHAR(30),
	Password VARCHAR(26),
	ProfilePicture VARBINARY(MAX),
	LastLoginTime DATE,
	IsDeleted BIT
)

INSERT INTO Users (Username, Password,LastLoginTime)
VALUES ('Gosho', 'gosho', '2012-03-03')

INSERT INTO Users (Username, Password,LastLoginTime, IsDeleted)
VALUES ('dae', 'dae', '2012-03-03', 1)

INSERT INTO Users (Username, Password,LastLoginTime, IsDeleted)
VALUES ('ddz', 'neshto', '2012-09-16', 0)

INSERT INTO Users (Username, Password,LastLoginTime, IsDeleted)
VALUES ('pesho', 'peshoto', '2012-09-16', 0)

INSERT INTO Users (Username, Password,LastLoginTime, IsDeleted)
VALUES ('esho', 'mda', '2012-09-16', 1)

---------------------------------------------------------------------------------------------------------------

13. -- 
CREATE TABLE Directors
(
	Id int not null primary key,
	DirectorName varchar(50) not null,
	Notes varchar(MAX)
)

CREATE TABLE Genres
(
	Id int not null primary key,
	GenreName varchar(50) not null,
	Notes varchar(MAX)
)

CREATE TABLE Categories
(
	Id int not null primary key,
	CategoryName varchar(50) not null,
	Notes varchar(MAX)
)

CREATE TABLE Movies
(
	Id int not null primary key,
	Title varchar(50) not null,
	DirectorId int not null,
	CopyrightYear date,
	Lenght int not null,
	GenreId int not null,
	CategoryId int not null,
	Rating float,
	Notes varchar(MAX)
)

INSERT INTO Directors(Id, DirectorName)
VALUES (1, 'Steven Spielberg'),
(2, 'Martin Scorsese'),
(3, 'Alfred Hitchcock'),
(4, 'Stanley Kubrick'),
(5, 'Quentin Tarantino')

INSERT INTO Genres(Id, GenreName, Notes)
VALUES (1, 'Action', 'Something'),
(2, 'Fantasy', 'Something else'),
(3, 'Sci-Fi', 'Primerno'),
(4, 'Western', 'Ne go znam'),
(5, 'Romance', 'Velikolepnata sedmorka')

INSERT INTO Categories(Id, CategoryName, Notes)
VALUES (1, 'A', 'Something'),
(2, 'S', 'Something else'),
(3, 'G', 'Primerno'),
(4, 'T', 'Ne go znam'),
(5, 'F', 'Velikolepnata sedmorka')

INSERT INTO Movies(Id, Title, DirectorId, Lenght, GenreId, CategoryId)
VALUES (1, 'Star Wars', 1, 120, 3, 2),
(2, 'Velikolepnata Sedmorka', 5, 120, 4, 4),
(3, 'Fifty Shades Of Gray', 3, 90, 5, 5),
(4, 'The wolf of wall street', 2, 90, 5, 4),
(5, 'The Guardians Of The Galaxy', 4, 130, 3, 3)

-----------------------------------------------------------------------------------------------------------------

14. -- Car Rental Database

CREATE TABLE Categories
(
	Id int not null primary key,
	Category varchar(50) not null,
	DailyRate decimal(18, 2),
	Weeklyate decimal(18, 2),
	MonthlyRate decimal(18, 2),
	WeekendRate decimal(18, 2)
)

CREATE TABLE Cars
(
	Id int not null primary key,
	PlateNumber int not null,
	Make varchar(20) not null,
	Model varchar(20) not null,
	CarYear int not null,
	CategoryId int not null,
	Doors varchar (10) NOT NULL,
	Picture varbinary(MAX),
	Condition varchar (10) not null,
	Available bit
)

CREATE TABLE Employees
(
	Id int not null primary key,
	FirstName varchar(50) not null,
	LastName varchar(50) not null,
	Title varchar (250) not null,
	Notes varchar(MAX)
)

CREATE TABLE Customers
(
	Id int not null primary key,
	DriverLicenceNumber bigint not null,
	FullName varchar(250) not null,
	Adress varchar(MAX) not null,
	City varchar(50) not null,
	ZipCode int not null,	
	Notes varchar(MAX)
)

CREATE TABLE RentalOrders
(
	Id int not null primary key,
	EmployeeId int not null,
	CustomerId int not null,
	CarId int not null,
	CarCondition varchar(50) not null,
	TankLevel varchar(50) not null,	
	KilometrageStart int not null,
	KilometrageEnd int not null,
	TotalKilometrage int,
	StartDate date not null,
	EndDate date not null,
	TotalDays int not null,
	RateApplied decimal,
	TaxRate decimal,
	OrderStatus varchar(50) not null,
	Notes varchar(MAX)
)


INSERT INTO Categories(Id, Category, DailyRate, Weeklyate, MonthlyRate, WeekendRate)
VALUES (1, 'Comby', 22.20, 66.60, 120.20, 20.20),
(2, 'Sedan', 22.20, 66.60, 120.20, 20.20),
(3, 'HatchBack', 22.20, 66.60, 120.20, 20.20)


INSERT INTO Cars(Id, PlateNumber, Make, Model, CarYear, CategoryId, Doors, Condition, Available)
VALUES (1, '1234', 'BMW', 325, 1993, 1, 5, 'good', 1),
(2, '5678', 'Mercedes', 220, 1998, 2, 4, 'good', 0),
(3, '9876', 'Audi', 100, 1995, 2, 4, 'old', 1)

INSERT INTO Employees(Id, FirstName, LastName, Title)
VALUES (1, 'Alex', 'Goshov', 'Manager'),
(2, 'Pesho', 'Balkanski', 'Merindjei'),
(3, 'Sasho', 'Cankov', 'Gazadjiq')

INSERT INTO Customers(Id, DriverLicenceNumber, FullName, Adress, City, ZipCode)
VALUES (1, 123456789, 'Vihar Balkanski', 'Hr.Botev', 'Varna', 9000),
(2, 123456789, 'Kolio Mamata', 'Izgrev', 'Burgas', 9009),
(3, 123456789, 'Gosho Pogachata', 'Filibeto', 'Plovdiv', 90909)

INSERT INTO RentalOrders(Id, EmployeeId, CustomerId, CarId, CarCondition, TankLevel, KilometrageStart, KilometrageEnd, TotalKilometrage, StartDate, 
EndDate, TotalDays, OrderStatus)
VALUES (1, 1, 1, 1, 'good', 'full', 123, 193, 70, '2017-03-03', '2017-03-11', 8, 'ended'),
(2, 2, 2, 2, 'good', 'medium', 123, 223, 100, '2017-03-05', '2017-03-11', 6, 'ended'),
(3, 3, 3, 3, 'bad', 'low', 500, 700, 200, '2016-11-03', '2017-12-01', 28, 'ended')

-----------------------------------------------------------------------------------------------------------------

15. -- Hotel Database

CREATE TABLE Employees
(
	Id int not null primary key,
	FirstName varchar(50) not null,
	LastName varchar(50) not null,
	Title varchar (250) not null,
	Notes varchar(MAX)
)

CREATE TABLE Customers
(
	AccountNumber bigint not null primary key,
	FirtsName varchar(50) not null,
	LastName varchar(50) not null,
	PhoneNumber bigint not null,
	EmergencyName varchar(250) not null,
	EmergencyNumber bigint not null,	
	Notes varchar(MAX)
)

CREATE TABLE RoomStatus
(
	RoomStatus varchar(50) not null primary key,
	Notes varchar(MAX)
)

CREATE TABLE RoomTypes
(
	RoomType varchar(50) not null primary key,
	Notes varchar(MAX)
)

CREATE TABLE BedTypes
(
	BedType varchar(50) not null primary key,
	Notes varchar(MAX)
)

CREATE TABLE Rooms
(
	RoomNumber int not null primary key,
	RoomType varchar(50) not null,
	BedType varchar(50) not null,
	Rate decimal not null,
	RoomStatus varchar(50) not null,
	Notes varchar(MAX)
)

CREATE TABLE Payments 
(
	Id int not null primary key,
	EmployeeId int not null,
	PaymentDate date not null,
	AccountNumber bigint not null,	
	FirstDateOccupied date not null,
	LastDateOccupied date not null,
	TotalDays int not null,
	AmountCharged decimal,
	TaxRate decimal,
	TaxAmount decimal not null,
	PaymentTotal decimal not null,
	Notes varchar(MAX)
)

CREATE TABLE Occupancies  
(
	Id int not null primary key,
	EmployeeId int not null,
	DateOccupied date not null,
	AccountNumber bigint not null,	
	RoomNumber int not null,
	RateApplied decimal,
	PhoneCharge money,
	Notes varchar(MAX)
)

INSERT INTO Employees(Id, FirstName, LastName, Title)
VALUES (1, 'Pesho', 'Peshov', 'Palqk 1'),
(2, 'Gosho', 'Goshov', 'Palqk 2'),
(3, 'Misho', 'Mishov', 'Palqk 3')


INSERT INTO Customers(AccountNumber, FirtsName, LastName, PhoneNumber, EmergencyName, EmergencyNumber)
VALUES (100, 'Sasho', 'Petrov', 111111111, 'smotanqk toshkov', 111111112),
(200, 'Todor', 'Peichev', 222222222, 'Toshko teneketo', 111111113),
(300, 'Dimcho', 'Peichev', 333333333, 'Dimcho prcizniq', 111111114)


INSERT INTO RoomStatus(RoomStatus)
VALUES ('Free'),
('Not free'),
('Cleaned')

INSERT INTO RoomTypes(RoomType)
VALUES ('SINGLE'),('DOUBLE'),('APARTAMENT')

INSERT INTO BedTypes(BedType)
VALUES ('One-Person'),('Two-Person'),('Tree-Person')

INSERT INTO Rooms(RoomNumber, RoomType, BedType, Rate, RoomStatus)
VALUES (1, 'SINGLE', 'One-Person', 50, 'Free'),
(2, 'DOUBLE', 'Two-Person', 85, 'Cleaned'),
(3, 'APARTAMENT', 'Tree-Person', 150, 'Not free')

INSERT INTO Payments(Id, EmployeeId, PaymentDate, AccountNumber, FirstDateOccupied, LastDateOccupied, TotalDays, TaxAmount, PaymentTotal)
VALUES (1, 1, '2017-01-10', 100, '2017-01-09', '2017-01-10', 2, 20, 120),
(2, 2, '2017-01-05', 200, '2017-01-02', '2017-01-05', 4, 0, 340),
(3, 3, '2017-01-05', 300, '2017-01-02', '2017-01-05', 4, 0, 600)

INSERT INTO Occupancies(Id, EmployeeId, DateOccupied, AccountNumber, RoomNumber)
VALUES (1, 1, '2017-01-10', 100, 1),
(2, 2, '2017-01-05',200, 2),
(3, 3, '2017-01-05',300, 3)

-----------------------------------------------------------------------------------------------------------------

19. -- Basic Select All Fields

SELECT * FROM Towns
SELECT * FROM Departments
SELECT * FROM Employees

------------------------------------------------------------------------------------------------------------------

20. -- Basic Select All Fields and Order Them

SELECT * FROM Towns
  ORDER BY Name ASC
SELECT * FROM Departments 
  ORDER BY Name ASC
SELECT * FROM Employees 
  ORDER BY Salary DESC

------------------------------------------------------------------------------------------------------------------

21. -- Basic Select Some Fields

SELECT Name FROM Towns
ORDER BY Name ASC
SELECT Name FROM Departments
ORDER BY Name ASC
SELECT FirstName, LastName, JobTitle, Salary FROM Employees
ORDER BY Salary DESC

-------------------------------------------------------------------------------------------------------------------

22. -- Increase Employees Salary

UPDATE Employees
SET Salary = Salary * 1.10
SELECT Salary FROM Employees

-------------------------------------------------------------------------------------------------------------------

23. -- Decrease Tax Rate

UPDATE Payments
  SET TaxRate = TaxRate / 1.03

SELECT TaxRate FROM Payments

-------------------------------------------------------------------------------------------------------------------

24. -- Delete All Records

TRUNCATE TABLE Occupancies 


