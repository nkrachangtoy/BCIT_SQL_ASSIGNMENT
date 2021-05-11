-- Lab 2 Starts Here
USE master
GO
IF NOT EXISTS ( -- If the database doesn't exist create a new one
	SELECT name
	FROM sys.databases
	WHERE name = 'Krachangtoy_Nusorn_SSD_Ticketing' 
)
BEGIN
CREATE DATABASE Krachangtoy_Nusorn_SSD_Ticketing
END
GO

USE Krachangtoy_Nusorn_SSD_Ticketing
GO

-- Drop table before creating 
-- Must drop existing tables before creating

IF OBJECT_ID('EventSeatSale', 'u') IS NOT NULL
DROP TABLE EventSeatSale
GO
IF OBJECT_ID('EventSeat', 'u') IS NOT NULL
DROP TABLE EventSeat
GO
IF OBJECT_ID('Seat', 'u') IS NOT NULL
DROP TABLE Seat
GO
IF OBJECT_ID('Row', 'u') IS NOT NULL
DROP TABLE Row
GO
IF OBJECT_ID('Section', 'u') IS NOT NULL
DROP TABLE Section
GO
IF OBJECT_ID('Venue', 'u') IS NOT NULL
DROP TABLE Venue
GO
IF OBJECT_ID('Event', 'u') IS NOT NULL
DROP TABLE Event
GO
IF OBJECT_ID('EventType', 'u') IS NOT NULL
DROP TABLE EventType
GO
IF OBJECT_ID('Sale', 'u') IS NOT NULL
DROP TABLE Sale
GO
IF OBJECT_ID('Customer', 'u') IS NOT NULL
DROP TABLE Customer
GO

--CREATE Tables

CREATE TABLE Venue
(
	VenueId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
	Name VARCHAR(50) NOT NULL,
	City VARCHAR(50) NOT NULL,
	State VARCHAR(50) NOT NULL,
	Capacity INT NOT NULL
)

CREATE TABLE Customer(
    CustomerId UNIQUEIDENTIFIER PRIMARY KEY,
	FirstName VARCHAR(20),
    LastName VARCHAR(20)
);

CREATE TABLE Sale(
    SaleId UNIQUEIDENTIFIER PRIMARY KEY,
	CustomerId UNIQUEIDENTIFIER,
	FOREIGN KEY(CustomerId) REFERENCES Customer(CustomerId),
	PaymentType VARCHAR(10)
);

CREATE TABLE EventType (
    EventTypeId UNIQUEIDENTIFIER PRIMARY KEY,
    Name VARCHAR(20)
);

CREATE TABLE Event(
    EventId UNIQUEIDENTIFIER PRIMARY KEY,
    EventTypeId UNIQUEIDENTIFIER,
	FOREIGN KEY(EventTypeId) REFERENCES EventType(EventTypeId),
    VenueId UNIQUEIDENTIFIER,
    Name VARCHAR(20),
    StartDate DATETIME,
    EndDate DATETIME
);

CREATE TABLE Section(
    SectionId UNIQUEIDENTIFIER PRIMARY KEY,
    VenueId UNIQUEIDENTIFIER,
	FOREIGN KEY(VenueId) REFERENCES Venue(VenueId),
    Name VARCHAR(20)
);

CREATE TABLE Row(
    RowId UNIQUEIDENTIFIER PRIMARY KEY,
    SectionId UNIQUEIDENTIFIER,
	FOREIGN KEY(SectionId) REFERENCES Section(SectionId),
    RowNumber INT
);

CREATE TABLE Seat(
    SeatId UNIQUEIDENTIFIER PRIMARY KEY,
    RowId UNIQUEIDENTIFIER,
	FOREIGN KEY(RowId) REFERENCES Row(RowId),
    SeatNumber INT,
	BasePrice MONEY
);

CREATE TABLE EventSeat(
    EventSeatId UNIQUEIDENTIFIER PRIMARY KEY,
    SeatId UNIQUEIDENTIFIER,
	FOREIGN KEY(SeatId) REFERENCES Seat(SeatId),
	EventId UNIQUEIDENTIFIER,
	FOREIGN KEY(EventId) REFERENCES Event(EventId),
    EventPrice MONEY
);

