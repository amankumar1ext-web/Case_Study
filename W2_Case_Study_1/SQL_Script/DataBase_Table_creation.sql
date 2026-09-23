CREATE DATABASE employee_attrition_db;

USE employee_attrition_db;
SHOW DATABASES;

USE employee_attrition_db;

CREATE TABLE employee (
    Employee_ID INT PRIMARY KEY,
    Age INT,
    First_Name VARCHAR(100),
    Last_Name VARCHAR(100),
    Gender_Detailed VARCHAR(50),
    Gender_Group VARCHAR(50),
    Department VARCHAR(100),
    Job_Role VARCHAR(100),
    Education_Level VARCHAR(100),
    Marital_Status VARCHAR(50),
    Job_Tenure INT,
    Distance_From_Home INT
);

DESCRIBE employee;

CREATE TABLE employee_performance (
    Employee_ID INT PRIMARY KEY,
    Performance_Rating INT,
    Last_Promotion_Year INT,
    Training_Hours INT,
    Work_Life_Balance INT,
    Job_Satisfaction INT,
    
    CONSTRAINT fk_performance_employee
        FOREIGN KEY (Employee_ID)
        REFERENCES employee(Employee_ID)
);

DESCRIBE employee_performance;

CREATE TABLE employee_attrition (
    Attrition_ID INT AUTO_INCREMENT PRIMARY KEY,
    Employee_ID INT,
    Attrition BOOLEAN,
    Exit_Interview_Score INT,

    CONSTRAINT fk_attrition_employee
        FOREIGN KEY (Employee_ID)
        REFERENCES employee(Employee_ID)
);
describe employee_attrition;

SELECT COUNT(*) AS Employee_Count
FROM employee;

SELECT COUNT(*) AS Performance_Count
FROM employee_performance;

SELECT COUNT(*) AS Attrition_Count
FROM employee_attrition;

select * from employee_attrition;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/attrition_cleaned.csv'
INTO TABLE employee_attrition
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Employee_ID, @attrition, Exit_Interview_Score)
SET Attrition = CASE WHEN LOWER(@attrition) = 'true' THEN 1 ELSE 0 END;
SHOW VARIABLES LIKE 'secure_file_priv';