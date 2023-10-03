/* Query 1: Write a simple select * query to review the Condo table first. You should see 45 records. */

SELECT * FROM CONDO;


/* Query 2: Based on the same table definition of Condo, create a duplicate table, New_Condo_A, by using the Select * into statement to populate the new table with all Building A records. Complete this question with only one SQL statement. */

SELECT * INTO NEW_CONDO_A
FROM CONDO
WHERE BldgNum = 'A';

SELECT * FROM NEW_CONDO_A;


/* Query 3: Make 2 changes to 3-bedroom condos (there are 3 of them) in New_Condo_A, 1) add 15% to the daily rate and 2) add 200 square feet. Display the updated result for these 3 records. If your query result is incorrect, you might want to drop the new_condo_A table and recreate it before you retry. */

UPDATE NEW_CONDO_A
SET DailyRate = DailyRate * 1.15, SqrFt = SqrFt + 200
WHERE Bdrms = 3;

SELECT * FROM NEW_CONDO_A
WHERE Bdrms = 3;


/* Query 4: Delete 2-bedroom condos in New_Condo_A having the daily rate less than $145. Show your delete query statement and display all the remaining records in New_Condo_A. */

DELETE FROM NEW_CONDO_A
WHERE Bdrms = 2 AND DailyRate < 145;

SELECT * NEW_CONDO_A;


/* Basic SQL DQL Questions */
/* Query 5: FamCation requires all guides to renew their certificate every two years from the previous certified date. Write a query to find guides who didn't renew their certificate on time. */

SELECT GuideID AS 'Guide ID', CertDate AS 'Certification Date', CertRenewDate AS 'Certification Renewal Date'
FROM GUIDE
WHERE DATEADD(year, 2, CertDate) < CertRenewDate;


/* Query 6: Select the 3 most senior employees in FamCation based on their HireDate. Display the employee ID, Employee Name (first name and last name), and hire date. Relabel the attributes according to the provided query result. */

SELECT TOP(3) EmpID AS 'Employee ID', CONCAT(FName, ' ', LName) AS 'Employee Name', Hiredate AS 'Hire Date'
FROM EMPLOYEE
ORDER BY Hiredate;


/* Query 7: Display a list of guest IDs who booked a condo in building A starting in the month of May 2021. Relabel the guestID as 'Guest ID'. */

SELECT GuestID
FROM BOOKING
WHERE YEAR(StartDate) = 2021 AND MONTH(StartDate) = 5 AND BldgNum = 'A'


/* Query 8: FamCation reservation report can only show 10 reservations on each page. The report prints the latest reservations first. Write a query to retrieve data for the second page. */

SELECT *
FROM RESERVATION
ORDER BY RDate DESC
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY;


/* Query 9: The current FamCation database stores employee's annual salary. Write a query to show 'Marketing' employee ID and their monthly salary. */

SELECT EmpID AS 'Employee ID', Department, (Salary / 12) AS 'Monthly Salary',
CAST((Salary / 12) AS DECIMAL(7, 2)) AS 'Monthly Salary in Decimal',
CAST((Salary / 12) AS DECIMAL(5, 0)) AS 'Monthly Salary in Integer'
FROM EMPLOYEE
WHERE Department = 'Marketing'

/* Query 1: Write a query to show all the reservations in 2020 for horseback riding activities (Act ID starting with ‘HB’) that were not led by guide RH01 or MR01. */
SELECT * FROM RESERVATION
WHERE YEAR(RDate) = 2020
AND ActID LIKE 'HB%'
AND GuideID NOT IN ('RH01', 'MR01');


/* Query 2: Display the most number of years, the least number of years, and the average number of years FamCation Resort employees have been with the company? Label the columns as ‘Most Years’, ‘Least Years’, and ‘Average Years’. A 2.5 years of experience will be displayed as 2 years. (Note: your year numbers might not match the provided solution depending on the start date of your 5 Technology employees.) */
SELECT MAX(DATEDIFF(year, Hiredate, CAST (GETDATE() AS Date) )) AS 'Most Years',
MIN(DATEDIFF(year, Hiredate, CAST(GETDATE () AS Date))) AS 'Least Years',
AVG(DATEDIFF(year, Hiredate, CAST (GETDATE () AS Date))) AS 'Average Years'
FROM EMPLOYEE;