CREATE TABLE EventSeatSale(
    EventSeatId UNIQUEIDENTIFIER,
	FOREIGN KEY(EventSeatId) REFERENCES EventSeat(EventSeatId),
    SaleId UNIQUEIDENTIFIER,
	FOREIGN KEY(SaleId) REFERENCES Sale(SaleId),
	SalePrice MONEY,
    SaleStatus INT
);

-- Use ALTER TABLE to add a constraint to ensure that the EventSeatSale table SaleStatus can only be one of the following [0,1,2,3]
ALTER TABLE EventSeatSale
ADD CONSTRAINT validSaleStatus
CHECK (SaleStatus IN (0,1,2,3));

--Use ALTER TABLE to add a constraint to the Sale table that only allows PaymentType of: ['MC, 'AMEX', 'VISA', 'CASH']
ALTER TABLE Sale
ADD CONSTRAINT validPaymentType
CHECK (PaymentType IN ('MC', 'AMEX', 'VISA', 'CASH'));

-- Insert seed data - venue values into the table
INSERT [dbo].[Venue] VALUES (N'f48e1c38-a61c-46f3-a59c-0749047d013b', N'Spectrum Center', N'Charlotte', N'NC', 19077)
GO
INSERT [dbo].[Venue] VALUES (N'38a62a0a-aa0a-4330-8409-107fc486102d', N'American Airlines Arena', N'Miami', N'FL', 19600)
GO
INSERT [dbo].[Venue] VALUES (N'0f26784c-b8b7-4b0a-95e2-1666073d28a0', N'Golden 1 Center', N'Sacramento', N'CA', 17583)
GO
INSERT [dbo].[Venue] VALUES (N'6668cce3-400c-4d50-a743-175fd0360ab4', N'Staples Center', N'Los Angeles', N'CA', 18997)
GO
INSERT [dbo].[Venue] VALUES (N'9600e0ab-0328-4c05-81da-1aad51fd0e55', N'Little Caesars Arena', N'Detroit', N'MI', 20332)
GO
INSERT [dbo].[Venue] VALUES (N'7689e901-5fcb-4b36-9542-1b426dde6891', N'Smoothie King Center', N'New Orleans', N'LA', 16867)
GO
INSERT [dbo].[Venue] VALUES (N'9c605db5-e2d4-4886-9958-27959507e25f', N'AT&T Center', N'San Antonio', N'TX', 18418)
GO
INSERT [dbo].[Venue] VALUES (N'2b5d0eae-c223-4de5-a2c5-2b0e8f3b20ff', N'Chesapeake Energy Arena', N'Oklahoma City', N'OK', 18203)
GO
INSERT [dbo].[Venue] VALUES (N'1a880ece-27b5-4b57-b312-303561983fe4', N'Capital One Arena', N'Washington', N'DC', 20356)
GO
INSERT [dbo].[Venue] VALUES (N'2d514357-967f-449e-9a33-3090f22dec35', N'Fiserv Forum', N'Milwaukee', N'VT', 17500)
GO
INSERT [dbo].[Venue] VALUES (N'bdd26a2f-d655-47d5-906b-34210afd6285', N'Bankers Life Fieldhouse', N'Indianapolis', N'IN', 17923)
GO
INSERT [dbo].[Venue] VALUES (N'c7b7349c-11bb-4470-9a1b-373a67b76835', N'Target Center', N'Minneapolis', N'MN', 18978)
GO
INSERT [dbo].[Venue] VALUES (N'6730f428-969a-49a6-82d6-3d9248441953', N'Chase Center', N'San Francisco', N'CA', 18064)
GO
INSERT [dbo].[Venue] VALUES (N'd651f1eb-217e-4f5a-b1c0-469224f30cad', N'Madison Square Garden', N'New York City', N'NY', 19812)
GO
INSERT [dbo].[Venue] VALUES (N'af864f35-653e-43fe-96a7-4f6fbb088be0', N'Inglewood Basketball and Entertainment Center', N'Inglewood', N'CA', 18000)
GO
INSERT [dbo].[Venue] VALUES (N'3f842161-d9ab-41b7-a07a-4fa74fe3164c', N'FedExForum', N'Memphis', N'TN', 17794)
GO
INSERT [dbo].[Venue] VALUES (N'77f8f617-6c53-43ec-a5d8-61e22ab0dcdb', N'Moda Center', N'Portland', N'OR', 19441)
GO
INSERT [dbo].[Venue] VALUES (N'3ebe9a37-517e-4179-9158-6efcd7f58366', N'State Farm Arena', N'Atlanta', N'GA', 18118)
GO
INSERT [dbo].[Venue] VALUES (N'0ff76e34-7382-4d89-81a0-7685e9321d7b', N'Toyota Center', N'Houston', N'TX', 18055)
GO
INSERT [dbo].[Venue] VALUES (N'5d403598-72ea-4043-8b7d-89790d0fb40a', N'Vivint Smart Home Arena', N'Salt Lake City', N'UT', 18306)
GO
INSERT [dbo].[Venue] VALUES (N'80404cf0-06db-4133-9f36-8ce36ee29041', N'Talking Stick Resort Arena', N'Phoenix', N'AZ', 18055)
GO
INSERT [dbo].[Venue] VALUES (N'33dc1c26-a239-4eb4-8377-910c0833530e', N'Wells Fargo Center', N'Philadelphia', N'PA', 20478)
GO
INSERT [dbo].[Venue] VALUES (N'6222a5d0-16aa-4f5f-a34c-9e5a4a642101', N'Rocket Mortgage FieldHouse', N'Cleveland', N'OH', 19432)
GO
INSERT [dbo].[Venue] VALUES (N'674503e0-eda4-49d5-a138-ac9c6be79b17', N'TD Garden', N'Boston', N'MA', 18624)
GO
INSERT [dbo].[Venue] VALUES (N'd2aab241-0f8e-4ae8-90ad-b6274a54b002', N'United Center', N'Chicago', N'IL', 20917)
GO
INSERT [dbo].[Venue] VALUES (N'55cb9c4b-5cee-49c7-ab57-bd7055ecedfe', N'American Airlines Center', N'Dallas', N'TX', 19200)
GO
INSERT [dbo].[Venue] VALUES (N'2686080f-54d4-4179-9cbb-c796ed1fde14', N'Pepsi Center', N'Denver', N'CO', 19520)
GO
INSERT [dbo].[Venue] VALUES (N'3b72fa85-d977-4093-9a0c-e6e80668726a', N'Scotiabank Arena', N'Toronto', N'ON', 19800)
GO
INSERT [dbo].[Venue] VALUES (N'4f7f3fb9-f706-4c18-8642-ef027468c670', N'Amway Center', N'Orlando', N'FL', 18846)
GO
INSERT [dbo].[Venue] VALUES (N'65d6f231-783a-452f-ac70-f4e483e0ad43', N'Barclays Center', N'Brooklyn', N'NY', 17732)
GO

-- Display all Venues
-- SELECT * FROM Venue;

-- Display all Venues in reverse alphabetical order
-- SELECT * FROM Venue
-- ORDER BY Name DESC;

-- Display the Staples Center record
-- SELECT * FROM Venue
-- WHERE name='Staples Center'

-- Delete the Staples Center record (found by Id)
-- DELETE FROM Venue
-- WHERE VenueId = (
	--SELECT VenueId
	--FROM Venue
	--WHERE Name = 'Staples Center'
--)

-- Display the total number of records
--SELECT COUNT(*) AS [Venue Count]
--FROM Venue

-- Insert a new record for the Staples Center
--INSERT INTO Venue VALUES (NEWID(), 'Staples Center', 'Los Angeles', 'California', 18997)

-- Display the total number of records
--SELECT COUNT(*) AS [Venue Count]
--FROM Venue

-- Display the Name and City of all Venues that are in California
--SELECT Name, City
--FROM Venue
--WHERE State = 'California'

-- Display the Name and Capacity of all Venues that have a capacity of 19200 or more
--SELECT Name, Capacity
--FROM Venue
--WHERE Capacity >= 19200

-- Display the Name, City, and State of all Venues that have teams in the Western Conference


-- Diplay the total Capacity of all Venues
--SELECT SUM(Capacity) AS [Total Capacity]
--FROM Venue

-- Display the result by querying the state and number of venues in each state
--SELECT State,
--COUNT (State) AS [Venues in State] 
--FROM Venue
--GROUP BY State

--INSERT Seed Data
DECLARE @VenueId UNIQUEIDENTIFIER = (SELECT VenueId FROM Venue WHERE Name = 'Staples Center');
INSERT INTO EventType VALUES (NEWID(), 'Concert');
INSERT INTO EventType VALUES (NEWID(), 'Basketball Game');
INSERT INTO EventType VALUES (NEWID(), 'Hockey Game');

DECLARE @ConcertId UNIQUEIDENTIFIER = (SELECT EventTypeId FROM EventType WHERE Name = 'Concert');

INSERT INTO Event VALUES 
(NEWID(),  @ConcertId, @VenueId, 'Beyonce', '2021-04-12 18:00:00.000','2021-04-12 22:00:00.000'),
(NEWID(),  @ConcertId, @VenueId, 'Lady Gaga', '2021-05-17 18:00:00.000','2021-05-17 22:00:00.000'),
(NEWID(),  @ConcertId, @VenueId, 'Disney on Ice', '2019-12-20 16:00:00.000','2019-12-20 19:00:00.000');

INSERT INTO Section VALUES 
(NEWID(), @VenueId, 'UPPERMEZ_10'),
(NEWID(), @VenueId, 'LOWERBOWL_01');

DECLARE @SectionId UNIQUEIDENTIFIER = (SELECT SectionId FROM Section WHERE Name = 'LOWERBOWL_01');

INSERT INTO Row VALUES 
(NEWID(), @SectionId, '01'),
(NEWID(), @SectionId, '02'),
(NEWID(), @SectionId, '03'),
(NEWID(), @SectionId, '04'),
(NEWID(), @SectionId, '05');

DECLARE @RowId UNIQUEIDENTIFIER = (SELECT RowId FROM Row WHERE RowNumber = '01');
DECLARE @RowId2 UNIQUEIDENTIFIER = (SELECT RowId FROM Row WHERE RowNumber = '02');

INSERT INTO Seat VALUES 
(NEWID(), @RowId, '01', 29.88),
(NEWID(), @RowId, '02', 29.88),
(NEWID(), @RowId, '03', 29.88),
(NEWID(), @RowId, '04', 29.88),
(NEWID(), @RowId, '05', 29.88),
(NEWID(), @RowId, '06', 29.88),
(NEWID(), @RowId, '07', 29.88),
(NEWID(), @RowId, '08', 29.88),
(NEWID(), @RowId2, '01', 26.28),
(NEWID(), @RowId2, '02', 26.28),
(NEWID(), @RowId2, '03', 26.28),
(NEWID(), @RowId2, '04', 26.28),
(NEWID(), @RowId2, '05', 26.28),
(NEWID(), @RowId2, '06', 26.28),
(NEWID(), @RowId2, '07', 26.28),
(NEWID(), @RowId2, '08', 26.28);

INSERT INTO Customer VALUES
(NEWID(),'Steve', 'Rogers'),
(NEWID(),'Carol', 'Danvers'),
(NEWID(),'Peter', 'Parker')

INSERT INTO Sale VALUES
(NEWID(), (SELECT CustomerId FROM Customer WHERE LastName = 'Rogers'), 'MC'),
(NEWID(), (SELECT CustomerId FROM Customer WHERE LastName = 'Danvers'), 'CASH');

-- 7) Add an INSERT query that puts one record into the EventSeat table for every seat in the Seat table for the 'Beyonce' concert. Make the seat "upcharge" $68.00.
SELECT * FROM Event WHERE Name = 'Beyonce'

