-- Query 1: Retrieve all records from the CONDO table.
SELECT * FROM CONDO;

-- Query 2: Create a new table named NEW_CONDO_A by copying records from the CONDO table where the building number is 'A'.
SELECT * INTO NEW_CONDO_A
FROM CONDO
WHERE BldgNum = 'A';

-- Query 3: Update the daily rate and square footage for 3-bedroom condos in the NEW_CONDO_A table.
UPDATE NEW_CONDO_A
SET DailyRate = DailyRate * 1.15, SqrFt = SqrFt + 200
WHERE Bdrms = 3;

-- Query 4: Delete 2-bedroom condos in the NEW_CONDO_A table with a daily rate less than $145 and display the remaining records.
DELETE FROM NEW_CONDO_A
WHERE Bdrms = 2 AND DailyRate < 145;
SELECT * FROM NEW_CONDO_A;

-- Query 5: Identify guides who did not renew their certification on time.
SELECT GuideID AS 'Guide ID', CertDate AS 'Certification Date', CertRenewDate AS 'Certification Renewal Date'
FROM GUIDE
WHERE DATEADD(year, 2, CertDate) < CertRenewDate;

-- Query 6: List the three most senior employees based on their hire date.
SELECT TOP(3) EmpID AS 'Employee ID', CONCAT(FName, ' ', LName) AS 'Employee Name', Hiredate AS 'Hire Date'
FROM EMPLOYEE
ORDER BY Hiredate;

-- Query 7: Display guest IDs who booked a condo in building A starting in May 2021.
SELECT GuestID
FROM BOOKING
WHERE YEAR(StartDate) = 2021 AND MONTH(StartDate) = 5 AND BldgNum = 'A';

-- Query 8: Retrieve reservation data for the second page of the FamCation reservation report.
SELECT *
FROM RESERVATION
ORDER BY RDate DESC
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY;

-- Query 9: Show Marketing employee IDs and their monthly salaries.
SELECT EmpID AS 'Employee ID', Department, (Salary / 12) AS 'Monthly Salary',
CAST((Salary / 12) AS DECIMAL(7, 2)) AS 'Monthly Salary in Decimal',
CAST((Salary / 12) AS DECIMAL(5, 0)) AS 'Monthly Salary in Integer'
FROM EMPLOYEE
WHERE Department = 'Marketing';

-- Query 10: Retrieve reservations for horseback riding activities in 2020 not led by guides RH01 or MR01.
SELECT * FROM RESERVATION
WHERE YEAR(RDate) = 2020
AND ActID LIKE 'HB%'
AND GuideID NOT IN ('RH01', 'MR01');

-- Query 11: Determine the most, least, and average years of experience for FamCation Resort employees.
SELECT MAX(DATEDIFF(year, Hiredate, CAST (GETDATE() AS Date) )) AS 'Most Years',
MIN(DATEDIFF(year, Hiredate, CAST(GETDATE () AS Date))) AS 'Least Years',
AVG(DATEDIFF(year, Hiredate, CAST (GETDATE () AS Date))) AS 'Average Years'
FROM EMPLOYEE;

-- Query 12: Display 2-bedroom condos in building 'C' with a daily rate > $130 and 3-bedroom condos in building 'C' with a daily rate > $145.
SELECT * FROM CONDO
WHERE BldgNum = 'C'
AND ((Bdrms = 2 AND DailyRate >= 130) OR (Bdrms = 3 AND DailyRate >= 145));

-- Query 13: Show the average daily rate as an integer by building number.
SELECT BldgNum AS 'Building Number', CAST(AVG(DailyRate) AS INTEGER) AS 'Average Daily Rate'
FROM CONDO
GROUP BY BldgNum;

-- Query 14: Display guest IDs, years of start date, and total number of visits per year for frequent visitors (>5 times per year).
SELECT GuestID, YEAR(StartDate) AS 'Year', COUNT(*) AS 'No of visits'
FROM BOOKING
GROUP BY GuestID, YEAR(StartDate)
HAVING COUNT(*) > 5;

