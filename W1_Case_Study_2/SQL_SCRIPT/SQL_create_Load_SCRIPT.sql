show databases;
drop database retaildw;
use retaildw;
show tables;
describe dimcustomer;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customers_cleaned.csv'
INTO TABLE dimcustomer
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(CustomerID, @FirstName, @LastName, Gender, Region, @SSN);

describe DimProduct;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products_cleaned.csv'
INTO TABLE DimProduct
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ProductID, ProductName, Category, @Skip1);

select * from dimcustomer;
select * from Dimproduct;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales_cleaned.csv'
INTO TABLE FactSales
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(SalesID, ProductID, CustomerID, SalesAmount, Quantity, @Timestamp, @Year, @Month, @MonthName);
describe Factsales;

select * from FactSales;

SELECT *
FROM FactSales
WHERE SalesAmount IS NULL;
show tables;


describe dimdate;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/dim_date.csv'
INTO TABLE dimdate
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(DateID, FullDate, @Month, MonthName, Year)
SET Month = @Month;

describe dimdate;
select * from dimdate;
select * from factsales;