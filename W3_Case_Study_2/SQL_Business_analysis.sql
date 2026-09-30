show databases;

use inventory_management;

-- Analysis-- 
-- Product Performance-- 
SELECT
    Product_ID,
    COUNT(*) AS Number_of_Sales,
    SUM(Quantity_Sold) AS Total_Quantity_Sold,
    SUM(Revenue) AS Total_Revenue,
    AVG(Revenue) AS Average_Revenue
FROM fact_sales
GROUP BY Product_ID
ORDER BY Total_Revenue DESC;

-- Store Performance-- 
SELECT
    Store_ID,
    COUNT(*) AS Number_of_Sales,
    SUM(Quantity_Sold) AS Total_Quantity_Sold,
    SUM(Revenue) AS Total_Revenue
FROM fact_sales
GROUP BY Store_ID
ORDER BY Total_Revenue DESC;

-- Supplier Analysis-- 
SELECT
    s.Supplier_ID,
    s.Supplier_Name,
    s.Lead_Time_Days,
    s.Order_Frequency,
    COUNT(po.Order_ID) AS Total_Orders,
    COALESCE(SUM(po.Quantity), 0) AS Total_Quantity_Ordered
FROM dim_supplier s
LEFT JOIN fact_purchase_orders po
    ON s.Supplier_ID = po.Supplier_ID
GROUP BY
    s.Supplier_ID,
    s.Supplier_Name,
    s.Lead_Time_Days,
    s.Order_Frequency
ORDER BY Total_Orders DESC;

-- Purchase Order Delivery Analysis-- 
SELECT
    Order_ID,
    Product_ID,
    Supplier_ID,
    Order_Date,
    Arrival_Date,
    DATEDIFF(Arrival_Date, Order_Date) AS Delivery_Days,
    Quantity
FROM fact_purchase_orders
ORDER BY Order_Date DESC;