INSERT INTO EventSeat
	SELECT  NEWID() AS EventSeatId, 
			SeatId, 
		(SELECT EventId 
			FROM Event 
			WHERE Name = 'Beyonce')
			, 
			BasePrice+68.00 
FROM Seat

SELECT
	SeatId
FROM EventSeat es
INNER JOIN Event e ON e.EventId = es.EventId
WHERE e.Name = 'Beyonce' 

-- 8) There is a sale in the db to Steve Rogers, it was for the following: 
-- Beyonce Lower Bowl 01, Row 02, Seats 01-04. 
-- Add the appopriate records to the EventSeatSale table.
SELECT es.eventSeatId, 
	(SELECT SaleId 
		FROM Sale s INNER JOIN Customer c ON c.CustomerId = s.CustomerId 
		WHERE c.FirstName = 'Steve' AND c.LastName = 'Rogers'
	),
	es.EventPrice+s.basePrice
	,
	1
FROM EventSeat es
INNER JOIN Seat s ON s.seatId = es.SeatId

-- Beyonce Lower Bowl 01, Row 02, Seats 01
INSERT INTO EventSeatSale (EventSeatId, SaleId, SalePrice, SaleStatus) Values(
	(SELECT EventSeatId
		FROM EventSeat
		WHERE SeatId =
			(SELECT SeatId
				FROM Seat
				WHERE SeatNumber = '01' 
				AND 
				RowId = 
					(
						SELECT RowId 
						FROM Row
						WHERE RowNumber = '02' 
						AND 
						SectionId = 
						(
						SELECT SectionId 
						FROM Section
						WHERE Name = 'LOWERBOWL_01'
						)
					)
		)
	),
	(SELECT SaleId
	FROM Sale
	WHERE CustomerId = (
						SELECT CustomerId
						FROM Customer
						WHERE FirstName = 'Steve' 
						AND
						LastName = 'Rogers'
						)
	),
	(SELECT EventPrice
	FROM EventSeat
	WHERE SeatId = 
			(SELECT SeatId
					FROM Seat
					WHERE SeatNumber = '01'
					AND 
					RowId = 
					(
						SELECT RowId 
						FROM Row 
						WHERE RowNumber = '02'
						AND 
						SectionId = 
						(
						SELECT SectionId 
						FROM Section 
						WHERE Name = 'LOWERBOWL_01')
					)
			)
	),
	-- SaleStatus "1"
	1
)

