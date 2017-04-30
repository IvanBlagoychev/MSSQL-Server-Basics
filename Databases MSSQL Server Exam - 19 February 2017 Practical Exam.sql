Databases MSSQL Server Exam - 19 February 2017 Practical Exam


01. DDL

create table Countries
(
	Id int primary key identity,
	Name nvarchar(50) unique
)

create table Customers
(
	Id int primary key identity,
	FirstName nvarchar(25),
	LastName nvarchar(25),
	Gender char(1) check (len(Gender) = 1 and (Gender = 'M' or Gender = 'F')),
	Age int,
	PhoneNumber char(10) check(len(PhoneNumber) = 10),
	CountryId int foreign key references Countries(Id)
)

create table Distributors
(
	Id int primary key identity,
	Name nvarchar(25) unique,
	AddressText nvarchar(30),
	Summary nvarchar(200),
	CountryId int foreign key references Countries(Id)
)

create table Products 
(
	Id int primary key identity,
	Name nvarchar(25) unique,
	Description nvarchar(250),
	Recipe nvarchar(max),
	Price money check (Price >= 0)
)

create table Feedbacks
(
	Id int primary key identity,
	Description nvarchar(255),
	Rate decimal(18,2) check (Rate between cast(0 as decimal(18,2))  and cast(10 as decimal(18,2))),
	ProductId int foreign key references Products(Id),
	CustomerId int foreign key references Customers(Id)
)



create table Ingredients
(
	Id int primary key identity,
	Name nvarchar(30),
	Description nvarchar(200),
	OriginCountryId int foreign key references Countries(Id),
	DistributorId int foreign key references Distributors(Id)
)
create table ProductsIngredients
(
	ProductId int foreign key references Products(Id),
	IngredientId int foreign key references Ingredients(Id) ,
	constraint PK_ProdIngr primary key (ProductId, IngredientId)	
)


------------------------------------------------------------------------------------------------------------------

02. Insert

insert into Distributors (Name, CountryId, AddressText, Summary)
values ('Deloitte & Touche', 2, '6 Arch St #9757', 'Customizable neutral traveling'),
	('Congress Title', 13, '58 Hancock St', 'Customer loyalty'),
	('Kitchen People', 1, '3 E 31st St #77', 'Triple-buffered stable delivery'),
	('General Color Co Inc', 21, '6185 Bohn St #72', 'Focus group'),
	('Beck Corporation', 23, '21 E 64th Ave', 'Quality-focused 4th generation hardware')

insert into Customers (FirstName, LastName, Age, Gender, PhoneNumber, CountryId)
values ('Francoise',	'Rautenstrauch', 15, 'M', '0195698399',	5),
		('Kendra', 'Loud', 22, 'F', '0063631526', 11),
		('Lourdes',	'Bauswell',	50,	'M', '0139037043', 8),
		('Hannah', 'Edmison', 18, 'F', '0043343686', 1),
		('Tom',	'Loeza', 31, 'M', '0144876096',	23),
		('Queenie', 'Kramarczyk', 30, 'F', '0064215793', 29),
		('Hiu', 'Portaro', 25, 'M', '0068277755', 16),
		('Josefa', 'Opitz', 43, 'F', '0197887645', 17)
			

------------------------------------------------------------------------------------------------------------------


03. Update

update Ingredients 
set DistributorId = 35
where Name in ('Bay Leaf', 'Paprika','Poppy')
update Ingredients
set OriginCountryId = 14 
where OriginCountryId  = 8 

------------------------------------------------------------------------------------------------------------------


04. Delete

delete from Feedbacks 
where CustomerId = 14 or ProductId = 5

------------------------------------------------------------------------------------------------------------------


05. Products By Price

select Name, Price, Description from Products
order by Price desc, Name 

------------------------------------------------------------------------------------------------------------------


06. Ingredients

select Name, Description, OriginCountryId from Ingredients
where OriginCountryId in (1, 10,20)
order by Id

------------------------------------------------------------------------------------------------------------------


07. Ingredients from Bulgaria and Greece

select top 15 i.Name, i.Description, c.Name from Ingredients as i 
join Countries as c on i.OriginCountryId = c.Id
where c.Name = 'Bulgaria' or c.Name = 'Greece'
order by i.Name, c.Name 

------------------------------------------------------------------------------------------------------------------

08. Best Rated Products

select top 10 p.Name, p.Description, avg(f.Rate) as AverageRate, count(f.ProductId) as FeedbacksAmount  from Products as p
join Feedbacks as f on p.Id = f.ProductId
group by p.Name, p.Description
order by avg(f.Rate) desc, count(f.ProductId) desc

------------------------------------------------------------------------------------------------------------------


09. Negative Feedback

