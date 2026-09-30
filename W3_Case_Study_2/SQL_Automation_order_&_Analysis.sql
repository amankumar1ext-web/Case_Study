-- Sales analyze -- 
-- Revenue by Product-- 
SELECT
    p.Product_ID,
    SUM(s.Quantity_Sold) AS Total_Quantity_Sold,
    SUM(s.Revenue) AS Total_Revenue
FROM fact_sales s
JOIN dim_product p
    ON s.Product_ID = p.Product_ID
GROUP BY p.Product_ID
ORDER BY Total_Revenue DESC;

-- Revenue by Store-- 
SELECT
    st.Store_ID,
    SUM(s.Quantity_Sold) AS Total_Quantity_Sold,
    SUM(s.Revenue) AS Total_Revenue
FROM fact_sales s
JOIN dim_store st
    ON s.Store_ID = st.Store_ID
GROUP BY st.Store_ID
ORDER BY Total_Revenue DESC;

-- Inventory Analysis-- 
-- Current Inventory Status --

-- Latest Observation--  
WITH latest_inventory AS (
    SELECT
        i.*,
        ROW_NUMBER() OVER (
            PARTITION BY
                Product_ID,
                Store_ID,
                Warehouse_ID
            ORDER BY Last_Updated DESC
        ) AS rn
    FROM fact_inventory i
)

SELECT
    Product_ID,
    Store_ID,
    Warehouse_ID,
    Last_Updated,
    Stock_Level,
    Reorder_Level,
    CASE
        WHEN Stock_Level <= Reorder_Level
            THEN 'REORDER REQUIRED'
        ELSE 'STOCK AVAILABLE'
    END AS Inventory_Status
FROM latest_inventory
WHERE rn = 1
ORDER BY Stock_Level;

-- Identify Products Requiring Reorder-- 
WITH latest_inventory AS (
    SELECT
        i.*,
        ROW_NUMBER() OVER (
            PARTITION BY
                Product_ID,
                Store_ID,
                Warehouse_ID
            ORDER BY Last_Updated DESC
        ) AS rn
    FROM fact_inventory i
)

SELECT
    Product_ID,
    Store_ID,
    Warehouse_ID,
    Stock_Level,
    Reorder_Level,
    (Reorder_Level - Stock_Level) AS Stock_Shortage
FROM latest_inventory
WHERE rn = 1
  AND Stock_Level <= Reorder_Level
ORDER BY Stock_Shortage DESC;

-- Supplier Information for Reordering-- 
WITH latest_inventory AS (
    SELECT
        i.*,
        ROW_NUMBER() OVER (
            PARTITION BY
                Product_ID,
                Store_ID,
                Warehouse_ID
            ORDER BY Last_Updated DESC
        ) AS rn
    FROM fact_inventory i
)

SELECT
    i.Product_ID,
    i.Store_ID,
    i.Warehouse_ID,
    i.Stock_Level,
    i.Reorder_Level,
    sp.Supplier_ID,
    sp.Supplier_Name,
    sp.Lead_Time_Days,
    sp.Order_Frequency
FROM latest_inventory i
JOIN dim_supplier sp
    ON i.Product_ID = sp.Product_ID
WHERE i.rn = 1
  AND i.Stock_Level <= i.Reorder_Level
ORDER BY i.Product_ID;

-- Automatic Reorder Procedure-- 
SELECT Order_ID
FROM fact_purchase_orders
LIMIT 10;

DELIMITER $$

CREATE PROCEDURE auto_reorder(
    IN p_product_id VARCHAR(20),
    IN p_store_id VARCHAR(20),
    IN p_warehouse_id VARCHAR(20)
)

BEGIN

    DECLARE v_stock INT;
    DECLARE v_reorder_level INT;
    DECLARE v_supplier_id VARCHAR(20);
    DECLARE v_quantity INT;
    DECLARE v_order_id VARCHAR(50);

    /* Get latest inventory record */
    SELECT
        Stock_Level,
        Reorder_Level
    INTO
        v_stock,
        v_reorder_level
    FROM fact_inventory
    WHERE Product_ID = p_product_id
      AND Store_ID = p_store_id
      AND Warehouse_ID = p_warehouse_id
    ORDER BY Last_Updated DESC
    LIMIT 1;

    /* Check reorder condition */
    IF v_stock <= v_reorder_level THEN

        /* Find supplier */
        SELECT Supplier_ID
        INTO v_supplier_id
        FROM dim_supplier
        WHERE Product_ID = p_product_id
        LIMIT 1;

        /* Calculate order quantity */
        SET v_quantity = v_reorder_level - v_stock;

        IF v_quantity < 1 THEN
            SET v_quantity = 1;
        END IF;

        /* Generate Order ID */
        SET v_order_id = UUID();

        /* Insert purchase order */
        INSERT INTO fact_purchase_orders (
            Order_ID,
            Product_ID,
            Supplier_ID,
            Order_Date,
            Quantity,
            Arrival_Date
        )
        VALUES (
            v_order_id,
            p_product_id,
            v_supplier_id,
            CURDATE(),
            v_quantity,
            DATE_ADD(
                CURDATE(),
                INTERVAL (
                    SELECT Lead_Time_Days
                    FROM dim_supplier
                    WHERE Supplier_ID = v_supplier_id
                ) DAY
            )
        );

        SELECT
            'ORDER CREATED' AS Status,
            v_order_id AS Order_ID,
            p_product_id AS Product_ID,
            v_supplier_id AS Supplier_ID,
            v_quantity AS Order_Quantity;

    ELSE

        SELECT
            'NO ORDER REQUIRED' AS Status,
            p_product_id AS Product_ID,
            v_stock AS Current_Stock,
            v_reorder_level AS Reorder_Level;

    END IF;

END$$

DELIMITER ;

-- Test the Automatic Order Function-- 
WITH latest_inventory AS (
    SELECT
        i.*,
        ROW_NUMBER() OVER (
            PARTITION BY
                Product_ID,
                Store_ID,
                Warehouse_ID
            ORDER BY Last_Updated DESC
        ) AS rn
    FROM fact_inventory i
)

SELECT
    Product_ID,
    Store_ID,
    Warehouse_ID,
    Stock_Level,
    Reorder_Level
FROM latest_inventory
WHERE rn = 1
  AND Stock_Level <= Reorder_Level
LIMIT 1;

CALL auto_reorder(
    'P001',
    'S101',
    'W001'
);

-- Verify the Generated Order-- 
SELECT
    Order_ID,
    Product_ID,
    Supplier_ID,
    Order_Date,
    Quantity,
    Arrival_Date
FROM fact_purchase_orders
ORDER BY Order_Date DESC
LIMIT 10;


-- Timepaas--
WITH latest_inventory AS (
    SELECT
        i.*,
        ROW_NUMBER() OVER (
            PARTITION BY Product_ID, Store_ID, Warehouse_ID
            ORDER BY Last_Updated DESC
        ) AS rn
    FROM fact_inventory i
)
SELECT
    Product_ID,
    Store_ID,
    Warehouse_ID,
    Stock_Level,
    Reorder_Level
FROM latest_inventory
WHERE rn = 1
  AND Stock_Level <= Reorder_Level
LIMIT 1; 


-- Trigger auto order-- 
CALL auto_reorder(
    'P001',
    'S102',
    'W001'
);
-- Verify-- 
SELECT
    Order_ID,
    Product_ID,
    Supplier_ID,
    Order_Date,
    Quantity,
    Arrival_Date
FROM fact_purchase_orders
WHERE Product_ID = 'P001'
ORDER BY Order_Date DESC
LIMIT 5;