-- Beyonce Lower Bowl 01, Row 02, Seats 02
INSERT INTO EventSeatSale (EventSeatId, SaleId, SalePrice, SaleStatus) Values(
	(SELECT EventSeatId
		FROM EventSeat
		WHERE SeatId =
			(SELECT SeatId
				FROM Seat
				WHERE SeatNumber = '02' 
				AND 
				RowId = 
					(
						SELECT RowId 
						FROM Row
						WHERE RowNumber = '02' 
						AND 
						SectionId = 
						(
						SELECT SectionId 
						FROM Section
						WHERE Name = 'LOWERBOWL_01'
						)
					)
		)
	),
	(SELECT SaleId
	FROM Sale
	WHERE CustomerId = (
						SELECT CustomerId
						FROM Customer
						WHERE FirstName = 'Steve' 
						AND
						LastName = 'Rogers'
						)
	),
	(SELECT EventPrice
	FROM EventSeat
	WHERE SeatId = 
			(SELECT SeatId
					FROM Seat
					WHERE SeatNumber = '02'
					AND 
					RowId = 
					(
						SELECT RowId 
						FROM Row 
						WHERE RowNumber = '02'
						AND 
						SectionId = 
						(
						SELECT SectionId 
						FROM Section 
						WHERE Name = 'LOWERBOWL_01')
					)
			)
	),
	-- SaleStatus "1"
	1
)
-- Beyonce Lower Bowl 01, Row 02, Seats 03
INSERT INTO EventSeatSale (EventSeatId, SaleId, SalePrice, SaleStatus) Values(
	(SELECT EventSeatId
		FROM EventSeat
		WHERE SeatId =
			(SELECT SeatId
				FROM Seat
				WHERE SeatNumber = '03' 
				AND 
				RowId = 
					(
						SELECT RowId 
						FROM Row
						WHERE RowNumber = '02' 
						AND 
						SectionId = 
						(
						SELECT SectionId 
						FROM Section
						WHERE Name = 'LOWERBOWL_01'
						)
					)
		)
	),
	(SELECT SaleId
	FROM Sale
	WHERE CustomerId = (
						SELECT CustomerId
						FROM Customer
						WHERE FirstName = 'Steve' 
						AND
						LastName = 'Rogers'
						)
	),
	(SELECT EventPrice
	FROM EventSeat
	WHERE SeatId = 
			(SELECT SeatId
					FROM Seat
					WHERE SeatNumber = '03'
					AND 
					RowId = 
					(
						SELECT RowId 
						FROM Row 
						WHERE RowNumber = '02'
						AND 
						SectionId = 
						(
						SELECT SectionId 
						FROM Section 
						WHERE Name = 'LOWERBOWL_01')
					)
			)
	),
	-- SaleStatus "1"
	1
)
-- Beyonce Lower Bowl 01, Row 02, Seats 04
INSERT INTO EventSeatSale (EventSeatId, SaleId, SalePrice, SaleStatus) Values(
	(SELECT EventSeatId
		FROM EventSeat
		WHERE SeatId =
			(SELECT SeatId
				FROM Seat
				WHERE SeatNumber = '04' 
				AND 
				RowId = 
					(
						SELECT RowId 
						FROM Row
						WHERE RowNumber = '02' 
						AND 
						SectionId = 
						(
						SELECT SectionId 
						FROM Section
						WHERE Name = 'LOWERBOWL_01'
						)
					)
		)
	),
	(SELECT SaleId
	FROM Sale
	WHERE CustomerId = (
						SELECT CustomerId
						FROM Customer
						WHERE FirstName = 'Steve' 
						AND
						LastName = 'Rogers'
						)
	),
	(SELECT EventPrice
	FROM EventSeat
	WHERE SeatId = 
			(SELECT SeatId
					FROM Seat
					WHERE SeatNumber = '04'
					AND 
					RowId = 
					(
						SELECT RowId 
						FROM Row 
						WHERE RowNumber = '02'
						AND 
						SectionId = 
						(
						SELECT SectionId 
						FROM Section 
						WHERE Name = 'LOWERBOWL_01')
					)
			)
	),
	-- SaleStatus "1"
	1
)

