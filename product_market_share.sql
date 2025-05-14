-- Write a query to find the Market Share at the Product Brand level for each Territory, for Time Period Q4-2021. 
-- Market Share is the number of Products of a certain Product Brand brand sold in a territory, divided by the total number of Products sold in this Territory.
-- Output the ID of the Territory, name of the Product Brand and the corresponding Market Share in percentages. 
-- Only include the Product Brands that had at least one sale in a given territory.
WITH territory_products_q4_2021 AS (
    SELECT 
        ct.territory_id,
        p.prod_brand,
        COUNT(cs.prod_sku_id) OVER(PARTITION BY territory_id) as total_products_sold,
        COUNT(cs.prod_sku_id) OVER(PARTITION BY territory_id,  prod_brand) AS total_product_brand_sold
    FROM fct_customer_sales cs
    JOIN map_customer_territory ct
    ON ct.cust_id = cs.cust_id
    JOIN dim_product p
    ON p.prod_sku_id = cs.prod_sku_id
    WHERE YEAR(order_date) = 2021 AND QUARTER(order_date)=4 
)
SELECT DISTINCT
    territory_id,
    prod_brand, 
    ROUND(total_product_brand_sold * 100.00 /total_products_sold,2) AS market_share 
FROM territory_products_q4_2021
WHERE total_product_brand_sold > 0
;