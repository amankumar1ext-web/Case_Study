CREATE DATABASE smart_city_traffic;
USE smart_city_traffic;

CREATE TABLE sensor_data (
    Sensor_ID VARCHAR(50) PRIMARY KEY,
    Location VARCHAR(100),
    Date_Time DATETIME,
    Vehicle_Count INT,
    Average_Speed INT,
    Congestion_Level VARCHAR(50)
);

CREATE TABLE accident_data (
    Accident_ID VARCHAR(50) PRIMARY KEY,
    Date_Time DATETIME,
    Location VARCHAR(100),
    Weather_Condition VARCHAR(50),
    Road_Condition VARCHAR(50),
    Vehicle_Type VARCHAR(50),
    Accident_Severity VARCHAR(50),
    Number_of_Vehicles INT,
    Casualties INT,
    Traffic_Density VARCHAR(50)
);

SHOW TABLES;

select * from accident_data LIMIT 50;
select * from sensor_data LIMIT 50;

-- Traffic Analysis by Location -- 
USE smart_city_traffic;

SELECT
    Location,
    SUM(Vehicle_Count) AS Total_Vehicles,
    ROUND(AVG(Average_Speed), 2) AS Average_Speed
FROM sensor_data
GROUP BY Location
ORDER BY Total_Vehicles DESC; 

 -- Accident Severity Analysis --  
SELECT
    Location,
    COUNT(*) AS Accident_Count,
    SUM(Casualties) AS Total_Casualties
FROM accident_data
GROUP BY Location
ORDER BY Accident_Count DESC;


-- Weather Condition Analysis--  
SELECT
    Weather_Condition,
    COUNT(*) AS Accident_Count,
    SUM(Casualties) AS Total_Casualties
FROM accident_data
GROUP BY Weather_Condition
ORDER BY Accident_Count DESC;

-- Road Condition Analysis -- 
SELECT
    Road_Condition,
    COUNT(*) AS Accident_Count,
    SUM(Casualties) AS Total_Casualties
FROM accident_data
GROUP BY Road_Condition
ORDER BY Accident_Count DESC;

-- Traffic Density Analysis--  
SELECT
    Traffic_Density,
    COUNT(*) AS Accident_Count,
    SUM(Casualties) AS Total_Casualties
FROM accident_data
GROUP BY Traffic_Density
ORDER BY Accident_Count DESC;