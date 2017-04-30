Databases MSSQL Server Exam - 16 October 2016 Practise


Section 1: DDL

create table Flights
(
	FlightID int primary key not null,
	DepartureTime datetime not null,
	ArrivalTime datetime not null,
	Status varchar(9) not null
	CONSTRAINT chk_Status CHECK (Status IN ('Departing', 'Delayed', 'Arrived', 'Cancelled')),
	OriginAirportID int foreign key references Airports(AirportID),
	DestinationAirportID int foreign key references Airports(AirportID),
	AirlineID int foreign key references Airlines(AirlineID)
)

create table Tickets
(
	TicketID int primary key not null,
	Price decimal(8,2) not null,
	Class varchar(6) not null
	constraint chk_Class CHECK (Class in ('First', 'Second', 'Third')),
	Seat varchar(5) not null,
	CustomerID int foreign key references Customers(CustomerID),
	FlightID int foreign key references Flights(FlightID)
)


-----------------------------------------------------------------------------------------------------------------

Section 2: DML - 01. Data Insertion

insert into Flights (FlightID, DepartureTime, ArrivalTime, Status, OriginAirportID, DestinationAirportID, AirlineID)
values  (1,'2016-10-13 06:00 AM','2016-10-13 10:00 AM','Delayed',1,4,1),
		(2,'2016-10-12 12:00 PM','2016-10-12 12:01 PM','Departing',1,3,2),
		(3,'2016-10-14 03:00 PM','2016-10-20 04:00 AM','Delayed',4,2,4),
		(4,'2016-10-12 01:24 PM','2016-10-12 4:31 PM','Departing',3,1,3),
		(5,'2016-10-12 08:11 AM','2016-10-12 11:22 PM','Departing',4,1,1),
		(6,'1995-06-21 12:30 PM','1995-06-22 08:30 PM','Arrived',2,3,5),
		(7,'2016-10-12 11:34 PM','2016-10-13 03:00 AM','Departing',2,4,2),
		(8,'2016-11-11 01:00 PM','2016-11-12 10:00 PM','Delayed',4,3,1),
		(9,'2015-10-01 12:00 PM','2015-12-01 01:00 AM','Arrived',1,2,1),
		(10,'2016-10-12 07:30 PM','2016-10-13 12:30 PM','Departing',2,1,7)

insert into Tickets(TicketID, Price, Class, Seat, CustomerID, FlightID)
values (1, 3000.00, 'First', '233-A', 3, 8),
		(2, 1799.90, 'Second', '123-D', 1, 1),
		(3, 1200.50, 'Second', '12-Z', 2, 5),
		(4, 410.68, 'Third', '45-Q', 2, 8),
		(5, 560.00, 'Third', '201-R', 4, 6),
		(6, 2100.00, 'Second', '13-T', 1, 9),
		(7, 5500.00, 'First', '98-O', 2, 7)


------------------------------------------------------------------------------------------------------------------

Section 2: DML - 02. Update Flights

update Flights
  set AirlineID = 1
  where Status = 'Arrived'


-----------------------------------------------------------------------------------------------------------------

Section 2: DML - 03. Update Tickets

update Tickets
set Price = Price + (Price * 0.50)
where FlightID in  
(
select f.FlightID from Flights as f
join Tickets as t on f.FlightID = t.FlightID
where AirlineID = (select top 1 AirlineID from Airlines order by Rating desc)
)


-----------------------------------------------------------------------------------------------------------------

Section 2: DML - 04. Table Creation

create table CustomerReviews
(
	ReviewID int primary key not null,
	ReviewContent varchar(255) not null,
	ReviewGrade int not null
	constraint chk_ReviewGrade CHECK (ReviewGrade between 0 and 10),
	AirlineID int foreign key references Airlines(AirlineID),
	CustomerID int foreign key references Customers(CustomerID)
)

create table CustomerBankAccounts
(
	AccountID int primary key not null,
	AccountNumber varchar(10) not null unique,
	Balance decimal(10,2) not null,
	CustomerID int foreign key references Customers(CustomerID)
)



------------------------------------------------------------------------------------------------------------------

Section 2: DML - 05. Fillin New Tables

