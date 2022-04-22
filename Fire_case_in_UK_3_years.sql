--1. Review dataset
SELECT * FROM fire_case.dbo.fire_cases_in_uk_last_3_years;

--2. Check if the IncidentNumber column is actually unique
SELECT COUNT(IncidentNumber) FROM fire_case..fire_cases_in_uk_last_3_years
GROUP BY IncidentNumber
HAVING COUNT(IncidentNumber)>2;
--  -> There is no duplicate value

--3.  Find null value in Postcode_full
SELECT COUNT(IncidentNumber) FROM fire_case..fire_cases_in_uk_last_3_years
WHERE Postcode_full IS NULL;
-- There are 180948 row with null value

--4.  Find null value in SpecialServiceType
SELECT COUNT(IncidentNumber) FROM fire_case..fire_cases_in_uk_last_3_years
WHERE SpecialServiceType IS NULL;

--5.  Replace NULL values in SpecialServiceType with "not action"
UPDATE fire_case..fire_cases_in_uk_last_3_years
SET SpecialServiceType = 'no action'  
WHERE SpecialServiceType IS NULL;

SELECT * FROM fire_case.dbo.fire_cases_in_uk_last_3_years;

--6.  Number of fire cases from 2019 to Feb.22
SELECT COUNT(incidentNumber) FROM fire_case..fire_cases_in_uk_last_3_years;
-- There are 331,570 fire cases in UK from 2019 to Feb.22

--7. Number of fire cases each year 2019, 2020, 2021
SELECT DISTINCT(CalYear), COUNT(CalYear) Num_cases FROm fire_case..fire_cases_in_uk_last_3_years
GROUP BY CalYear
ORDER BY COUNT(CalYear) DESC;
-- In last 3 years 2021 had the largest number of fires

--8. Find the addressqualifier incurred on street
SELECT * FROM fire_case..fire_cases_in_uk_last_3_years
WHERE AddressQualifier LIKE '%street%';

--9.  Combined Specific address into 1 columns
SELECT CONCAT(FRS,' ',IncGeo_WardNameNew,' ',IncGeo_BoroughName)
FROM fire_case..fire_cases_in_uk_last_3_years;

--10.  NUmber of station ground have more one for first pump
SELECT IncidentStationGround, COUNT(FirstPumpArriving_AttendanceTime), COUNT(IncidentStationGround) 
FROM fire_case..fire_cases_in_uk_last_3_years
GROUP BY IncidentStationGround
HAVING COUNT(FirstPumpArriving_AttendanceTime) > 1
ORDER BY COUNT(FirstPumpArriving_AttendanceTime) DESC;
-- We noted that for the stationgroup have large of fire cases, the number of FirstPump is also equipped with booster

--11. Remove Unused Columns
Alter Table fire_case..fire_cases_in_uk_last_3_years
Drop Column Postcode_full, UPRN, USRN;

--12.  update session of the days

SELECT DISTINCT(HourOfCall) FROM fire_case.dbo.fire_cases_in_uk_last_3_years;

SELECT *, 
CASE 
WHEN (HourOfCall BETWEEN 5 AND 11) THEN 'Morning'
WHEN (HourOfCall BETWEEN 11 AND 13) THEN 'Midday'
WHEN (HourOfCall BETWEEN 13 AND 18) THEN 'Afternoon'
WHEN (HourOfCall BETWEEN 18 AND 23) THEN 'Evening'
ELSE 'Night'
END AS SessionOfDay
FROM fire_case..fire_cases_in_uk_last_3_years;


