ALTER TABLE FactSales
DROP PRIMARY KEY;

ALTER TABLE FactSales
MODIFY SalesID VARCHAR(40);

ALTER TABLE FactSales
ADD PRIMARY KEY (SalesID);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/fact_sales23.csv'
INTO TABLE Sales_Upd
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(SalesID, CustomerID, ProductID, DateID, Quantity, SalesAmount);



DROP TABLE Sales_Upd;

UPDATE FactSales s
JOIN Sales_Upd su ON s.SalesID = su.SalesID
SET s.DateID = su.DateID
WHERE s.DateID IS NULL;
select * from Sales_Upd;

CREATE TABLE Sales_Upd (
    SalesID VARCHAR(40),
    ProductID INT,
    CustomerID VARCHAR(20),
    SalesAmount DECIMAL(10,2),
    Quantity INT,
    DateID INT
);