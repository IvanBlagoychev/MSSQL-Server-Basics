Table Relations Homework

01. -- One-To-One Relationship

create table Persons
(
	PersonID int not null identity,
	FirstName varchar(50) not null,
	Salary decimal(18,2) not null,
	PassportID int not null
)

insert into Persons (FirstName, Salary, PassportID)
values ('Roberto', 43300.00,102), ('Tom', 56100.00, 103), ('Yana', 60200.00, 101)

alter table Persons
add primary key(PersonID)

create table Passports
(
	PassportID int not null,
	PassportNumber varchar(50) not null	
)

insert into Passports (PassportID, PassportNumber)
values (101, 'N34FG21B'), (102, 'K65LO4R7'), (103, 'ZE657QP2')

alter table Passports
add primary key(PassportID)


alter table Persons
add foreign key(PassportID)
references Passports(PassportID)


-----------------------------------------------------------------------------------------------------------------

02. -- One-To-Many Relationship

create table Models
(
	ModelID int not null,
	Name varchar(50) not null,
	ManufacturerID int not null
)

alter table Models
add primary key (ModelID)

insert into Models(ModelID, Name, ManufacturerID)
values (101, 'X1', 1), (102, 'i6', 1), (103, 'Model S', 2), (104, 'Model X', 2), (105, 'Model 3', 2), (106, 'Nova', 3)

create table Manufacturers
(
	ManufacturerID int not null,
	Name varchar(50) not null,
	EstablishedOn date not null
)

alter table Manufacturers
add primary key (ManufacturerID)

insert into Manufacturers (ManufacturerID, Name, EstablishedOn)
values (1, 'BMW', '07/03/1916'), (2, 'Tesla', '01/01/2003'), (3, 'Lada', '01/05/1966')

alter table Models
add foreign key (ManufacturerID)
references Manufacturers(ManufacturerID)

----------------------------------------------------------------------------------------------------------------
03. --  Many-To-Many Relationship

create table Students
(
	StudentID int not null identity,
	Name varchar(50) not null
)

alter table Students
add primary key (StudentID)

insert into Students(Name)
values ('Mila'), ('Toni'), ('Ron') 

create table Exams
(
	ExamID int not null,
	Name varchar(50) not null
)

alter table Exams
add primary key (ExamID)

insert into Exams(ExamID, Name)
values (101, 'SpringMVC'), (102, 'Neo4j'), (103, 'Oracle 11g') 

create table StudentsExams
(
	StudentID int not null,
	ExamID int not null
)

alter table StudentsExams
add primary key (StudentID, ExamID)

insert into StudentsExams (StudentID, ExamID)
values (1, 101), (1, 102), (2, 101), (3, 103), (2, 102), (2,103) 

alter table StudentsExams
add foreign key (StudentID)
references Students (StudentID)

alter table StudentsExams
add foreign key (ExamID)
references Exams (ExamID)

---------------------------------------------------------------------------------------------------------------
04. -- 04. Self-Referencing

create table Teachers
(
	TeacherID int not null,
	Name varchar(50) not null,
	ManagerID int
)

insert into Teachers (TeacherID, Name, ManagerID)
values (101, 'John', null), (102, 'Maya', 106), (103, 'Silvia', 106), (104, 'Ted', 105), (105, 'Mark', 105), (106, 'Greta', 101)

alter table Teachers
add primary key (TeacherID)

alter table Teachers
add foreign key (ManagerID)
references Teachers(TeacherID)

------------------------------------------------------------------------------------------------------------------
05. -- 05. Online Store Database

create table Orders
(
	OrderID int not null primary key,
	CustomerID int not null
)

create table Customers
(
	CustomerID int not null primary key,
	Name varchar(50) not null,
	Birthday date not null,
	CityID int not null
)

alter table Orders
add foreign key (CustomerID)
references Customers(CustomerID)

create table Cities
(
	CityID int not null primary key,
	Name varchar(50) not null
)

alter table Customers
add foreign key (CityID)
references Cities(CityID)

create table OrderItems
(
	OrderID int not null foreign key references Orders(OrderID),	
	ItemID int not null 
)

alter table OrderItems
add primary key (OrderID, ItemID)

create table Items
(
	ItemID int not null primary key,
	Name varchar(50) not null,
	ItemTypeID int not null
)

alter table OrderItems
add foreign key (ItemID)
references Items(ItemID)

create table ItemTypes
(
	ItemTypeID int not null primary key,
	Name varchar(50) not null
)

alter table Items
add foreign key (ItemTypeID)
references ItemTypes(ItemTypeID)

------------------------------------------------------------------------------------------------------------------
06. -- University Database

create table Majors
(
	MajorID int not null primary key,
	Name varchar(50)
)

create table Students
(
	StudentID int not null primary key,
	StudentNumber int not null,
	StudentName varchar(50) not null,
	MajorID int not null foreign key references Majors(MajorID)
)

create table Payments
(
	PaymentID int not null primary key,
	PaymentDate date not null,
	PaymentAmount decimal(18,2) not null,
	StudentID int not null foreign key references Students(StudentID)
)

create table Subjects
(
	SubjectID int not null primary key,	
	SubjectName varchar(50) not null
)

create table Agenda
(
	StudentID int not null foreign key references Students(StudentID),
	SubjectID int not null foreign key references Subjects(SubjectID)
)

alter table Agenda
add primary key (StudentID, SubjectID)

-----------------------------------------------------------------------------------------------------------------

09. -- Peaks in Rila

select Mountains.MountainRange as MountainRange, PeakName, Elevation as PeakElevation from Peaks
inner join Mountains
on Mountains.Id = Peaks.MountainId
where MountainId = 17
order by PeakElevation desc