insert into CustomerReviews(ReviewID, ReviewContent, ReviewGrade, AirlineID, CustomerID)
values (1, 'Me is very happy. Me likey this airline. Me good.', 10, 1, 1),
		(2, 'Ja, Ja, Ja... Ja, Gut, Gut, Ja Gut! Sehr Gut!', 10, 1, 4),
		(3, 'Meh...', 5, 4, 3),
		(4, 'Well Ive seen better, but Ive certainly seen a lot worse...', 7, 3, 5)

insert into CustomerBankAccounts(AccountID, AccountNumber, Balance, CustomerID)
values (1, '123456790', 2569.23, 1),
		(2, '18ABC23672', 14004568.23, 2),
		(3, 'F0RG0100N3', 19345.20, 5)


------------------------------------------------------------------------------------------------------------------

Section 3: Querying - 01. Extract All Tickets

select TicketID, Price, Class, Seat from Tickets
order by TicketID

------------------------------------------------------------------------------------------------------------------

Section 3: Querying - 02. Extract All Customers

select CustomerID,FirstName + ' ' + LastName as FullName,Gender from Customers
order by FullName,CustomerID


------------------------------------------------------------------------------------------------------------------

Section 3: Querying - 03. Extract Delayed Flights

select FlightID, DepartureTime, ArrivalTime from Flights
where Status = 'Delayed'


------------------------------------------------------------------------------------------------------------------

Section 3: Querying - 04. Top 5 Airlines

select top 5 a.AirlineID, a.AirlineName, a.Nationality, a.Rating from Airlines as a
where a.AirlineID in (select AirlineID from Flights)
order by a.Rating desc, a.AirlineID


------------------------------------------------------------------------------------------------------------------

Section 3: Querying - 05. All Tickets Below 5000

select t.TicketID, a.AirportName, c.FirstName + ' ' + c.LastName as FullName  from Tickets as t
join Flights as f on t.FlightID = f.FlightID
join Airports as a on f.DestinationAirportID = a.AirportID
join Customers as c on t.CustomerID = c.CustomerID
where t.Price < 5000 and t.Class = 'First'


------------------------------------------------------------------------------------------------------------------

Section 3: Querying - 06. Customers From Home

SELECT c.CustomerID, 
c.FirstName + ' ' + c.LastName AS FulName, 
tn.TownName AS HomeTown
FROM Customers c
JOIN Tickets t
ON t.CustomerID = c.CustomerID
JOIN Flights f
ON f.FlightID = t.FlightID
JOIN Airports a
ON a.AirportID = f.OriginAirportID
JOIN Towns tn
ON tn.TownID = a.TownID
WHERE a.TownID = c.HomeTownID
AND f.Status = 'Departing'

------------------------------------------------------------------------------------------------------------------

Section 3: Querying - 07. Customers who will fly

select DISTINCT c.CustomerID, c.FirstName + ' ' + c.LastName as FullName, datediff(year,c.DateOfBirth,'2016') as Age from Customers as c
join Tickets as tk on c.CustomerID = tk.CustomerID
join Flights as f on tk.FlightID = f.FlightID
where f.Status = 'Departing' 
order by Age,c.CustomerID

------------------------------------------------------------------------------------------------------------------

Section 3: Querying - 08. Top 3 Customers Delayed

select top 3 c.CustomerID as CustomerID, c.FirstName + ' ' + c.LastName as FullName, t.Price as TicketPrice, a.AirportName as Destination  from Customers as c
join Tickets as t on c.CustomerID = t.CustomerID
join Flights as f on t.FlightID = f.FlightID
join Airports as a on f.DestinationAirportID = a.AirportID
where f.Status = 'Delayed'
order by TicketPrice desc, CustomerID asc

------------------------------------------------------------------------------------------------------------------

Section 3: Querying - 09. Last 5 Departing Flights

select * from (select top 5 f.FlightID as FlightID, f.DepartureTime as DepartureTime, f.ArrivalTime as ArrivalTime, a.AirportName as Origin, t.AirportName as Destination from Flights as f
inner join Airports as a on f.OriginAirportID = a.AirportID
inner join Airports as t on f.DestinationAirportID = t.AirportID
where f.Status = 'Departing'
order by f.DepartureTime desc) as q
order by q.DepartureTime, q.FlightID

------------------------------------------------------------------------------------------------------------------
Section 3: Querying - 10. Customers Below 21