/* Query 3: Display all 2-bedroom condos in building 'C' having a daily rate greater than $130, and 3-bedroom condos in building 'C' having a daily rate greater than 145. */
SELECT * FROM CONDO
WHERE BldgNum = 'C'
AND ((Bdrms = 2 AND DailyRate >= 130) OR (Bdrms = 3 AND DailyRate >= 145));

/* Query 4: Display the average daily rate as an integer by building number. */
SELECT BldgNum AS 'Building Number', CAST(AVG(DailyRate) AS INTEGER) AS 'Average Daily Rate'
FROM CONDO
GROUP BY BldgNum;

/* Query 5: Use Group by ... Having to display the guestID, the year of the start date (label it as Year), and the total number of visits per year (label it as No of Visits). Filter the result to only show frequent visitors who have visited more than 5 times per year. */
SELECT GuestID, YEAR(StartDate) AS 'Year', COUNT(*) AS 'No of visits'
FROM BOOKING
GROUP BY GuestID, YEAR(StartDate)
HAVING COUNT(*) > 5;

/* Query 6: Find the guest who had a booking record mistakenly entered twice, i.e., the two records have the same guest ID, start/end dates, bldgnum, and unit num. */
SELECT GuestID, BldgNum, UnitNum, StartDate, EndDate, COUNT(*) AS 'No of visits'
FROM BOOKING
GROUP BY GuestID, BldgNum, UnitNum, StartDate, EndDate
HAVING COUNT(*) = 2;

/* Query 7: Display the top 3 most popular activities in 2021 based on the reservation count first and then by the number in party. Only display 3 records. */
SELECT TOP 3 ActID AS 'Activity ID', SUM(NumerInParty) AS 'Party Count', COUNT(*) AS 'Reservation Count'
FROM RESERVATION
WHERE YEAR(RDate) = 2021
GROUP BY ActID
ORDER BY 3 DESC, 2 DESC;

/* Query 8: Display the top 3 most popular activities in 2021 based on reservation count only. Activities with the same reservation count should also be displayed */
SELECT ActID AS 'Activity ID', SUM(NumerInParty) AS 'Party Count', COUNT(*) AS 'Reservation Count'
FROM RESERVATION
WHERE YEAR(RDate) = 2021
GROUP BY ActID
HAVING COUNT(*) IN (SELECT TOP 3 COUNT(*) FROM RESERVATION WHERE YEAR(RDate) = 2021 GROUP BY ActID ORDER BY COUNT(*) DESC)
ORDER BY 3 DESC;

/* Query 9: Display the total party participants and total reservation count for each horseback activities in 2021. */
SELECT ActID AS 'Activity ID', SUM(NumerInParty) AS 'Party Count', COUNT(ResID) AS 'Reservation Count'
FROM RESERVATION
WHERE YEAR(RDate) = 2021
GROUP BY ActID
HAVING ActID LIKE 'HB%';


/* Query 10: Display the individual ActID, GuestID, and GuideID that make up the total party participants and reservation count for each horseback activity in 2021. Order by activity ID. */
SELECT ActID AS 'Activity ID', GuestID AS 'Guest ID', GuideID AS 'guideid',
SUM(NumerInParty) OVER (PARTITION BY ActID, GuideID) AS 'Party Count',
COUNT(ResID) OVER (PARTITION BY ActID, GuideID) AS 'Reservation Count'
FROM RESERVATION
WHERE YEAR(RDate) = 2021
AND ActID LIKE 'HB%'
ORDER BY ActID;

/* Query 11: Display the individual GuideID, ActID, and GuestID that make up the total party participants and reservation count for each guide in 2021. Order by guide ID. */
SELECT GuideID AS 'guideid', ActID AS 'Activity ID', GuestID AS 'Guest ID',
SUM(NumerInParty) OVER (PARTITION BY GuideID) AS 'Party Count',
COUNT(ResID) OVER (PARTITION BY GuideID) AS 'Reservation Count'
FROM RESERVATION
WHERE YEAR(RDate) = 2021
AND ActID LIKE 'HB%'
ORDER BY GuideID;

