Databases MSSQL Retake Exam - 15 December 2016 Practise 

Section 1: DDL 1. Database Design

CREATE TABLE Users
(
    Id INT PRIMARY KEY IDENTITY,
    Nickname VARCHAR(25),
    Gender CHAR(1),
    Age INT,
    LocationId INT,
    CredentialId INT UNIQUE,
)  
 
 
CREATE TABLE Credentials
(
    Id INT PRIMARY KEY identity,
    Email VARCHAR(30),
    Password VARCHAR(20)
)
 
 
CREATE TABLE Locations
(
    Id INT PRIMARY KEY identity,
    Latitude FLOAT,
    Longitude FLOAT
)
 
 
 
CREATE TABLE Chats
(
    Id INT PRIMARY KEY identity,
    Title VARCHAR (32),
    StartDate DATE,
    IsActive BIT,
)
 
 
 
 
CREATE TABLE UsersChats
(
   UserId int,
   ChatId int,
   CONSTRAINT Pk_USERSCHATS PRIMARY KEY(ChatId,UserId)
)
 
CREATE TABLE Messages
(
    Id INT PRIMARY KEY identity,
    Content VARCHAR(200),
    SentOn DATE,
    ChatId INT,
    UserId INT
)
 
 
ALTER TABLE Users
ADD CONSTRAINT Fk_Users_Credential_id FOREIGN KEY (CredentialId) REFERENCES Credentials (Id),
   CONSTRAINT Fk_Users_Locations     FOREIGN KEY (LocationId)   REFERENCES Locations(Id)
 
 
ALTER TABLE UsersChats
ADD
    CONSTRAINT FK_UsersChats_Chats FOREIGN KEY (ChatId) REFERENCES Chats (Id),
    CONSTRAINT FK_UsersChats_Users FOREIGN KEY (UserId) REFERENCES USERS (Id)
 
ALTER TABLE Messages
ADD CONSTRAINT FK_Messages_User FOREIGN KEY (UserId) REFERENCES Users(Id),
    CONSTRAINT FK_Messages_Chats FOREIGN KEY (ChatId) REFERENCES Chats(Id)


-----------------------------------------------------------------------------------------------------------------

Section 2. DML 2. Insert

insert [Messages] ([Content], [SentOn], [ChatId], [UserId])
select CONCAT(us.Age, '-', us.Gender, '-', l.Latitude, '-', l.Longitude),
CONVERT(DATE, GETDATE()),
[ChatId] = CASE
WHEN us.Gender = 'F' THEN CEILING(SQRT((us.Age * 2)))
WHEN us.Gender = 'M' THEN CEILING(POWER((us.Age / 18), 3))
END,
us.Id
FROM Users AS us
INNER JOIN Locations AS l
ON l.Id = us.LocationId
WHERE us.Id >= 10 AND us.Id <= 20

-----------------------------------------------------------------------------------------------------------------

Section 2. DML 3. Update

update c
set StartDate = SentOn
from Chats c inner join Messages m on c.Id = m.ChatId
where c.StartDate > m.SentOn

-----------------------------------------------------------------------------------------------------------------

Section 2. DML 4. Delete

delete from Locations 
where Id in (select l.Id  from Locations as l
left join Users as u on l.Id = u.LocationId 
where u.LocationId is null)


-----------------------------------------------------------------------------------------------------------------

Section 3: Querying - 5. Age Range

select Nickname, Gender, Age from Users
where Age between 22 and 37

-----------------------------------------------------------------------------------------------------------------

Section 3: Querying - 6. Messages

select Content, SentOn from Messages
where Content like '%just%' and SentOn > '2014-05-12'
order by Id desc

-----------------------------------------------------------------------------------------------------------------

Section 3: Querying - 7. Chats

select Title, IsActive from Chats
where IsActive = 0 and len(Title) < 5 or SUBSTRING(Title,3,2) = 'tl'
order by Title desc

-----------------------------------------------------------------------------------------------------------------

Section 3: Querying - 8. Chat Messages

select c.id, c.Title, m.Id from Chats as c
join Messages as m on c.Id = m.ChatId
where m.SentOn < '2012-03-26' and SUBSTRING(c.Title, len(c.Title),1) = 'x'
order by c.Id, m.Id