-- Lab 3 starts here
-- 1. A WHILE loop that uses variables, CAST, and a conditional to insert 100 test customers to the Customer table.
-- firstName = "Test1", "Test2", "Test3"..."Test100"
-- lastName = "Aname1", "Bname2", "Cname3"..."Zname26", "Aname27", "Bname28", "Cname29"..."Zname52", "Aname53", "Bname54", "Cname55"..."Zname78", "Aname79", "Bname80", "Cname81"..."Vname100"
DECLARE @abc VARCHAR(26) = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
DECLARE @counter INT = 1;
DECLARE @abcCounter INT = 1;

WHILE @counter <= 100
BEGIN
INSERT INTO Customer VALUES (NEWID(), 'Test'+CAST(@counter AS VARCHAR(3)), SUBSTRING(@abc,@abcCounter,1)+'name'+CAST(@counter AS VARCHAR(3)));
IF @abcCounter IN (26,27,78)
	SET @abcCounter = 1;
ELSE 
	SET @abcCounter += 1;
SET @counter += 1;
END
GO
-- 2. Create the following additional test records:
-- A Venue called "Test Venue" in Vancouver BC with a capacity of 19,000
DECLARE @venueid UNIQUEIDENTIFIER = NEWID();
INSERT INTO Venue VALUES (@venueid, 'Test Venue', 'Vancouver', 'BC', 19000)

