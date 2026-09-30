Show databases;

use inventory_management;

Show tables;

select * from dim_product;
Describe dim_product;

select * from dim_store;
Describe dim_store;

DELETE FROM dim_store
WHERE Store_ID = 'Store_ID';
-- IGNORE 1 LINES;--

Select * From dim_warehouse;
Delete from dim_warehouse
where Warehouse_ID = "Warehouse_ID"; 

select * from fact_inventory limit 10;

SELECT COUNT(*) AS Product_Count
FROM dim_product;

SELECT COUNT(*) AS Store_Count
FROM dim_store;

SELECT COUNT(*) AS Warehouse_Count
FROM dim_warehouse;

SELECT COUNT(*) AS Supplier_Count
FROM dim_supplier;

SELECT COUNT(*) AS Date_Count
FROM dim_date;

SELECT COUNT(*) AS Sales_Rows
FROM fact_sales;

SELECT COUNT(*) AS Inventory_Rows
FROM fact_inventory;

SELECT COUNT(*) AS Purchase_Order_Rows
FROM fact_purchase_orders;

-- Checking Relation Ship -- 
SELECT
    s.Sale_ID,
    p.Product_ID,
    st.Store_ID,
    s.Sale_Date,
    s.Quantity_Sold,
    s.Revenue
FROM fact_sales s
JOIN dim_product p
    ON s.Product_ID = p.Product_ID
JOIN dim_store st
    ON s.Store_ID = st.Store_ID
LIMIT 10; 

SELECT
    i.Product_ID,
    p.Product_ID,
    i.Store_ID,
    i.Warehouse_ID,
    i.Stock_Level,
    i.Reorder_Level
FROM fact_inventory i
JOIN dim_product p
    ON i.Product_ID = p.Product_ID
JOIN dim_store s
    ON i.Store_ID = s.Store_ID
JOIN dim_warehouse w
    ON i.Warehouse_ID = w.Warehouse_ID
LIMIT 10;

SELECT
    i.Product_ID,
    p.Product_ID,
    i.Store_ID,
    i.Warehouse_ID,
    i.Stock_Level,
    i.Reorder_Level
FROM fact_inventory i
JOIN dim_product p
    ON i.Product_ID = p.Product_ID
JOIN dim_store s
    ON i.Store_ID = s.Store_ID
JOIN dim_warehouse w
    ON i.Warehouse_ID = w.Warehouse_ID
LIMIT 10;

