/* 
Identify users who started a session and placed an order on the same day. 
For these users, the total number of orders placed on that day and the total order value for that day.
Your output should include the user id, the session date, the total number of orders, and the total order value for that day.
*/
SELECT  
    s.user_id,
    s.session_date,
    COUNT(o.order_id) AS total_orders,
    SUM(o.order_value) AS total_order_value

FROM sessions s
JOIN order_summary o
ON s.user_id = o.user_id
AND DATE(s.session_date) = DATE(o.order_date)
GROUP BY 1,2
;