-- Query 15: Find guests with booking records entered twice, showing duplicate details.
SELECT GuestID, BldgNum, UnitNum, StartDate, EndDate, COUNT(*) AS 'No of visits'
FROM BOOKING
GROUP BY GuestID, BldgNum, UnitNum, StartDate, EndDate
HAVING COUNT(*) = 2;

-- Query 16: Display the top 3 most popular activities in 2021 based on reservation count first and then by number in party.
SELECT TOP 3 ActID AS 'Activity ID', SUM(NumerInParty) AS 'Party Count', COUNT(*) AS 'Reservation Count'
FROM RESERVATION
WHERE YEAR(RDate) = 2021
GROUP BY ActID
ORDER BY 3 DESC, 2 DESC;

-- Query 17: Display the top 3 most popular activities in 2021 based on reservation count only, including tied counts.
SELECT ActID AS 'Activity ID', SUM(NumerInParty) AS 'Party Count', COUNT(*) AS 'Reservation Count'
FROM RESERVATION
WHERE YEAR(RDate) = 2021
GROUP BY ActID
HAVING COUNT(*) IN (SELECT TOP 3 COUNT(*) FROM RESERVATION WHERE YEAR(RDate) = 2021 GROUP BY ActID ORDER BY COUNT(*) DESC)
ORDER BY 3 DESC;

-- Query 18: Show total party participants and reservation count for each horseback activity in 2021.
SELECT ActID AS 'Activity ID', SUM(NumerInParty) AS 'Party Count', COUNT(ResID) AS 'Reservation Count'
FROM RESERVATION
WHERE YEAR(RDate) = 2021
GROUP BY ActID
HAVING ActID LIKE 'HB%';

-- Query 19: Display individual activity, guest, and guide IDs along with party count and reservation count for each horseback activity in 2021.
SELECT ActID AS 'Activity ID', GuestID AS 'Guest ID', GuideID AS 'Guide ID',
SUM(NumerInParty) OVER (PARTITION BY ActID, GuideID) AS 'Party Count',
COUNT(ResID) OVER (PARTITION BY ActID, GuideID) AS 'Reservation Count'
FROM RESERVATION
WHERE YEAR(RDate) = 2021
AND ActID LIKE 'HB%'
ORDER BY ActID;

-- Query 20: Show individual guide, activity, and guest IDs along with party count and reservation count for each guide in 2021.
SELECT GuideID AS 'Guide ID', ActID AS 'Activity ID', GuestID AS 'Guest ID',
SUM(NumerInParty) OVER (PARTITION BY GuideID) AS 'Party Count',
COUNT(ResID) OVER (PARTITION BY GuideID) AS 'Reservation Count'
FROM RESERVATION
WHERE YEAR(RDate) = 2021
AND ActID LIKE 'HB%'
ORDER BY GuideID;

-- Query 21: Display month, activity, guest, and reservation date along with reservation count for each month and activity in 2021.
SELECT MONTH(RDate) AS 'Month', ActID AS 'Activity ID', GuestID AS 'Guest ID', RDate AS 'Reservation Date',
COUNT(ResID) OVER (PARTITION BY MONTH(RDate), ActID) AS 'Reservation Count'
FROM RESERVATION
WHERE YEAR(RDate) = 2021
AND ActID LIKE 'HB%'
ORDER BY Month;

-- Query 22: Retrieve records of temporary housekeepers hired after January 1, 2018.
SELECT EmpID AS 'Employee ID', FName AS 'First Name', LName AS 'Last Name', Status AS 'Status', Shift AS 'Shift'
FROM EMPLOYEE e, HOUSEKEEPER h
WHERE e.EmpID = h.HKID
AND Hiredate > '2018-01-01'
AND Status = 'Temp';