DECLARE @secid UNIQUEIDENTIFIER;
DECLARE @rowid UNIQUEIDENTIFIER;
DECLARE @sec INT = 1;
DECLARE @row INT;
DECLARE @seat INT;
-- 20 sections in Test Venue called "SEC1" - "SEC20"
WHILE @sec <= 20
BEGIN
	SET @secid = NEWID();
	SET @row = 1;
-- In SEC1-SEC15 add 50 Rows numbered 1 through 50
-- 25 Seats in each Row of Sections 1-15
	INSERT INTO Section VALUES (@secid, @venueid, 'SEC'+CAST(@sec AS VARCHAR(2)));
	IF @sec <= 15
	BEGIN
			WHILE @row <= 50
			BEGIN
				SET @rowid = NEWID();
				SET @seat = 1;
				INSERT INTO Row VALUES(@rowid, @secid, @row);
				WHILE @seat <= 25
				BEGIN
					INSERT INTO Seat VALUES(NEWID(),@rowid,@seat,20.99);
					SET @seat += 1;
				END
				SET @row += 1;
			END
		END
-- In SEC16-SEC18 add 5 Rows
-- 10 Seats in each Row of Sections 16-18
	ELSE IF @sec <= 18
		BEGIN
			WHILE @row <= 5
			BEGIN
				SET @rowid = NEWID();
				SET @seat = 1;
				INSERT INTO Row VALUES(@rowid, @secid, @row);
				WHILE @seat <= 10
				BEGIN
					INSERT INTO Seat VALUES(NEWID(),@rowid,@seat,25.99);
					SET @seat += 1;
				END
				SET @row += 1;
			END
		END
	ELSE 
