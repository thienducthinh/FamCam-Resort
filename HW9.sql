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