/* Query 12: Display the month, individual ActID, GuestID, and reservation date that make up the total reservation count for each month and activity in 2021. Order by Month and ActID. */
SELECT MONTH(RDate) AS 'Month', ActID AS 'Activity ID', GuestID AS 'Guest ID', RDate AS 'Reservation Date',
COUNT(ResID) OVER (PARTITION BY MONTH(RDate), ActID) AS 'Reservation Count'
FROM RESERVATION
WHERE YEAR(RDate) = 2021
AND ActID LIKE 'HB%'
ORDER BY Month;

/* Query 1: Display all temporary housekeepers hired after 01-01-2018. Display attributes are listed below. */
SELECT EmpID AS 'empid', FName AS 'fname', LName AS 'lname', Status AS 'status', Shift AS 'shift'
FROM EMPLOYEE e, HOUSEKEEPER h
WHERE e.EmpID = h.HKID
AND Hiredate > '2018-01-01'
AND Status = 'Temp';


/* Query 2: Write a query to show all the Rafting reservations led by 'Zach'. Display the attributes/labels as follows. */
SELECT r.ResID AS 'Reservation ID', r.RDate AS 'rdate', CONCAT(g.FName, ' ', g.LName) AS 'Guest Name', r.ActID AS 'Activity ID'
FROM RESERVATION r, ACTIVITY a, EMPLOYEE e, GUEST g
WHERE r.ActID = a.ActID
AND r.GuideID = e.EmpID
AND r.GuestID = g.GuestID
AND a.Type = 'Rafting'
AND e.FName = 'Zach';

/* Query 3: We found the top 3 activities in HW8. Let's add the activity description and calculate the total activity amount for these three. */
SELECT TOP 3 r.ActID AS 'Activity ID', a.Description AS 'description', COUNT(r.ActID) AS 'Reservation Count', SUM(r.NumInParty * a.PPP) AS 'Total Activity Amount'
FROM RESERVATION r, ACTIVITY a
WHERE r.ActID = a.ActID
AND YEAR(r.RDate) = 2021
GROUP BY r.ActID, a.Description
ORDER BY 3 DESC, 4 DESC;


/* Query 4: Display guests from California, number of their children, children's first names, and their ages. */
SELECT g.GuestID AS 'Guest ID', g.FName AS 'First Name', g.LName AS 'Last Name', COUNT(*) OVER (PARTITION BY g.GuestID) AS 'Number of Children', f.FName AS 'First Name', DATEDIFF(YEAR, f.Birthdate, GETDATE()) AS 'Age'
FROM GUEST g, FAMILY f
WHERE g.GuestID = f.GuestID
AND g.State = 'CA';

/* Query 5: Write a query to find the unit number of all 3-bedroom condos in building A. Use the query result as a sub-query to find their bookings in 2020. Display the guest id, booking start/end dates, and unit number. Order the result by start date. */
SELECT GuestID AS 'Guest ID', StartDate AS 'Start Date', EndDate AS 'End Date', UnitNum AS 'Unit Number'
FROM BOOKING b
WHERE YEAR(b.StartDate) = 2020 AND YEAR(b.EndDate) = 2020
AND EXISTS (
    SELECT BldgNum, UnitNum
    FROM CONDO c
    AND b.UnitNum = c.UnitNum
    AND c.Bedrooms = 3
    AND c.BldgNum = 'A'
)
ORDER BY StartDate;

/* Query 6: Use a left join to show all the guests from California who don't have records of children in the database. */
SELECT g.GuestID AS 'Guest ID', g.FName AS 'First Name', g.LName AS 'Last Name', g.SpouseFName AS 'Spouse First Name', f.GuestID AS 'Children'
FROM GUEST g
LEFT JOIN FAMILY f
ON g.GuestID = f.GuestID
WHERE g.State = 'CA'
AND f.GuestID IS NULL;