select distinct c.CustomerID as CustomerID, c.FirstName + ' ' + c.LastName as FullName,datediff(year,c.DateOfBirth,'2016-01-01') as Age from Customers as c
full join Tickets as t on c.CustomerID = t.CustomerID
full join Flights as f on t.FlightID = f.FlightID
where f.Status = 'Arrived' and datediff(year,c.DateOfBirth,'2016-01-01') < 21
order by Age desc,c.CustomerID asc


------------------------------------------------------------------------------------------------------------------

Section 3: Querying - 11. AIrports and Passengers

select ap.AirportID, ap.AirportName, count(t.CustomerID) as Passengers from Airports as ap
join Flights as f on ap.AirportID = f.OriginAirportID
join Tickets as t on f.FlightID = t.FlightID
where f.Status = 'Departing' 
group by ap.AirportID, ap.AirportName
having count(t.CustomerID) > 0
order by ap.AirportID

------------------------------------------------------------------------------------------------------------------

Section 4: Programmibility - 01. Submit Review

CREATE PROCEDURE usp_SubmitReview(@CustomerID INT, @ReviewContent VARCHAR(255),
	@ReviewGrade INT, @AirlineName VARCHAR(30))
AS
BEGIN
	BEGIN TRAN

	DECLARE @Index INT 
		IF((SELECT COUNT(*) FROM CustomerReviews) = 0)
			SET @Index = 1
		ELSE 
		SET @Index = (SELECT MAX(ReviewID) FROM CustomerReviews) + 1
		
		DECLARE @AirlineId INT  = (SELECT AirlineID FROM Airlines WHERE AirlineName = @AirlineName)
		
		INSERT INTO CustomerReviews
					(ReviewID, ReviewContent, ReviewGrade, 
						 CustomerID, AirlineID)
				VALUES (@Index, @ReviewContent, @ReviewGrade,
						@CustomerID, @AirlineID)

		IF NOT EXISTS(SELECT AirlineName FROM Airlines
					WHERE AirlineName = @AirlineName)
			BEGIN
				RAISERROR('Airline does not exist.', 16, 1)
				ROLLBACK
			END
		ELSE
			BEGIN 
				COMMIT
			END
END 


------------------------------------------------------------------------------------------------------------------

Section 4: Programmibility - 02. Ticket Purchase

create proc usp_PurchaseTicket (@CustomerID int, @FlightID int, @TicketPrice money, @Class varchar(10), @Seat varchar(20))
as
begin
	 DECLARE @customerBallance MONEY =
    (
        SELECT cba.Balance
          FROM Customers AS c
          LEFT JOIN CustomerBankAccounts AS cba
            ON cba.CustomerID = c.CustomerID
         WHERE c.CustomerID = @CustomerID
    )
 
    IF(@customerBallance IS NULL)
        SET @customerBallance = 0

	if (@TicketPrice > @customerBallance)
		begin
			raiserror ('Insufficient bank account balance for ticket purchase.', 16, 1)
			return
		end
	else
		begin
		declare @ticketId int
		set @ticketId = (select top 1 t.TicketID from Tickets as t order by t.TicketID desc) + 1
		insert into Tickets(TicketID, Price,Class,Seat, CustomerID, FlightID)
		values (@ticketId, @TicketPrice,@Class, @Seat, @CustomerID, @FlightID)
		update CustomerBankAccounts
		set Balance = Balance - @TicketPrice
		where CustomerID = @CustomerID

		end
end

------------------------------------------------------------------------------------------------------------------

BONUS Section 5: Update Trigger

create trigger tr_ArrivedFlights on Flights for Update
as
insert into ArrivedFlights ([FlightID],[ArrivalTime],[Origin],[Destination],[Passengers])
select
i.FlightID,
i.ArrivalTime,
org.AirportName [OriginAirport],
de.AirportName [DestinationAirport],
(select count(*) from Tickets where FlightID = i.FlightID) as [Passengers]
 from inserted as i
 inner join Airports as org
 on org.AirportID = i.OriginAirportID
 inner join Airports as de
 on de.AirportID = i.DestinationAirportID
inner join deleted as d on d.FlightID = i.FlightID
where i.Status = 'Arrived' AND d.Status != 'Arrived'