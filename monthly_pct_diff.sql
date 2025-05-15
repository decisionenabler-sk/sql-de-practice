/*
Given a table of purchases by date, calculate the month-over-month percentage change in revenue. 
The output should include the year-month date (YYYY-MM) and percentage change, rounded to the 2nd decimal point, and sorted from the beginning of the year to the end of the year.
The percentage change column will be populated from the 2nd month forward and can be calculated as ((this month's revenue - last month's revenue) / last month's revenue)*100.

sf_transactions
id: bigint
created_at:date
value: bigint
purchase_id: bigint

*/

WITH monthly_revenue AS (
    SELECT 
    DATE_FORMAT(created_at, '%Y-%m') AS revenue_year_month,
    SUM(transaction_value) AS total_monthly_revenue
FROM sf_transactions
GROUP BY 1
)
SELECT 
revenue_year_month,
total_monthly_revenue,
ROUND(
        ((total_monthly_revenue - LAG(total_monthly_revenue) OVER (ORDER BY revenue_year_month)) * 100.00/ 
        LAG(total_monthly_revenue) OVER (ORDER BY revenue_year_month) ), 
        2
    ) AS revenue_pct_change
FROM monthly_revenue
ORDER BY 1
;