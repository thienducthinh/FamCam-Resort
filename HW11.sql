/* HW10.sql */

SET STATISTICS TIME ON

SELECT g.guesid AS 'Guest ID', g.fname + ' ' g.lanme AS 'Guest Name', r.resid AS 'Reservation ID', r.rdate AS 'Reservation Date', a.description AS 'Activity Description'
FROM GUEST g, RESERVATION2 r, ACTIVITY a
WHERE g.guestid = r.guestid
AND r.actid = a.actid
AND g.guestid = 'G2'
AND r.rdate = '2020-05-30'

SELECT STATISTICS TIME OFF;

CREATE INDEX GuestID_GuideID_IDX ON RESERVATION2 (GuestID, GuideID);

SET STATISTICS TIME ON

SELECT g.guesid AS 'Guest ID', g.fname + ' ' g.lanme AS 'Guest Name', r.resid AS 'Reservation ID', r.rdate AS 'Reservation Date', a.description AS 'Activity Description'
FROM GUEST g, RESERVATION2 r, ACTIVITY a
WHERE g.guestid = r.guestid
AND r.actid = a.actid
AND g.guestid = 'G2'
AND r.rdate = '2020-05-30'

SELECT STATISTICS TIME OFF;

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

SELECT * FROM INVOICE;

SELECT DATEDIFF(DAY ,b.StartDate, b.EndDate) * c.DailyRate AS 'Total Condo Fee'
FROM BOOKING b, CONDO c
WHERE b.BldgNum = c.BldgNum
AND b.UnitNum = c.UnitNum
AND b.GuestID = 'G5'
AND b.StartDate = '2021-08-03';

SELECT SUM(a.PPP * r.NumerInParty) AS 'Total Activity Fee'
FROM ACTIVITY a, RESERVATION r
WHERE a.ActID = r.ActID
AND r.GuestID = 'G5'
AND r.RDate >= '2021-08-03';


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

CREATE TRIGGER Calculate_InvoiceTotal 
ON INVOICE
AFTER INSERT
AS
	UPDATE INVOICE
	SET InvoiceTotal = (SELECT CondoFee FROM inserted) + (SELECT ActivitiyFee FROM inserted)
	UPDATE INVOICE
	SET SalesTax = InvoiceTotal * 0.09
	UPDATE INVOICE
	SET GrandTotal = InvoiceTotal + SalesTax;


EXEC Create_Invoice 'G5', '2021-08-03';

SELECT * FROM INVOICE;