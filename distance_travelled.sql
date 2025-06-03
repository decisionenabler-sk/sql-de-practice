/*
You’re given a dataset of uber rides with the traveling distance (‘distance_to_travel’) and cost (‘monetary_cost’) for each ride. 
First, find the difference between the distance-per-dollar for each date and the average distance-per-dollar for that year-month. 
Distance-per-dollar is defined as the distance traveled divided by the cost of the ride. 
Use the calculated difference on each date to calculate absolute average difference in distance-per-dollar metric on monthly basis (year-month).

The output should include the year-month (YYYY-MM) and the absolute average difference in distance-per-dollar (Absolute value to be rounded to the 2nd decimal).
You should also count both success and failed request_status as the distance and cost values are populated for all ride requests. 
Also, assume that all dates are unique in the dataset. Order your results by earliest request date first.
*/
WITH average_distance AS (
SELECT 
    DATE_FORMAT(request_date, '%Y-%m') AS request_year_month,
    -- Distance-per-dollar = the distance traveled / cost of the ride.
    AVG(distance_to_travel/ monetary_cost) AS monthly_avg_distance_per_dollar
FROM uber_request_logs
GROUP BY 1
)
SELECT
    DATE_FORMAT(request_date, '%Y-%m') AS request_year_month,
    ROUND(AVG(abs_distance_per_dollar),2) AS avg_abs_distance_per_dollar
FROM (
SELECT 
    rl.request_date,
    ad.monthly_avg_distance_per_dollar, 
    ABS((rl.distance_to_travel / rl.monetary_cost) - monthly_avg_distance_per_dollar) AS abs_distance_per_dollar
FROM uber_request_logs rl
JOIN average_distance ad
ON DATE_FORMAT(rl.request_date, '%Y-%m') = request_year_month
) t
GROUP BY 1 ORDER BY 1
;