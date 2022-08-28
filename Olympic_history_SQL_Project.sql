
/*
120 years of Olympic history: athletes and results
Athens 1896 to Rio 2016

Data cleaning and preparation
*/


-- Check Table athelete_events
SELECT TOP 10 * FROM athlete_events

-- Check Table noc_regions
SELECT TOP 10 * FROM noc_regions

-- Get info from both tables used
SELECT 
TABLE_CATALOG,
TABLE_SCHEMA,
TABLE_NAME, 
COLUMN_NAME, 
DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS



-- Find Leading & Trailing spaces on Column 'Name' and remove them
SELECT * FROM athlete_events 
WHERE Name not like LTRIM(RTRIM(Name))

Update athlete_events SET Name = TRIM(Name)


-- Add Region Column to athlete_events
ALTER TABLE athlete_events 
ADD Region nvarchar(50);


--Populate Region Column with data from noc_regions
UPDATE athlete_events
SET athlete_events.Region = noc_regions.region
FROM athlete_events 
Join noc_regions
     ON athlete_events.NOC = noc_regions.NOC


 -- Replacing NULL region
SELECT Distinct(NOC)
FROM athlete_events
WHERE Region IS NULL

SELECT Distinct COUNT(NOC) as NULLS
FROM athlete_events
WHERE Region IS NULL

SELECT *
FROM athlete_events
WHERE Region IS NULL

UPDATE athlete_events
SET Region = 'Singapore'
WHERE NOC = 'SGP'


-- Delete unnecessary columns
ALTER TABLE athlete_events
DROP COLUMN ID, Age, Height, Weight, Team, NOC, Year

Select * FROM athlete_events
ORDER By Name


-- Identify Duplicates
WITH CTE AS(
   SELECT *,
       RN = ROW_NUMBER() OVER (PARTITION BY Name, Sex, Games, Season, City, Sport, Medal, Region, Event ORDER BY Name)
   FROM athlete_events
   )
SELECT * FROM CTE WHERE RN > 1

-- Remove Duplicates
WITH CTE AS(
   SELECT *,
       RN = ROW_NUMBER() OVER (PARTITION BY Name, Sex, Games, Season, City, Sport, Medal, Region, Event ORDER BY Name)
   FROM athlete_events
   )
DELETE FROM CTE WHERE RN > 1


----------------------------------------------------------------------------------------------------------------------------------------------------------

/*
Exploratory Analysis
*/

 -- TOP 10 Regions with Medals (Summer Games)
SELECT TOP(10) Region,
SUM(CASE medal WHEN 'Gold' THEN 1 ELSE 0 END) AS Gold_Medal_Count,
SUM(CASE medal WHEN 'Silver' THEN 1 ELSE 0 END) AS Silver_Medal_Count,
SUM(CASE medal WHEN 'Bronze' THEN 1 ELSE 0 END) AS Bronze_Medal_Count, 
SUM(CASE medal
  WHEN 'Gold' THEN 1
  WHEN 'Silver' THEN 1
  WHEN 'Bronze' THEN 1
  ELSE 0 END) AS Total
  FROM athlete_events
  WHERE Season = 'Summer'
  GROUP by Region
  ORDER by Total desc

  -- TOP 10 Regions with Medals (Winter Games)
SELECT TOP(10) Region,
SUM(CASE medal WHEN 'Gold' THEN 1 ELSE 0 END) AS Gold_Medal_Count, 
SUM(CASE medal WHEN 'Silver' THEN 1 ELSE 0 END) AS Silver_Medal_Count,
SUM(CASE medal WHEN 'Bronze' THEN 1 ELSE 0 END) AS Bronze_Medal_Count, 
SUM(CASE medal
  WHEN 'Gold' THEN 1
  WHEN 'Silver' THEN 1
  WHEN 'Bronze' THEN 1
  ELSE 0 END) AS Total
  FROM athlete_events
  WHERE Season = 'Winter'
  GROUP by Region
  ORDER by Total desc

   -- TOP 5 Medalists (Summer Games)
SELECT TOP(5) Name, Region, Sport,
SUM(CASE medal WHEN 'Gold' THEN 1 ELSE 0 END) AS Gold_Medal_Count, 
SUM(CASE medal WHEN 'Silver' THEN 1 ELSE 0 END) AS Silver_Medal_Count,
SUM(CASE medal WHEN 'Bronze' THEN 1 ELSE 0 END) AS Bronze_Medal_Count, 
SUM(CASE medal 
  WHEN 'Gold' THEN 1
  WHEN 'Silver' THEN 1
  WHEN 'Bronze' THEN 1
  ELSE 0 END) AS Total
 FROM athlete_events
 WHERE Season = 'Summer'
 GROUP by Name, Region, Sport
 ORDER by Total desc

    -- TOP 5 Medalists (Winter Games)
SELECT TOP(5) Name, Region, Sport,
SUM(CASE medal WHEN 'Gold' THEN 1 ELSE 0 END) AS Gold_Medal_Count, 
SUM(CASE medal WHEN 'Silver' THEN 1 ELSE 0 END) AS Silver_Medal_Count,
SUM(CASE medal WHEN 'Bronze' THEN 1 ELSE 0 END) AS Bronze_Medal_Count, 
SUM(CASE medal 
  WHEN 'Gold' THEN 1
  WHEN 'Silver' THEN 1
  WHEN 'Bronze' THEN 1
  ELSE 0 END) AS Total
 FROM athlete_events
 WHERE Season = 'Winter'
 GROUP by Name, Region, Sport
 ORDER by Total desc

 -- Percentage Female per Year (Summer Games)
 SELECT Games,
 COUNT(CASE Sex WHEN 'F' THEN 1 END)*100.0 / (COUNT(CASE Sex WHEN 'M' THEN 1 END) + COUNT(CASE Sex WHEN 'F' THEN 1 END)) AS Female_Propotion
 FROM athlete_events
 WHERE Season = 'Summer'
 GROUP by Games
 ORDER by Games

  -- Percentage Female per Year (Winter Games)
 SELECT Games,
 COUNT(CASE Sex WHEN 'F' THEN 1 END)*100.0 / (COUNT(CASE Sex WHEN 'M' THEN 1 END) + COUNT(CASE Sex WHEN 'F' THEN 1 END)) AS Female_Propotion
 FROM athlete_events
 WHERE Season = 'Winter'
 GROUP by Games
 ORDER by Games

 -- Distinct Sports per Season (Summer Games)
SELECT Games, COUNT (DISTINCT Sport) AS Distinct_Summer_Sports
FROM athlete_events
WHERE Season = 'Summer'
GROUP by Games
ORDER by Games

-- Distinct Sports per Season (Winter Games)
SELECT Games, COUNT (DISTINCT Sport) AS Distinct_Winter_Sports
FROM athlete_events
WHERE Season = 'Winter'
GROUP by Games
ORDER by Games

-- Total sport appearances (Summer Games)
SELECT  sport, (count (distinct Games) * 100.0) / 
(Select Count(Distinct games)
FROM athlete_events
Where Season = 'Summer') as Appearances_Games
FROM athlete_events
WHERE Season = 'Summer'
GROUP by  sport
ORDER by Appearances_Games desc

-- Total sport appearances (Winter Games)
SELECT  sport, (count (distinct Games) * 100.0) / 
(Select Count(Distinct games)
FROM athlete_events
Where Season = 'Winter') as Appearances_Games
FROM athlete_events
WHERE Season = 'Winter'
GROUP by  sport
ORDER by Appearances_Games desc