-- In the last 2 Sections add 1 Row
-- 50 Seats in each Row of Sections 19&20
	BEGIN
		SET @rowid = NEWID();
		SET @seat = 1;
		INSERT INTO Row VALUES(@rowid,@secid,@row);
		WHILE @seat <= 50
		BEGIN
			INSERT INTO Seat VALUES(NEWID(),@rowid,@seat,30.99);
			SET @seat += 1;
		END
	END
	SET @sec += 1;
END
GO
-- 3. Create the following additional test records:
-- An Event called "Test Event" at the Test Venue on June 5th, 2022 from 5pm - 8pm. 
-- It is a Basketball Game.
INSERT INTO Event VALUES (NEWID(),
(SELECT EventTypeId FROM EventType WHERE NAME LIKE 'Basketball%'),
(SELECT VenueId FROM Venue WHERE Name = 'Test Venue'),
'Test Event', '2021-06-5 17:00:00:000', '2021-06-5 20:00:00:000')
-- Add all the Test Venue seats to the Test Event
DECLARE @EventId UNIQUEIDENTIFIER = (SELECT EventId FROM Event WHERE Name = 'Test Event');
INSERT INTO EventSeat
	SELECT NEWID(), SeatId, @EventId, 30.00
	FROM Seat s, Row r, Section sec, Venue v
	WHERE s.RowId = r.RowId AND r.SectionId = sec.SectionId
		AND sec.VenueId = v.VenueId AND v.Name = 'Test Venue'
GO
-- Use a CURSOR and a CASE statement to add 1 Sale for each test customer, 
-- the Payment Type will check the value of the last payment type
-- ['MC', 'AMEX', 'VISA', 'CASH'] and 'MC' will insert 'AMEX', 'AMEX' will insert 'VISA', 'VISA' will insert 'CASH', and 'CASH' will insert 'MC'
-- Select by the cursor
DECLARE @paymentType VARCHAR(4) = 'CASH'
DECLARE @custId UNIQUEIDENTIFIER

-- Define CURSOR
DECLARE @getcust CURSOR
SET @getcust = CURSOR FOR
	SELECT customerId FROM Customer WHERE FirstName LIKE 'Test%'
-- Open CURSOR for row-by-row operations
OPEN @getcust
	FETCH NEXT FROM @getcust INTO @custId
	-- FETCH_STATUS = 0 as long as more row exist
	WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @paymentType = 
				CASE
					WHEN @paymentType = 'MC' THEN 'AMEX'
					WHEN @paymentType = 'AMEX' THEN 'VISA'
					WHEN @paymentType = 'VISA' THEN 'CASH'
					ELSE 'MC'
				END
			INSERT INTO Sale VALUES (NEWID(),@custId,@paymentType)
				-- Get the next row
				FETCH NEXT
				FROM @getcust INTO @custId
			END
		-- Close CURSOR
		CLOSE @getcust
		-- Deallocate CURSOR
		DEALLOCATE @getcust
GO
-- 4. Add EventSeatSale records for the sales of the first 75 test customers
DECLARE @counter INT = 1;
DECLARE @custid UNIQUEIDENTIFIER;
DECLARE @saleid UNIQUEIDENTIFIER;

WHILE @counter <= 75
BEGIN
	SELECT @custid = CustomerId From Customer WHERE firstName = 'Test'+CAST(@counter AS VARCHAR(2));
	SELECT @saleid = SaleId FROM Sale WHERE CustomerId = @custid;
	-- If they are Test1 - Test24 give them 2 seats in SEC 1 in the Row matching their number
	-- the first seat matching their number
	-- ex: Test1 would get SEC1-Row 1-Seat 1 & 2, Test 24 would get SEC1-Row 24-Seat 24 & 25
	IF @counter <= 24
	BEGIN
		INSERT INTO EventSeatSale
		SELECT es.EventSeatId, @saleid, es.EventPrice+s.BasePrice, 1
		FROM EventSeat es,  Seat s, Row r, Section sec
		WHERE s.SeatId = es.SeatId AND r.RowId = s.RowId
			AND sec.SectionId = r.SectionId AND sec.Name = 'SEC1'
			AND r.RowNumber = @counter AND s.SeatNumber in (1,2)