select f.ProductId, f.Rate, f.Description, f.CustomerId, c.Age, c.Gender from Feedbacks as f
join Customers as c on f.CustomerId = c.Id
where f.Rate < 5.0
order by f.ProductId desc, f.Rate

------------------------------------------------------------------------------------------------------------------


10.	Customers without Feedback

select concat(FirstName,' ',LastName) as CustomerName, PhoneNumber, Gender  from Customers
where Id not in (select CustomerId from Feedbacks)

------------------------------------------------------------------------------------------------------------------


11. Honorable Mentions

select f.ProductId as ProductId, concat(c.FirstName,' ', c.LastName) as CustomerName, f.Description as FeedbackDescription from Customers as c
full join Feedbacks as f on c.Id=f.CustomerId

where c.FirstName in (select c.FirstName from Customers as c
		full join Feedbacks as f on c.Id=f.CustomerId
		
		group by c.FirstName
		having count(f.Id) >= 3)
order by f.ProductId, CustomerName, f.Id

------------------------------------------------------------------------------------------------------------------


12. Customers by Criteria

select c.FirstName, c.Age, c.PhoneNumber from Customers as c
join Countries as cs on cs.Id = c.CountryId
where (c.Age > 20 and c.FirstName like '%an%') or (PhoneNumber like '%38' and cs.Name != 'Greece')
order by c.FirstName, c.Age desc

------------------------------------------------------------------------------------------------------------------


13. Middle Range Distributors

select d.Name as DistributorName, i.Name as IngredientName, p.Name as ProductName, avg(f.Rate) as AverageRate from Distributors as d
join Ingredients as i on d.Id = i.DistributorId
join ProductsIngredients as pin on i.Id = pin.IngredientId
join Products as p on pin.ProductId = p.Id
join Feedbacks as f on pin.ProductId = f.ProductId
group by d.Name, i.Name, p.Name
having avg(f.Rate) between 5 and 8
order by d.Name, i.Name, p.Name

------------------------------------------------------------------------------------------------------------------


14. The Most Positive Country

select top 1 with ties c.Name as CountryName, avg(f.Rate) as FeedbackRate from Countries as c
join Customers as cs on c.Id=cs.CountryId
join Feedbacks as f on f.CustomerId = cs.Id
group by c.Name
order by avg(f.Rate) desc

------------------------------------------------------------------------------------------------------------------


15. Country Representative

------------------------------------------------------------------------------------------------------------------


16. Customers With Countries

create view v_UserWithCountries as
select concat(c.FirstName,' ',c.LastName) as CustomerName, c.Age, c.Gender,cs.Name as CountryName from Customers as c
join Countries as cs on c.CountryId = cs.Id

------------------------------------------------------------------------------------------------------------------


17. Feedback by Product Name

create function udf_GetRating (@productName varchar(30))
returns varchar(30)
as
begin
	declare @Result varchar(30)
	if @productName in (select Name from Products)
		begin
			if (select avg(f.Rate) from Products as p full join Feedbacks as f on p.Id = f.ProductId where p.Name = @productName group by p.Name) < 5
				begin
					set @Result = 'Bad'
				end
			else if (select avg(f.Rate) from Products as p full join Feedbacks as f on p.Id = f.ProductId where p.Name = @productName group by p.Name) between 5 and 8
				begin
					set @Result = 'Average'
				end
			else if (select avg(f.Rate) from Products as p full join Feedbacks as f on p.Id = f.ProductId where p.Name = @productName group by p.Name) > 8
				begin
					set @Result = 'Good'
				end
			else if (select avg(f.Rate) from Products as p full join Feedbacks as f on p.Id = f.ProductId where p.Name = @productName group by p.Name) is null
				begin
					set @Result = 'No rating'
				end
		end
	return @Result
end

------------------------------------------------------------------------------------------------------------------


18. Send Feedback

create proc usp_SendFeedback (@CustomerId int, @ProductId int, @Rate decimal, @Description varchar(max))
as
	begin

		begin tran
		if (select count(Id) from Feedbacks where CustomerId = @CustomerId group by CustomerId ) >= 3
			begin
				raiserror ('You are limited to only 3 feedbacks per product!',16,1)
				rollback
			end
		else
			begin
				insert into Feedbacks (Description, Rate, ProductId, CustomerId)
				values (@Description, @Rate, @ProductId, @CustomerId)
				commit
			end
	end

------------------------------------------------------------------------------------------------------------------


19. Delete Products

create trigger TR_DelTrig on Products instead of  delete
as 
begin
	delete from Feedbacks where ProductId in (select d.Id from deleted as d)
	delete from ProductsIngredients where ProductId in (select d.Id from deleted as d)
	delete Products where Id in (select d.Id from deleted as d)
end

------------------------------------------------------------------------------------------------------------------


20. Products by One Distributor