-- Query 23: Show all Rafting reservations led by 'Zach'.
SELECT r.ResID AS 'Reservation ID', r.RDate AS 'Reservation Date', CONCAT(g.FName, ' ', g.LName) AS 'Guest Name', r.ActID AS 'Activity ID'
FROM RESERVATION r, ACTIVITY a, EMPLOYEE e, GUEST g
WHERE r.ActID = a.ActID
AND r.GuideID = e.EmpID
AND r.GuestID = g.GuestID
AND a.Type = 'Rafting'
AND e.FName = 'Zach';

-- Query 24: Add activity description and calculate total activity amount for the top 3 activities in 2021.
SELECT TOP 3 r.ActID AS 'Activity ID', a.Description AS 'Description', COUNT(r.ActID) AS 'Reservation Count', SUM(r.NumInParty * a.PPP) AS 'Total Activity Amount'
FROM RESERVATION r, ACTIVITY a
WHERE r.ActID = a.ActID
AND YEAR(r.RDate) = 2021
GROUP BY r.ActID, a.Description
ORDER BY 3 DESC, 4 DESC;

-- Query 25: Display guests from California, their children's count, names, and ages.
SELECT g.GuestID AS 'Guest ID', g.FName AS 'First Name', g.LName AS 'Last Name', COUNT(*) OVER (PARTITION BY g.GuestID) AS 'Number of Children', f.FName AS 'First Name', DATEDIFF(YEAR, f.Birthdate, GETDATE()) AS 'Age'
FROM GUEST g, FAMILY f
WHERE g.GuestID = f.GuestID
AND g.State = 'CA';

-- Query 26: Find unit numbers of all 3-bedroom condos in building A and use the result to find their bookings in 2020.
SELECT GuestID AS 'Guest ID', StartDate AS 'Start Date', EndDate AS 'End Date', UnitNum AS 'Unit Number'
FROM BOOKING b
WHERE YEAR(b.StartDate) = 2020 AND YEAR(b.EndDate) = 2020
AND EXISTS (
    SELECT BldgNum, UnitNum
    FROM CONDO c
    WHERE b.UnitNum = c.UnitNum
    AND c.Bdrms = 3
    AND c.BldgNum = 'A'
)
ORDER BY StartDate;

-- Query 27: Use a left join to display all California guests without children.
SELECT g.GuestID AS 'Guest ID', g.FName AS 'First Name', g.LName AS 'Last Name', g.SpouseFName AS 'Spouse First Name', f.GuestID AS 'Children'
FROM GUEST g
LEFT JOIN FAMILY f
ON g.GuestID = f.GuestID
WHERE g.State = 'CA'
AND f.GuestID IS NULL;

-- Query 28: Use a sub-query to find California guests without children.
SELECT GuestID AS 'Guest ID', FName AS 'First Name', LName AS 'Last Name', SpouseFName AS 'Spouse First Name'
FROM GUEST
WHERE State = 'CA'
AND GuestID NOT IN (
    SELECT DISTINCT GuestID
    FROM FAMILY
);

-- Query 29: Show guide's full name, hire date, their manager’s full name, and manager’s hire date.
SELECT CONCAT(e1.FName, ' ', e1.LName) AS 'Employee Name', e1.Hiredate AS 'Hire Date', CONCAT(e2.FName, ' ', e2.LName) AS 'Manager Name', e2.Hiredate AS 'Manager Hire Date'
FROM GUIDE g
JOIN EMPLOYEE e1 ON g.GuideID = e1.EmpID
JOIN EMPLOYEE e2 ON e1.MgrNum = e2.EmpID;

