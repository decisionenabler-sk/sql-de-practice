-- Create customer territory mapping table with unique constraint on cust_id

CREATE TABLE IF NOT EXISTS map_customer_territory (
    territory_id VARCHAR(50),
    cust_id VARCHAR(50)
);
-- Create product dimension table
CREATE TABLE IF NOT EXISTS dim_product (
    prod_sku_id VARCHAR(50),
    prod_sku_name VARCHAR(50),
    prod_brand VARCHAR(50),
    market_name VARCHAR(100)
);
-- Create customer sales fact table
CREATE TABLE IF NOT EXISTS fct_customer_sales (
    cust_id VARCHAR(50),
    prod_sku_id VARCHAR(50),
    order_date DATE,
    order_id VARCHAR(50),
    order_value BIGINT
);

-- Create facebook_web_log table
CREATE TABLE IF NOT EXISTS facebook_web_log (
    user_id INT,
    timestamp DATETIME,
    action VARCHAR(50),
    PRIMARY KEY (user_id, timestamp)
);
-- Create table sf_trasactions

CREATE TABLE IF NOT EXISTS sf_transactions (
    id BIGINT PRIMARY KEY,
    created_at DATE,
    transaction_value BIGINT,
    purchase_id BIGINT
);

-- Create contracts table
CREATE TABLE IF NOT EXISTS contracts (
    customer_id INTEGER,
    num_seats INTEGER,
    yearly_seat_cost INTEGER
);

-- Create customers table
CREATE TABLE IF NOT EXISTS customers (
    customer_id INTEGER,
    name VARCHAR(100),
    employee_count INTEGER CHECK (employee_count BETWEEN 0 AND 100000)
);

CREATE TABLE IF NOT EXISTS fraud_score (
    policy_num VARCHAR(10) PRIMARY KEY,
    state CHAR(2) NOT NULL,
    claim_cost INTEGER NOT NULL,
    fraud_score DECIMAL(3,2) NOT NULL
);
CREATE TABLE IF NOT EXISTS sessions (
    session_id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50),
    session_date DATE
);
CREATE TABLE IF NOT EXISTS order_summary (
    order_id VARCHAR(50) PRIMARY KEY,
    order_date DATE,
    user_id VARCHAR(50) ,
    order_value INTEGER
);
CREATE TABLE IF NOT EXISTS fact_events (
    id VARCHAR(50) PRIMARY KEY,
    time_id DATE,
    user_id VARCHAR(50),
    customer_id VARCHAR(50),
    client_id VARCHAR(50),
    event_type VARCHAR(50),
    event_id INTEGER
);
CREATE TABLE IF NOT EXISTS uber_request_logs (
    request_id BIGINT,
    request_date DATE,
    request_status TEXT,
    distance_to_travel DOUBLE PRECISION,
    monetary_cost DOUBLE PRECISION,
    driver_to_client_distance DOUBLE PRECISION
);
CREATE TABLE IF NOT EXISTS yelp_business (
    business_id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255),
    neighborhood VARCHAR(255),
    address VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(10),
    postal_code VARCHAR(20),
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    stars DOUBLE PRECISION,
    review_count INT,
    is_open INT,
    categories TEXT
);
CREATE TABLE IF NOT EXISTS amazing_purchases (
    user_id INTEGER,
    created_at DATE,
    purchase_amt INTEGER
);