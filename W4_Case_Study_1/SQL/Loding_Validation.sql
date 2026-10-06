select database();

SELECT COUNT(*) AS RowCount
FROM DimSalesTerritory;

SELECT *
FROM DimSalesTerritory
ORDER BY SalesTerritoryKey;

SELECT
    COUNT(*) AS TotalRows,
    COUNT(DISTINCT SalesTerritoryKey) AS UniqueKeys,
    SUM(SalesTerritoryKey IS NULL) AS NullKeys
FROM DimSalesTerritory;

SELECT
    COUNT(*) AS TotalRows,
    COUNT(DISTINCT GeographyKey) AS UniqueKeys,
    SUM(GeographyKey IS NULL) AS NullKeys
FROM DimGeography;

SELECT COUNT(*) AS InvalidTerritoryKeys
FROM DimGeography g
LEFT JOIN DimSalesTerritory t
    ON g.SalesTerritoryKey = t.SalesTerritoryKey
WHERE g.SalesTerritoryKey IS NOT NULL
  AND t.SalesTerritoryKey IS NULL;
  
SELECT *
FROM DimGeography
LIMIT 10;

select count(*) from dimemployee;
select * from dimemployee;
SELECT
    EmployeeKey,
    EmployeeName,
    Title,
    ParentEmployeeKey
FROM DimEmployee
WHERE ParentEmployeeKey IS NULL;

SELECT COUNT(*) AS InvalidParentEmployeeKeys
FROM DimEmployee e
LEFT JOIN DimEmployee p
    ON e.ParentEmployeeKey = p.EmployeeKey
WHERE e.ParentEmployeeKey IS NOT NULL
  AND p.EmployeeKey IS NULL;

-- ====================== -- 
use adventureworks_analytics;

select count(*) from factinternetsales;
select count(*) from factresellersales;


-- Validation -- 

SELECT 'DimCustomer' AS TableName, COUNT(*) AS RowCount FROM DimCustomer
UNION ALL
SELECT 'DimEmployee', COUNT(*) FROM DimEmployee
UNION ALL
SELECT 'DimGeography', COUNT(*) FROM DimGeography
UNION ALL
SELECT 'DimProduct', COUNT(*) FROM DimProduct
UNION ALL
SELECT 'DimReseller', COUNT(*) FROM DimReseller
UNION ALL
SELECT 'DimSalesTerritory', COUNT(*) FROM DimSalesTerritory
UNION ALL
SELECT 'FactInternetSales', COUNT(*) FROM FactInternetSales
UNION ALL
SELECT 'FactResellerSales', COUNT(*) FROM FactResellerSales;

-- Validate Primary Keys-- 
USE AdventureWorks_Analytics;

SELECT 
    'DimCustomer' AS TableName,
    COUNT(*) AS TotalRows,
    COUNT(DISTINCT CustomerKey) AS UniqueKeys,
    SUM(CustomerKey IS NULL) AS NullKeys
FROM DimCustomer

UNION ALL

SELECT 
    'DimEmployee',
    COUNT(*),
    COUNT(DISTINCT EmployeeKey),
    SUM(EmployeeKey IS NULL)
FROM DimEmployee

UNION ALL

SELECT 
    'DimGeography',
    COUNT(*),
    COUNT(DISTINCT GeographyKey),
    SUM(GeographyKey IS NULL)
FROM DimGeography

UNION ALL

SELECT 
    'DimProduct',
    COUNT(*),
    COUNT(DISTINCT ProductKey),
    SUM(ProductKey IS NULL)
FROM DimProduct

UNION ALL

SELECT 
    'DimReseller',
    COUNT(*),
    COUNT(DISTINCT ResellerKey),
    SUM(ResellerKey IS NULL)
FROM DimReseller

UNION ALL

SELECT 
    'DimSalesTerritory',
    COUNT(*),
    COUNT(DISTINCT SalesTerritoryKey),
    SUM(SalesTerritoryKey IS NULL)
FROM DimSalesTerritory;

--  Validate fact transection key-- 
SELECT 
    'FactInternetSales' AS TableName,
    COUNT(*) AS TotalRows,
    COUNT(DISTINCT CONCAT(SalesOrderNumber, '-', SalesOrderLineNumber)) AS UniqueTransactionLines
FROM FactInternetSales

UNION ALL

SELECT 
    'FactResellerSales',
    COUNT(*),
    COUNT(DISTINCT CONCAT(SalesOrderNumber, '-', SalesOrderLineNumber))
FROM FactResellerSales;

USE AdventureWorks_Analytics;

SELECT 
    'InternetSales → Customer' AS Relationship,
    COUNT(*) AS InvalidKeys
FROM FactInternetSales f
LEFT JOIN DimCustomer d 
    ON f.CustomerKey = d.CustomerKey
WHERE d.CustomerKey IS NULL

UNION ALL

SELECT 
    'InternetSales → Product',
    COUNT(*)
FROM FactInternetSales f
LEFT JOIN DimProduct d 
    ON f.ProductKey = d.ProductKey
WHERE d.ProductKey IS NULL

UNION ALL

SELECT 
    'InternetSales → Territory',
    COUNT(*)
FROM FactInternetSales f
LEFT JOIN DimSalesTerritory d 
    ON f.SalesTerritoryKey = d.SalesTerritoryKey
WHERE d.SalesTerritoryKey IS NULL

UNION ALL

SELECT 
    'ResellerSales → Reseller',
    COUNT(*)
FROM FactResellerSales f
LEFT JOIN DimReseller d 
    ON f.ResellerKey = d.ResellerKey
WHERE d.ResellerKey IS NULL

UNION ALL

SELECT 
    'ResellerSales → Employee',
    COUNT(*)
FROM FactResellerSales f
LEFT JOIN DimEmployee d 
    ON f.EmployeeKey = d.EmployeeKey
WHERE d.EmployeeKey IS NULL

UNION ALL

SELECT 
    'ResellerSales → Product',
    COUNT(*)
FROM FactResellerSales f
LEFT JOIN DimProduct d 
    ON f.ProductKey = d.ProductKey
WHERE d.ProductKey IS NULL

UNION ALL

SELECT 
    'ResellerSales → Territory',
    COUNT(*)
FROM FactResellerSales f
LEFT JOIN DimSalesTerritory d 
    ON f.SalesTerritoryKey = d.SalesTerritoryKey
WHERE d.SalesTerritoryKey IS NULL;

-- Employee Hierarchy --
SELECT 
    e.EmployeeKey,
    e.EmployeeName,
    e.Title,
    e.ParentEmployeeKey
FROM DimEmployee e
WHERE e.ParentEmployeeKey IS NULL; 

SELECT 
    COUNT(*) AS InvalidParentEmployeeKeys
FROM DimEmployee e
LEFT JOIN DimEmployee p
    ON e.ParentEmployeeKey = p.EmployeeKey
WHERE e.ParentEmployeeKey IS NOT NULL
  AND p.EmployeeKey IS NULL;