/* Query 7: Use a sub-query to answer Q6 and derive the same result. You don't need to display the Children column with null values */
SELECT GuestID AS 'Guest ID', FName AS 'First Name', LName AS 'Last Name', SpouseFName AS 'Spouse First Name'
FROM GUEST
WHERE State = 'CA'
AND GuestID NOT IN (
    SELECT DISTINCT GuestID
    FROM FAMILY
);

/* Query 8: Show all the guide's full name, hired date, their manager’s full name, and manager’s hired date. */
SELECT CONCAT(e1.FName, ' ', e1.LName) AS 'Employee Name', e1.Hiredate AS 'Hire Date', CONCAT(e2.FName, ' ', e2.LName) AS 'Manager Name', e2.Hiredate AS 'Hire Date'
FROM GUIDE g, EMPLOYEE e1, EMPLOYEE e2
WHERE g.GuideID = e1.EmpID
AND e1.MgrNum = e2.EmpID;

/* Query 9: List the highest weekly fee for building A, lowest weekly fee for B, and average weekly fee for C. Display the "Category" (Highest Weekly Fee, Lowest Weekly Fee, Average Weekly Fee), "Building number" and "Weekly fee" as showed below. Display the daily rate as integer and sort the result by building number. */
SELECT
    CASE 
        WHEN BldgNum = 'A' THEN 'Highest Weekly Fee'
        WHEN BldgNum = 'B' THEN 'Lowest Weekly Fee'
        WHEN BldgNum = 'C' THEN 'Average Weekly Fee'
    END AS 'Category',
    BldgNum AS 'Building Number',
    CASE 
        WHEN BldgNum = 'A' THEN CAST(MAX(DailyRate) AS INTEGER)
        WHEN BldgNum = 'B' THEN CAST(MIN(DailyRate) AS INTEGER)
        WHEN BldgNum = 'C' THEN CAST(AVG(DailyRate) AS INTEGER)
    END AS 'Daily Rate'
    FROM CONDO
    GROUP BY BldgNum
    ORDER BY BldgNum;

/* Query 10.1: Create a view called 'Top Housekeeper' to query top 3 housekeepers who have the most cleaning schedules in Aug of 2021. Display a screenshot of the view on the left navigation. */
CREATE VIEW Top_Housekeeper AS
SELECT TOP 3 HKID AS 'Housekeeper ID', COUNT(*) AS 'Total Cleaning Schedules'
FROM CLEANING
WHERE MONTH(DateCleaned) = 8 AND YEAR(DateCleaned) = 2021
GROUP BY HKID
ORDER BY 2 DESC;

/* Query 10.2: Use the Top_Housekeeper view to find their first name, last name, hiredate, and manager's name. */
SELECT t.HKID, e1.Hiredate AS 'Hire Date', CONCAT(e1.FName, ' ', e1.LName) AS 'Housekeeper', CONCAT(e2.FName, ' ', e2.LName) AS 'Manager Name'
FROM Top_Housekeeper t, EMPLOYEE e1, EMPLOYEE e2
WHERE t.HKID = e1.EmpID
AND e1.MgrNum = e2.EmpID;

/* Query 11.1: Update CASE query
a) Create a New_Activity table by making a copy from the Activity table.
b) Use the New_Activity table and write one CASE statement to
• add 3 hours to biking and 2 hours to hiking, and
• increase biking ppp by 30% and hiking ppp by 20%. */
SELECT * FROM NEW_ACTIVITY;

UPDATE NEW_ACTIVITY
SET Hours = CASE
    WHEN Type = 'Bike' THEN Hours + 3
    WHEN Type = 'Hike' THEN Hours + 2
    ELSE Hours
END,
PPP = CASE
    WHEN Type = 'Bike' THEN PPP * 1.30
    WHEN Type = 'Hike' THEN PPP * 1.20
    ELSE PPP
END;


/* Query 11.2: Display the result AFTER the update. Show the total hours and total ppp for hiking and biking separately. */
SELECT Type AS 'Activity Type', SUM(Hours) AS 'Total Hours', SUM(PPP) AS 'Total PPP'
FROM NEW_ACTIVITY
GROUP BY Type
HAVING Type IN ('Bike', 'Hike');
