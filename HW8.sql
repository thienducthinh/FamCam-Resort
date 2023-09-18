/* Query 1 */
SELECT * FROM RESERVATION
WHERE YEAR(RDate) = 2020
AND ActID LIKE 'HB%'
AND GuideID NOT IN ('RH01', 'MR01');


/* Query 2 */
SELECT MAX(DATEDIFF(year, Hiredate, CAST (GETDATE() AS Date) )) AS 'Most Years',
MIN(DATEDIFF(year, Hiredate, CAST(GETDATE () AS Date))) AS 'Least Years',
AVG(DATEDIFF(year, Hiredate, CAST (GETDATE () AS Date))) AS 'Average Years'
FROM EMPLOYEE;