-- Query 30: Display highest weekly fee for building A, lowest for B, and average for C.
SELECT
    CASE 
        WHEN BldgNum = 'A' THEN 'Highest Weekly Fee'
        WHEN BldgNum = 'B' THEN 'Lowest Weekly Fee'
        WHEN BldgNum = 'C' THEN 'Average Weekly Fee'
    END AS 'Category',
    BldgNum AS 'Building Number',
    CAST(CASE 
        WHEN BldgNum = 'A' THEN MAX(DailyRate)
        WHEN BldgNum = 'B' THEN MIN(DailyRate)
        WHEN BldgNum = 'C' THEN AVG(DailyRate)
    END AS INTEGER) AS 'Weekly Fee'
FROM CONDO
GROUP BY BldgNum
ORDER BY BldgNum;

-- Query 31: Create a view 'Top Housekeeper' to query top 3 housekeepers with the most cleaning schedules in Aug 2021.
CREATE VIEW Top_Housekeeper AS
SELECT TOP 3 HKID AS 'Housekeeper ID', COUNT(*) AS 'Total Cleaning Schedules'
FROM CLEANING
WHERE MONTH(DateCleaned) = 8 AND YEAR(DateCleaned) = 2021
GROUP BY HKID
ORDER BY 2 DESC;

-- Query 32: Use the 'Top Housekeeper' view to find their details.
SELECT t.HousekeeperID, e1.Hiredate AS 'Hire Date', CONCAT(e1.FName, ' ', e1.LName) AS 'Housekeeper', CONCAT(e2.FName, ' ', e2.LName) AS 'Manager Name'
FROM Top_Housekeeper t
JOIN EMPLOYEE e1 ON t.HousekeeperID = e1.EmpID
JOIN EMPLOYEE e2 ON e1.MgrNum = e2.EmpID;

-- Query 33: Update the New_Activity table to adjust hours and PPP for biking and hiking.
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

-- Query 34: Display the updated activity details.
SELECT Type AS 'Activity Type', SUM(Hours) AS 'Total Hours', SUM(PPP) AS 'Total PPP'
FROM NEW_ACTIVITY
GROUP BY Type
HAVING Type IN ('Bike', 'Hike');

-- Query 35: Retrieve records of temporary housekeepers hired after Jan 1, 2018.
SELECT EmpID AS 'Employee ID', FName AS 'First Name', LName AS 'Last Name', Status AS 'Status', Shift AS 'Shift'
FROM EMPLOYEE e
JOIN HOUSEKEEPER h ON e.EmpID = h.HKID
WHERE Hiredate > '2018-01-01'
AND Status = 'Temp';

-- Query 36: Show Rafting reservations led by 'Zach'.
SELECT r.ResID AS 'Reservation ID', r.RDate AS 'Reservation Date', CONCAT(g.FName, ' ', g.LName) AS 'Guest Name', r.ActID AS 'Activity ID'
FROM RESERVATION r
JOIN ACTIVITY a ON r.ActID = a.ActID
JOIN EMPLOYEE e ON r.GuideID = e.EmpID
JOIN GUEST g ON r.GuestID = g.GuestID
WHERE a.Type = 'Rafting'
AND e.FName = 'Zach';

-- Query 37: Add activity description and calculate total activity amount for the top 3 activities in 2021.
SELECT TOP 3 r.ActID AS 'Activity ID', a.Description AS 'Description', COUNT(r.ActID) AS 'Reservation Count', SUM(r.NumInParty * a.PPP) AS 'Total Activity Amount'
FROM RESERVATION r
JOIN ACTIVITY a ON r.ActID = a.ActID
WHERE YEAR(r.RDate) = 2021
GROUP BY r.ActID, a.Description
ORDER BY 3 DESC, 4 DESC;

-- Query 38: Display California guests, their children's count, names, and ages.
SELECT g.GuestID AS 'Guest ID', g.FName AS 'First Name', g.LName AS 'Last Name', COUNT(*) OVER (PARTITION BY g.GuestID) AS 'Number of Children', f.FName AS 'First Name', DATEDIFF(YEAR, f.Birthdate, GETDATE()) AS 'Age'
FROM GUEST g
LEFT JOIN FAMILY f ON g.GuestID = f.GuestID
WHERE g.State = 'CA';

