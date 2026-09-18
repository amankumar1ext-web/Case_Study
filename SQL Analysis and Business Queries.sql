use retaildw;
show tables;

-- Total Revenue--  
SELECT SUM(SalesAmount) AS TotalRevenue
FROM FactSales;

-- Total Orders-- 
SELECT COUNT(*) AS TotalOrders
FROM FactSales;

-- Revenue by Region-- 
SELECT
    c.Region,
    SUM(f.SalesAmount) AS Revenue
FROM FactSales f
JOIN DimCustomer c
ON f.CustomerID = c.CustomerID
GROUP BY c.Region
ORDER BY Revenue DESC;

-- Sales by Product Category-- 
SELECT
    p.Category,
    SUM(f.SalesAmount) AS Revenue
FROM FactSales f
JOIN DimProduct p
ON f.ProductID = p.ProductID
GROUP BY p.Category;

-- Top 10 Products-- 
SELECT
    p.ProductName,
    SUM(f.SalesAmount) AS Revenue
FROM FactSales f
JOIN DimProduct p
ON f.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY Revenue DESC
LIMIT 10;

-- Top Customers-- 
SELECT
    c.CustomerID,
    SUM(f.SalesAmount) AS Revenue
FROM FactSales f
JOIN DimCustomer c
ON f.CustomerID = c.CustomerID
GROUP BY c.CustomerID
ORDER BY Revenue DESC
LIMIT 10;

-- Monthly Sales Trend-- 
SELECT
    d.Year,
    d.MonthName,
    SUM(f.SalesAmount) AS Revenue
FROM FactSales f
JOIN DimDate d
ON f.DateID = d.DateID
GROUP BY d.Year, d.Month, d.MonthName
ORDER BY d.Year, d.Month;

-- Average Order Value-- 
SELECT
    AVG(SalesAmount) AS AverageOrderValue
FROM FactSales;