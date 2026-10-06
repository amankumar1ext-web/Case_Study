CREATE DATABASE AdventureWorks_Analytics;

USE AdventureWorks_Analytics;

show databases;

-- Creating Dimension Tables-- 
-- DimSalesTerritory-- 
CREATE TABLE DimSalesTerritory (
    SalesTerritoryKey INT PRIMARY KEY,
    SalesTerritoryRegion VARCHAR(100),
    SalesTerritoryCountry VARCHAR(100),
    SalesTerritoryGroup VARCHAR(100)
);

-- DimGeography-- 
CREATE TABLE DimGeography (
    GeographyKey INT PRIMARY KEY,
    City VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100),
    PostalCode VARCHAR(20),
    SalesTerritoryKey INT,
    
    CONSTRAINT fk_geography_territory
        FOREIGN KEY (SalesTerritoryKey)
        REFERENCES DimSalesTerritory(SalesTerritoryKey)
);

-- DimProduct-- 
CREATE TABLE DimProduct (
    ProductKey INT PRIMARY KEY,
    ProductSubcategoryKey INT,
    Product VARCHAR(255),
    Color VARCHAR(100),
    Model VARCHAR(255),
    Subcategory VARCHAR(100),
    Category VARCHAR(100)
);

-- DimCustomer-- 
CREATE TABLE DimCustomer (
    CustomerKey INT PRIMARY KEY,
    GeographyKey INT,
    CustomerName VARCHAR(255),
    BirthDate DATE,
    MaritalStatus VARCHAR(10),
    Gender VARCHAR(10),
    EmailAddress VARCHAR(255),
    YearlyIncome DECIMAL(15,2),
    Education VARCHAR(100),
    Occupation VARCHAR(100),
    HouseOwnerFlag TINYINT,
    Address VARCHAR(500),
    FirstPurchaseDate DATE,

    CONSTRAINT fk_customer_geography
        FOREIGN KEY (GeographyKey)
        REFERENCES DimGeography(GeographyKey)
);

-- DimReseller-- 
CREATE TABLE DimReseller (
    ResellerKey INT PRIMARY KEY,
    GeographyKey INT,
    BusinessType VARCHAR(100),
    ResellerName VARCHAR(255),

    CONSTRAINT fk_reseller_geography
        FOREIGN KEY (GeographyKey)
        REFERENCES DimGeography(GeographyKey)
);

-- DimEmployee-- 
CREATE TABLE DimEmployee (
    EmployeeKey INT PRIMARY KEY,
    ParentEmployeeKey INT NULL,
    SalesTerritoryKey INT,
    EmployeeName VARCHAR(255),
    Title VARCHAR(255),
    EmailAddress VARCHAR(255),
    DepartmentName VARCHAR(100),
    HireDate DATE,
    BirthDate DATE,

    CONSTRAINT fk_employee_parent
        FOREIGN KEY (ParentEmployeeKey)
        REFERENCES DimEmployee(EmployeeKey),

    CONSTRAINT fk_employee_territory
        FOREIGN KEY (SalesTerritoryKey)
        REFERENCES DimSalesTerritory(SalesTerritoryKey)
);

SHOW TABLES;

DESCRIBE DimCustomer;
DESCRIBE DimEmployee;
DESCRIBE DimGeography;
DESCRIBE DimProduct;
DESCRIBE DimReseller;
DESCRIBE DimSalesTerritory;

-- Fact TAble Creation-- 
-- FactInternetSales-- 
CREATE TABLE FactInternetSales (
    ProductKey INT NOT NULL,
    CustomerKey INT NOT NULL,
    SalesTerritoryKey INT NOT NULL,

    SalesOrderNumber VARCHAR(50) NOT NULL,
    SalesOrderLineNumber INT NOT NULL,

    DiscountAmount DECIMAL(15,4),
    TotalProductCost DECIMAL(15,4),
    SalesAmount DECIMAL(15,4),
    Freight DECIMAL(15,4),

    CarrierTrackingNumber VARCHAR(100),

    OrderDate DATE,
    DueDate DATE,
    ShipDate DATE,

    PRIMARY KEY (SalesOrderNumber, SalesOrderLineNumber),

    CONSTRAINT fk_internet_product
        FOREIGN KEY (ProductKey)
        REFERENCES DimProduct(ProductKey),

    CONSTRAINT fk_internet_customer
        FOREIGN KEY (CustomerKey)
        REFERENCES DimCustomer(CustomerKey),

    CONSTRAINT fk_internet_territory
        FOREIGN KEY (SalesTerritoryKey)
        REFERENCES DimSalesTerritory(SalesTerritoryKey)
);

-- FactResellerSales-- 
CREATE TABLE FactResellerSales (
    ProductKey INT NOT NULL,
    ResellerKey INT NOT NULL,
    EmployeeKey INT NOT NULL,
    SalesTerritoryKey INT NOT NULL,

    SalesOrderNumber VARCHAR(50) NOT NULL,
    SalesOrderLineNumber INT NOT NULL,

    DiscountAmount DECIMAL(15,4),
    TotalProductCost DECIMAL(15,4),
    SalesAmount DECIMAL(15,4),
    Freight DECIMAL(15,4),

    CarrierTrackingNumber VARCHAR(100),

    OrderDate DATE,
    DueDate DATE,
    ShipDate DATE,

    PRIMARY KEY (SalesOrderNumber, SalesOrderLineNumber),

    CONSTRAINT fk_reseller_product
        FOREIGN KEY (ProductKey)
        REFERENCES DimProduct(ProductKey),

    CONSTRAINT fk_reseller_reseller
        FOREIGN KEY (ResellerKey)
        REFERENCES DimReseller(ResellerKey),

    CONSTRAINT fk_reseller_employee
        FOREIGN KEY (EmployeeKey)
        REFERENCES DimEmployee(EmployeeKey),

    CONSTRAINT fk_reseller_territory
        FOREIGN KEY (SalesTerritoryKey)
        REFERENCES DimSalesTerritory(SalesTerritoryKey)
);

SHOW CREATE TABLE FactInternetSales;
SHOW CREATE TABLE FactResellerSales;