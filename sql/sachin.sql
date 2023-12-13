
-- Data Pipeline Architecture


-- •	Ingestion: Stream from kafka into data lake (GCS,S3,BLOB) using data flow or data proc (GCP) 
-- •	Data Pipeline: Use dataflow or dataproc (GCP) for building data pipelines, data transformation
    -- o	Parse the Json format 
    -- o	Map the columns
    -- o	Join with PostgreSQL
-- •	Data Warehouse
    -- o	Store the data in Bigquery
    -- o	Build aggregated tables from the raw data.


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