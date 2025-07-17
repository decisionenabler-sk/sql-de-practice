/*
CREATE TABLE daily_metrics (
    date DATE,
    user_id INT,
    content_id INT,
    watch_time_minutes INT
);

INSERT INTO daily_metrics (date, user_id, content_id, watch_time_minutes) VALUES
('2024-01-01', 1, 501, 30),
('2024-01-01', 1, 502, 45),
('2024-01-02', 1, 501, 60),
('2024-01-02', 2, 501, 20),
('2024-01-03', 1, 503, 40),
('2024-01-03', 2, 502, 55);

-- daily_metrics table
date       | user_id | content_id | watch_time_minutes
2024-01-01 | 1       | 501        | 30
2024-01-01 | 1       | 502        | 45
2024-01-02 | 1       | 501        | 60
2024-01-02 | 2       | 501        | 20
2024-01-03 | 1       | 503        | 40
2024-01-03 | 2       | 502        | 55
For each user, calculate their daily total watch time and show the 3-day moving average. Also include the percentage change from the previous day.
Expected Output:
user_id | date       | daily_total | moving_avg_3day | pct_change_from_prev
1       | 2024-01-01 | 75          | 75              | null
1       | 2024-01-02 | 60          | 67.5            | -20.0
1       | 2024-01-03 | 40          | 58.33           | -33.33
2       | 2024-01-02 | 20          | 20              | null
2       | 2024-01-03 | 55          | 37.5            | 175.0
*/
WITH daily_watch_time AS (
    SELECT
        user_id,
        date,
        SUM(watch_time_minutes) AS daily_total
    FROM daily_metrics
    GROUP BY 1,2
)
SELECT
    user_id,
    date,
    daily_total,
    ROUND(AVG(daily_total) OVER(
        PARTITION BY user_id
        ORDER BY date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ),2) AS moving_avg_3day,
     ROUND(
        100.0 * (daily_total - LAG(daily_total) OVER (PARTITION BY user_id ORDER BY date)) 
        / NULLIF(LAG(daily_total) OVER (PARTITION BY user_id ORDER BY date), 0), 2
    ) AS pct_change_from_prev
FROM daily_watch_time
