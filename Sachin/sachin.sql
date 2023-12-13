
-- Data Pipeline Architecture
-- Refer architecture.txt



CREATE TABLE orders (
    order_id VARCHAR PRIMARY KEY,
    order_date DATE, 
    order_status VARCHAR,
    payment_method VARCHAR,
    dc_id INT,
    total_price DECIMAL(10,2),
    is_member BOOLEAN 
);

CREATE TABLE distribution_center (
    dc_id INT PRIMARY KEY, 
    dc_name VARCHAR,
    manager_id INT, 
    shipping_fee DECIMAL(10,2)
);

CREATE TABLE payment_processing (
   payment_txn_id VARCHAR PRIMARY KEY,
   order_id VARCHAR,
   payment_status VARCHAR  -- success/fail
);

CREATE TABLE business_entity (
   entity_id INT PRIMARY KEY,
   is_franchise BOOLEAN  
);

CREATE TABLE payment_fees (
    method VARCHAR PRIMARY KEY,
    fee DECIMAL(5,2)
);


-----


-- Number of orders placed per day
SELECT order_date, COUNT(*) AS orders_per_day
FROM orders
GROUP BY order_date;

-- Number of orders fulfilled per day
SELECT order_date, 
       COUNT(*)  AS orders_fulfilled
FROM orders
wHERE  order_status='DELIVERED'
GROUP BY order_date;

-- Fulfilment rate per DC
SELECT 
    dc.dc_name,
    SUM(CASE WHEN order_status='DELIVERED' THEN 1 ELSE 0 END) / COUNT(*) as fulfilment_rate
FROM orders
INNER JOIN distribution_center dc 
ON orders.dc_id = dc.dc_id
GROUP BY dc.dc_name;

-- Take home value per order 
SELECT 
    order_id, 
    total_price - COALESCE(shipping_fee, 0) - COALESCE(payment_fee, 0) AS take_home
FROM
    orders
    LEFT JOIN distribution_center ON orders.dc_id = distribution_center.dc_id
    LEFT JOIN payment_fees ON orders.payment_method = payment_fees.method;
    
-- Orders per warehouse manager
SELECT
    dc.manager_id,
    COUNT(orders.order_id) AS total_orders
FROM
    orders
    INNER JOIN distribution_center dc ON orders.dc_id = dc.dc_id
GROUP BY 
    dc.manager_id;

    
-- Number orders per payment method
SELECT 
    payment_method,
    COUNT(*) AS num_orders
FROM orders
GROUP BY payment_method;

-- Payment failure rate
SELECT  
    COUNT(CASE WHEN payment_status='fail' THEN 1 ELSE NULL END) / COUNT(*) AS failure_rate
FROM payment_processing;

-- Orders by franchise vs non-franchise
SELECT
    be.is_franchise,
    COUNT(orders.order_id) AS order_count
FROM orders
JOIN business_entity be ON orders.entity_id = be.entity_id
GROUP BY be.is_franchise;