-----------------------------------------------------------------------------------------------------------------

Section 3: Querying - 9. Message Count

SELECT TOP 5 c.Id, COUNT(m.Content) AS MessageCount
  FROM Chats AS c
  RIGHT JOIN Messages AS m
       ON m.ChatID = c.Id
 WHERE m.Id < 90
 GROUP BY c.Id
 ORDER BY MessageCount DESC , c.Id ASC

-----------------------------------------------------------------------------------------------------------------

Section 3: Querying - 10. Credentials

select u.Nickname, c.Email, c.Password from Credentials as c
join Users as u on u.CredentialId = c.Id
where c.Email like '%co.uk'
order by c.Email

-----------------------------------------------------------------------------------------------------------------

Section 3: Querying - 11. Locations

select u.Id, u.Nickname, u.Age from Users as u
where u.LocationId is null

-----------------------------------------------------------------------------------------------------------------

Section 3: Querying - 12. Left Users

select m.Id , m.ChatId, m.UserId from Messages as m
join Chats as c on c.Id = m.ChatId
where ChatId = 17 and m.UserId NOT IN (SELECT uc.UserId
                           FROM UsersChats AS uc
                          INNER JOIN Messages AS m
                             ON uc.ChatId = m.ChatId
                          WHERE uc.UserId = m.UserId
                            AND m.ChatId = 17 )
        OR m.UserId is null
order by m.Id desc

-----------------------------------------------------------------------------------------------------------------

Section 3: Querying - 13. Users in Bulgaria

select u.Nickname, c.Title, l.Latitude, l.Longitude from Users as u
join Locations as l on u.LocationId = l.Id
join UsersChats as uc on u.Id = uc.UserId
join Chats as c on uc.ChatId = c.Id
where (l.Latitude between cast(41.14 as numeric) and cast(44.13 as numeric)) and (l.Longitude between 22.21 and 28.36)
order by c.Title

-----------------------------------------------------------------------------------------------------------------

Section 3: Querying - 14. Last Chat

select c.Title, m.Content from Messages as m
full join Chats as c on m.ChatId = c.Id
where c.Id = (select top 1 ch.Id from Chats as ch
full join Messages as m on ch.Id = m.ChatId
order by ch.StartDate desc)


-----------------------------------------------------------------------------------------------------------------

Section 4: Programmability - 15. Radians

create function udf_GetRadians (@Degrees float)
returns float
as begin
	
	declare @Radians float
	set @Radians = (@Degrees * PI())/180
	return @Radians
end

-----------------------------------------------------------------------------------------------------------------

Section 4: Programmability - 16. Change Password

create proc udp_ChangePassword (@Email varchar(30), @NewPassword varchar(30))
as
begin	
		if @Email in (select Email from Credentials)
			begin
				update Credentials
				set Password = @NewPassword
				where Email = @Email
			end
		else
			begin
				raiserror ('The email does''t exist!', 16, 1)			
			end

end


-----------------------------------------------------------------------------------------------------------------

Section 4: Programmability - 17. Send Message

create proc udp_SendMessage (@UserId int, @ChatId int, @Content varchar(max))
as begin
	if @UserId not in (select UserId from UsersChats where ChatId = @ChatId)
		begin
		 raiserror ('There is no chat with that user!',16,1)
		end
	insert into Messages (Content, SentOn, ChatId, UserId)
	values(@Content, GETDATE(),@ChatId, @UserId)
end

-----------------------------------------------------------------------------------------------------------------

Section 4: Programmability - 18. Log Messages

create trigger delMessages on Messages after delete
as
insert into MessageLogs (Id, Content, SentOn,ChatId,UserId)
select d.Id, d.Content, d.SentOn, d.ChatId, d.UserId
from deleted as d


-----------------------------------------------------------------------------------------------------------------

Section 5: Bonus - 19. Delete users

CREATE TRIGGER tr_DeleteUserRelations
ON Users
INSTEAD OF DELETE
AS

DECLARE @deletedUserId int = (SELECT Id FROM deleted)

DELETE FROM UsersChats
WHERE UserId = @deletedUserId

DELETE FROM Messages
WHERE UserId = @deletedUserId

DELETE FROM Users
WHERE Id = @deletedUserId