END
ELSE IF @counter <=49
BEGIN
	-- Test25 - Test49 can each be given 1 Seat in SEC1 Row 25 (this should fill the row)
	INSERT INTO EventSeatSale
	SELECT es.EventSeatId, @saleid, es.EventPrice+s.BasePrice, 1
	FROM EventSeat es, Seat s, Row r, Section sec
	WHERE s.SeatId = es.SeatId 
			AND r.RowId = s.RowId
			AND sec.SectionId = r.SectionId 
			AND sec.Name = 'SEC1'
			AND r.RowNumber = 25 
			AND s.SeatNumber = @counter-24
END
ELSE
BEGIN
	-- Test50 - Test75 can each be given 1 seat in SEC19
	INSERT INTO EventSeatSale
	SELECT es.EventSeatId, @saleid, es.EventPrice+s.BasePrice, 1
	FROM EventSeat es, Seat s, Row r, Section sec
	WHERE s.SeatId = es.SeatId 
			AND r.RowId = s.RowId
			AND sec.SectionId = r.SectionId 
			AND sec.Name = 'SEC19'
			AND r.RowNumber = 1
			AND s.SeatNumber = @counter-49
END
SET @counter += 1
END

-- 5. Delete the Sales of any test customers that do not have associated EventSeatSale records.
DELETE FROM Sale
WHERE SaleId IN (
	SELECT s.SaleId FROM Sale s
	LEFT JOIN EventSeatSale ess ON ess.SaleId = s.SaleId
	INNER JOIN Customer c on c.CustomerId = s.CustomerId
	WHERE ess.SaleId IS NULL AND c.FirstName LIKE 'Test%'
);


-- SELECT STATMENTS --
-- 9) Display the Venue Name, Event Name, Date, Start Time of all up coming events.
SELECT StartDate FROM Event
SELECT	v.Name [Venue],
		e.Name [Event],
		-- CONVERT FROM "YYYY-MM-DD 00:00:00.000" to Style "107" "Mon dd, YYYY" and style "108" hh:mm:ss
		CONVERT (VARCHAR, e.StartDate, 107) [Event Date],
		CONVERT (VARCHAR, e.StartDate, 108) [Start Time]
FROM Event e
	INNER JOIN Venue v ON v.VenueId = e.VenueId
	-- CURRENT_TIMESTAMP = Current date
	WHERE e.StartDate > GETDATE();

-- 10) Display the Event Name, Section Name, Row Name, and Number of Available Seats for the 'Beyonce' concert. 
-- Each section row should be on a seperate line within a single result set.
SELECT
	e.Name [Event],
	se.Name [Section],
	r.RowNumber [Row],
	COUNT(s.SeatId) [Available Seats]
FROM
	Event e
INNER JOIN EventSeat es 
	ON es.EventId = e.EventId
LEFT JOIN EventSeatSale ess 
	ON ess.EventSeatId = es.EventSeatId
INNER JOIN Seat s
	ON s.SeatId = es.SeatId
INNER JOIN Row r
	ON r.RowId = s.RowId
INNER JOIN Section se
	ON se.SectionId = r.SectionId
WHERE ess.EventSeatId IS NULL
GROUP BY e.Name, r.RowNumber, se.Name

-- 11) Display (one per sale)
-- the Customer Name, Event Name, Section Name, Row Number, Seats (comma separated), Total Price and PaymentType.
SELECT
	c.FirstName + ' ' + c.LastName [Customer],
	e.Name [Event],
	se.Name [Section],
	r.RowNumber [Row],
	STRING_AGG(s.SeatNumber, ',') WITHIN GROUP (ORDER BY s.SeatNumber ASC) [Seats],
	FORMAT(SUM(ess.SalePrice), 'c') [Price],
	sa.PaymentType [PaymentType]
FROM Sale sa
INNER JOIN Customer c
	ON c.CustomerId = sa.CustomerId
INNER JOIN EventSeatSale ess
	ON ess.SaleId = sa.SaleId
INNER JOIN EventSeat es
	ON es.EventSeatId = ess.EventSeatId
INNER JOIN Seat s
	ON s.SeatId = es.SeatId
INNER JOIN Row r
	ON r.RowId = s.RowId
INNER JOIN Section se
	ON se.SectionId = r.SectionId
INNER JOIN Event e
	ON e.EventId = es.EventId
GROUP BY sa.SaleId, (c.FirstName + ' ' + c.LastName),e.Name,sa.PaymentType,se.Name,r.RowNumber
