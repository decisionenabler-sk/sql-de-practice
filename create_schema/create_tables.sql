-- Drop tables if they exist (in reverse order of creation due to foreign keys)
DROP TABLE IF EXISTS fct_customer_sales;
DROP TABLE IF EXISTS dim_product;
DROP TABLE IF EXISTS map_customer_territory;
-- Create customer territory mapping table with unique constraint on cust_id

CREATE TABLE map_customer_territory (
    territory_id VARCHAR(50),
    cust_id VARCHAR(50)
);
-- Create product dimension table
CREATE TABLE dim_product (
    prod_sku_id VARCHAR(50),
    prod_sku_name VARCHAR(50),
    prod_brand VARCHAR(50),
    market_name VARCHAR(100)
);
-- Create customer sales fact table
CREATE TABLE fct_customer_sales (
    cust_id VARCHAR(50),
    prod_sku_id VARCHAR(50),
    order_date DATE,
    order_id VARCHAR(50),
    order_value BIGINT
);