-- Query 39: Find unit numbers of all 3-bedroom condos in building A and use the result to find their bookings in 2020.
SELECT GuestID AS 'Guest ID', StartDate AS 'Start Date', EndDate AS 'End Date', UnitNum AS 'Unit Number'
FROM BOOKING b
WHERE YEAR(b.StartDate) = 2020 AND YEAR(b.EndDate) = 2020
AND EXISTS (
    SELECT BldgNum, UnitNum
    FROM CONDO c
    WHERE b.UnitNum = c.UnitNum
    AND c.Bdrms = 3
    AND c.BldgNum = 'A'
)
ORDER BY StartDate;

-- Query 40: Use a left join to display all California guests without children.
SELECT g.GuestID AS 'Guest ID', g.FName AS 'First Name', g.LName AS 'Last Name', g.SpouseFName AS 'Spouse First Name'
FROM GUEST g
LEFT JOIN FAMILY f ON g.GuestID = f.GuestID
WHERE g.State = 'CA'
AND f.GuestID IS NULL;

-- Query 41: Use a sub-query to find California guests without children.
SELECT GuestID AS 'Guest ID', FName AS 'First Name', LName AS 'Last Name', SpouseFName AS 'Spouse First Name'
FROM GUEST
WHERE State = 'CA'
AND GuestID NOT IN (
    SELECT DISTINCT GuestID
    FROM FAMILY
);

-- Query 42: Show guide's full name, hire date, their manager’s full name, and manager’s hire date.
SELECT CONCAT(e1.FName, ' ', e1.LName) AS 'Employee Name', e1.Hiredate AS 'Hire Date', CONCAT(e2.FName, ' ', e2.LName) AS 'Manager Name', e2.Hiredate AS 'Manager Hire Date'
FROM GUIDE g
JOIN EMPLOYEE e1 ON g.GuideID = e1.EmpID
JOIN EMPLOYEE e2 ON e1.MgrNum = e2.EmpID;

-- Query 43: Display highest weekly fee for building A, lowest for B, and average for C.
SELECT
    CASE 
        WHEN BldgNum = 'A' THEN 'Highest Weekly Fee'
        WHEN BldgNum = 'B' THEN 'Lowest Weekly Fee'
        WHEN BldgNum = 'C' THEN 'Average Weekly Fee'
    END AS 'Category',
    BldgNum AS 'Building Number',
    CAST(CASE 
        WHEN BldgNum = 'A' THEN MAX(DailyRate)
        WHEN BldgNum = 'B' THEN MIN(DailyRate)
        WHEN BldgNum = 'C' THEN AVG(DailyRate)
    END AS INTEGER) AS 'Weekly Fee'
FROM CONDO
GROUP BY BldgNum
ORDER BY BldgNum;

-- Query 44: Create a view 'Top Housekeeper' to query top 3 housekeepers with the most cleaning schedules in Aug 2021.
CREATE VIEW Top_Housekeeper AS
SELECT TOP 3 HKID AS 'Housekeeper ID', COUNT(*) AS 'Total Cleaning Schedules'
FROM CLEANING
WHERE MONTH(DateCleaned) = 8 AND YEAR(DateCleaned) = 2021
GROUP BY HKID
ORDER BY 2 DESC;

-- Query 45: Use the 'Top Housekeeper' view to find their details.
SELECT t.HousekeeperID, e1.Hiredate AS 'Hire Date', CONCAT(e1.FName, ' ', e1.LName) AS 'Housekeeper', CONCAT(e2.FName, ' ', e2.LName) AS 'Manager Name'
FROM Top_Housekeeper t
JOIN EMPLOYEE e1 ON t.HousekeeperID = e1.EmpID
JOIN EMPLOYEE e2 ON e1.MgrNum = e2.EmpID;
