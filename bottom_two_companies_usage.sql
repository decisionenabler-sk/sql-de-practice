/*
Write a query to identify all companies (customer_id) whose mobile usage ranks in the bottom two positions. 
Mobile usage is the count of events where client_id = 'mobile'. 
Companies with the same usage count should share the same rank, and all companies in the bottom two ranks should be included. 
Return the customer_id and event count, sorted in ascending order by the number of events.
*/
SELECT 
    customer_id,
    mobile_event_count
FROM (
SELECT 
    customer_id,
    COUNT(IF(client_id = 'mobile',event_id,NULL)) AS mobile_event_count,
    DENSE_RANK() OVER(ORDER BY COUNT(IF(client_id = 'mobile',event_id,NULL))ASC) AS mobile_usage_rank
FROM fact_events 
GROUP BY 1
) AS ranked_mobile_usage
WHERE mobile_usage_rank <= 2
ORDER BY mobile_event_count ASC;
 