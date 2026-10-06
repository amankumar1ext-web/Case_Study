
-- Annual Sales Performance-- 
USE AdventureWorks_Analytics;

SELECT
    YEAR(OrderDate) AS SalesYear,
    ROUND(SUM(InternetSales), 2) AS InternetSales,
    ROUND(SUM(ResellerSales), 2) AS ResellerSales,
    ROUND(SUM(InternetSales) + SUM(ResellerSales), 2) AS TotalSales
FROM
(
    SELECT
        OrderDate,
        SalesAmount AS InternetSales,
        0 AS ResellerSales
    FROM FactInternetSales

    UNION ALL

    SELECT
        OrderDate,
        0 AS InternetSales,
        SalesAmount AS ResellerSales
    FROM FactResellerSales
) s
GROUP BY YEAR(OrderDate)
ORDER BY SalesYear;

-- Sales by Product Category-- 
SELECT
    p.Category,
    ROUND(SUM(f.SalesAmount), 2) AS TotalSales,
    COUNT(DISTINCT f.ProductKey) AS ProductsSold,
    COUNT(*) AS SalesLines
FROM FactInternetSales f
JOIN DimProduct p
    ON f.ProductKey = p.ProductKey
GROUP BY p.Category
ORDER BY TotalSales DESC;

-- Sales by Territory-- 
SELECT
    t.SalesTerritoryRegion,
    t.SalesTerritoryCountry,
    ROUND(SUM(f.SalesAmount), 2) AS TotalSales,
    COUNT(*) AS SalesLines
FROM FactInternetSales f
JOIN DimSalesTerritory t
    ON f.SalesTerritoryKey = t.SalesTerritoryKey
GROUP BY
    t.SalesTerritoryRegion,
    t.SalesTerritoryCountry
ORDER BY TotalSales DESC;

-- Top 10 Products-- 
SELECT
    p.Product,
    p.Category,
    p.Subcategory,
    ROUND(SUM(f.SalesAmount), 2) AS TotalSales,
    COUNT(*) AS SalesLines
FROM FactInternetSales f
JOIN DimProduct p
    ON f.ProductKey = p.ProductKey
GROUP BY
    p.ProductKey,
    p.Product,
    p.Category,
    p.Subcategory
ORDER BY TotalSales DESC
LIMIT 10;