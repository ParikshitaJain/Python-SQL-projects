--Descriptive Analysis
--Accident Frequency Analysis/Time-Based Analysis

--Total accidents per year for each country (using pivot able)
WITH cte1 (country,year,total_accidents)
AS
(
SELECT country, year, count(year)as total_accidents
FROM PortfolioProjects..road_accident_dataset
--where country='Canada'
GROUP BY country,year
)
SELECT * 
FROM (
    SELECT country,year,total_accidents
    FROM cte1
) AS source_table
PIVOT (
    SUM(total_accidents) FOR country IN ([Germany], [Canada],[USA],[Japan],[India],[UK],[Russia],[China],[Australia],[Brazil])
) AS pivot_table
ORDER BY year DESC

--Peak Weekday for accidents
SELECT [Day of Week], count([Day of Week]) AS accidents_bydays
FROM PortfolioProjects..road_accident_dataset
GROUP BY ([Day of Week])
ORDER BY accidents_bydays DESC

--Peak Month for Accidents
SELECT [Month], count([Month]) AS total_accident_asper_month
FROM PortfolioProjects..road_accident_dataset
GROUP BY [Month]
ORDER BY total_accident_asper_month DESC

--Peak Hours for Accidents
SELECT [time of day], COUNT([time of day]) AS total_accident_asper_TOD
FROM PortfolioProjects..road_accident_dataset
GROUP BY [time of day]
ORDER BY total_accident_asper_TOD DESC

--Geospatial Analysis
--Total accidents per country
SELECT Country, COUNT(country) AS total_accident_per_country
FROM PortfolioProjects..road_accident_dataset
GROUP BY Country
ORDER BY total_accident_per_country DESC

--Most Accident Prone Locations (Top 5 countries)
SELECT Top 5 Country, COUNT(Country) AS total_accident_per_country
FROM PortfolioProjects..road_accident_dataset
GROUP BY Country
ORDER BY total_accident_per_country DESC

--Accidents by Weather Conditions
SELECT [weather conditions], COUNT([weather conditions]) AS total_accident_asper_WC
FROM PortfolioProjects..road_accident_dataset
GROUP BY [weather conditions]
ORDER BY total_accident_asper_WC DESC

--Vehicle Involvement Analysis
--Average number of vehicle involved per accident
SELECT ROUND(AVG([Number of Vehicles Involved]),0) AS Average_no_of_vehicle
FROM PortfolioProjects..road_accident_dataset

--Number of Good condition cars before the accident
SELECT COUNT([Vehicle Condition]) AS total_vehicle_count, 
(
SELECT COUNT([Vehicle Condition]) 
FROM PortfolioProjects..road_accident_dataset 
WHERE country = 'Canada'  and [Vehicle Condition] = 'good'
) AS good_condition_count 
FROM PortfolioProjects..road_accident_dataset
WHERE country = 'Canada'

--Number of Poor condition cars before the accident

SELECT COUNT([Vehicle Condition]) AS total_vehicle_count, 
(
SELECT COUNT([Vehicle Condition]) 
FROM PortfolioProjects..road_accident_dataset 
WHERE country = 'Canada'  and [Vehicle Condition] = 'poor'
) AS poor_condition_count
FROM PortfolioProjects..road_accident_dataset
WHERE country = 'Canada'

--Driver Demographics
--Percentage of minor <18 and old drivers 61+ in the list of total drivers
WITH cte (country, total_drivers, young_drivers, old_drivers)
AS
(
SELECT country, COUNT([driver age group]) AS total_divers, 
SUM(CASE WHEN [driver age group] = '<18' THEN 1 ELSE 0 END) AS young_drivers, 
SUM(CASE WHEN [driver age group] = '61+' THEN 1 ELSE 0 END) AS old_drivers
FROM PortfolioProjects..road_accident_dataset
GROUP BY country
)
SELECT * ,
ROUND(((CAST(young_drivers AS FLOAT)/total_drivers)*100),2) AS young_drivers_percentage, 
round(((CAST(old_drivers AS FLOAT)/total_drivers)*100),2) AS old_drivers_percentage
FROM cte
ORDER BY young_drivers_percentage DESC

--Age Group with most accidents
SELECT [driver age group],COUNT([driver age group])
FROM PortfolioProjects..road_accident_dataset
GROUP BY [driver age group]
ORDER BY [driver age group] DESC

--Gender with most accidents
SELECT [driver gender],COUNT([driver gender])
FROM PortfolioProjects..road_accident_dataset
GROUP BY [driver gender]
ORDER BY [driver gender] DESC


--Diagnostic Analysis
--Most common accident cause
SELECT [accident cause], COUNT([accident cause])
FROM PortfolioProjects..road_accident_dataset
GROUP BY [accident cause]

--Major Cause of Accident Fatality
SELECT [accident cause], 
COUNT([accident cause]) AS Accidents ,
SUM([Number of Fatalities]) AS TotalFatalities,
FROM PortfolioProjects..road_accident_dataset
GROUP BY [accident cause]
ORDER BY TotalFatalities DESC

--Time of Day with most severe accidents
SELECT [Time of Day], COUNT([Time of Day]) AS Accidents,
SUM([Number of Fatalities]) AS TotalFatalities
FROM PortfolioProjects..road_accident_dataset
GROUP BY [Time of Day]
ORDER BY TotalFatalities DESC

--Age group most prone to severe accidents
SELECT [Driver Age Group], COUNT([Driver Age Group]) AS Accidents,
SUM([Number of Fatalities]) AS TotalFatalities
FROM PortfolioProjects..road_accident_dataset
GROUP BY [Driver Age Group]
ORDER BY TotalFatalities DESC

--Areas with most accidents (Urban/Rural)
SELECT [Urban/Rural], COUNT([Urban/Rural]) AS Accidents,
SUM([Number of Fatalities]) AS TotalFatalities
FROM PortfolioProjects..road_accident_dataset
GROUP BY [Urban/Rural]
ORDER BY TotalFatalities DESC

--Traffic volume and its relation with accident severity and fatality
SELECT [Accident Severity], MAX([Traffic volume]) AS TrafficVolume, 
COUNT([Number of Fatalities]) AS Fatalities
FROM PortfolioProjects..road_accident_dataset
GROUP BY [Accident Severity]
ORDER BY TrafficVolume DESC
