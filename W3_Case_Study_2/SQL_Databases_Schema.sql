CREATE DATABASE inventory_management;

USE inventory_management;

-- Creating Dimensions Tables --  
CREATE TABLE dim_product (
    Product_ID VARCHAR(20) PRIMARY KEY
);

CREATE TABLE dim_store (
    Store_ID VARCHAR(20) PRIMARY KEY
);

CREATE TABLE dim_warehouse (
    Warehouse_ID VARCHAR(20) PRIMARY KEY
);

CREATE TABLE dim_supplier (
    Supplier_ID VARCHAR(20) PRIMARY KEY,
    Supplier_Name VARCHAR(150),
    Product_ID VARCHAR(20),
    Lead_Time_Days INT,
    Order_Frequency VARCHAR(30),

    FOREIGN KEY (Product_ID)
        REFERENCES dim_product(Product_ID)
);

CREATE TABLE dim_date (
    Date DATE PRIMARY KEY,
    Year INT,
    Quarter VARCHAR(5),
    Month_Number INT,
    Month_Name VARCHAR(20),
    Day INT,
    Day_of_Week INT,
    Day_Name VARCHAR(20)
);

-- Creating Facts Tables -- 

CREATE TABLE fact_sales (
    Sale_ID VARCHAR(50) PRIMARY KEY,
    Product_ID VARCHAR(20),
    Store_ID VARCHAR(20),
    Sale_Date DATE,
    Quantity_Sold INT,
    Revenue DECIMAL(12,2),

    FOREIGN KEY (Product_ID)
        REFERENCES dim_product(Product_ID),

    FOREIGN KEY (Store_ID)
        REFERENCES dim_store(Store_ID),

    FOREIGN KEY (Sale_Date)
        REFERENCES dim_date(Date)
);

CREATE TABLE fact_inventory (
    Inventory_ID INT AUTO_INCREMENT PRIMARY KEY,
    Product_ID VARCHAR(20),
    Store_ID VARCHAR(20),
    Warehouse_ID VARCHAR(20),
    Last_Updated DATE,
    Stock_Level INT,
    Reorder_Level INT,

    FOREIGN KEY (Product_ID)
        REFERENCES dim_product(Product_ID),

    FOREIGN KEY (Store_ID)
        REFERENCES dim_store(Store_ID),

    FOREIGN KEY (Warehouse_ID)
        REFERENCES dim_warehouse(Warehouse_ID),

    FOREIGN KEY (Last_Updated)
        REFERENCES dim_date(Date)
);

CREATE TABLE fact_purchase_orders (
    Order_ID VARCHAR(50) PRIMARY KEY,
    Product_ID VARCHAR(20),
    Supplier_ID VARCHAR(20),
    Order_Date DATE,
    Quantity INT,
    Arrival_Date DATE,

    FOREIGN KEY (Product_ID)
        REFERENCES dim_product(Product_ID),

    FOREIGN KEY (Supplier_ID)
        REFERENCES dim_supplier(Supplier_ID),

    FOREIGN KEY (Order_Date)
        REFERENCES dim_date(Date),

    FOREIGN KEY (Arrival_Date)
        REFERENCES dim_date(Date)
);

Describe dim_product;

