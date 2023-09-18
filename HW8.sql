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
