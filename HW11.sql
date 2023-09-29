CREATE TABLE INVOICE (
    InvoiceNo SMALLINT IDENTITY(10000,1) PRIMARY KEY,
    InvoiceDate DATE DEFAULT GETDATE(),
    BookID INT NOT NULL,
    GuestID VARCHAR(4) NOT NULL,
    StartDate DATE NOT NULL,
    CondoFee DECIMAL(7, 2) DEFAULT 0,  
    ActivityFee DECIMAL(7, 2) DEFAULT 0,
    InvoiceTotal DECIMAL(7, 2) DEFAULT 0,
);

SELECT DATEDIFF(DAY ,b.StartDate, b.EndDate) * c.DailyRate AS 'Total Condo Fee'
FROM BOOKING b, CONDO c
WHERE b.BldgNum = c.BldgNum
AND b.UnitNum = c.UnitNum
AND b.GuestID = 'G5'
AND b.StartDate = '2021-08-03';


CREATE PROCEDURE Create_Invoice (@guestid VARCHAR(4), @startdate DATE) 
AS 
BEGIN TRY 
	BEGIN TRANSACTION
		INSERT INTO INVOICE (BookID, GuestID, StartDate, CondoFee, ActivityFee) VALUES (
		(SELECT BookID FROM BOOKING WHERE StartDate = @startdate AND GuestID = @guestid),
		@guestid,
		@startdate,
		(SELECT DATEDIFF(DAY ,b.StartDate, b.EndDate) * c.DailyRate FROM BOOKING b, CONDO c 
		WHERE b.BldgNum = c.BldgNum AND b.UnitNum = c.UnitNum AND b.GuestID = @guestid AND b.StartDate = @startdate),
		(SELECT SUM(a.PPP * r.NumerInParty) FROM ACTIVITY a, RESERVATION r
		WHERE a.ActID = r.ActID AND r.GuestID = @guestid AND r.RDate >= @startdate))
	COMMIT
END TRY 
BEGIN CATCH 
	Select ERROR_NUMBER() AS ErrorNumber , ERROR_MESSAGE() AS ErrorMessage;  
	ROLLBACK 
END CATCH;