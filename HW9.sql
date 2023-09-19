/* Query 1: Display all temporary housekeepers hired after 01-01-2018. Display attributes are listed below. */

SELECT EmpID AS 'empid', FName AS 'fname', LName AS 'lname', Status AS 'status', Shift AS 'shift'
FROM EMPLOYEE e, HOUSEKEEPER h
WHERE e.EmpID = h.HKID
AND Hiredate > '2018-01-01'
AND Status = 'Temp';


/* Query 2: Write a query to show all the Rafting reservations led by 'Zach'. Display the attributes/labels as follows. */


/* Query 3: We found the top 3 activities in HW8. Let's add the activity description and calculate the total activity amount for these three. */

SELECT r.ResID AS 'resid', r.RDate AS 'rdate', CONCAT(g.FName, ' ', g.LName) AS 'Guest Name', r.ActID AS 'actid'
FROM RESERVATION r, ACTIVITY a, EMPLOYEE e, GUEST g
WHERE r.ActID = a.ActID
AND r.GuideID = e.EmpID
AND r.GuestID = g.GuestID
AND a.Type = 'Rafting'
AND e.FName = 'Zach';


/* Query 4: Display guests from California, number of their children, children's first names, and their ages. */


/* Query 5: Write a query to find the unit number of all 3-bedroom condos in building A. Use the query result as a sub-query to find their bookings in 2020. Display the guest id, booking start/end dates, and unit number. Order the result by start date. */


/* Query 6: Use a left join to show all the guests from California who don't have records of children in the database. */


/* Query 7: Use a sub-query to answer Q6 and derive the same result. You don't need to display the Children column with null values */


/* Query 8: Show all the guide's full name, hired date, their manager’s full name, and manager’s hired date. */


/* Query 9: List the highest weekly fee for building A, lowest weekly fee for B, and average weekly fee for C. Display the "Category" (Highest Weekly Fee, Lowest Weekly Fee, Average Weekly Fee), "Building number" and "Weekly fee" as showed below. Display the daily rate as integer and sort the result by building number. */


/* Query 10.1: Create a view called 'Top Housekeeper' to query top 3 housekeepers who have the most cleaning schedules in Aug of 2021. Display a screenshot of the view on the left navigation. */


/* Query 10.2: Use the Top_Housekeeper view to find their first name, last name, hiredate, and manager's name. */


/* Query 11.1: Update CASE query
a) Create a New_Activity table by making a copy from the Activity table.
b) Use the New_Activity table and write one CASE statement to
• add 3 hours to biking and 2 hours to hiking, and
• increase biking ppp by 30% and hiking ppp by 20%. */



/* Query 11.2: Display the result AFTER the update. Show the total hours and total ppp for hiking and biking separately. */