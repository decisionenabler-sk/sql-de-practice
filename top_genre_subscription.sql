/*
-- Create tables
CREATE TABLE streaming_users (
    user_id INT PRIMARY KEY,
    signup_date DATE,
    country VARCHAR(10),
    subscription_tier VARCHAR(20)
);

CREATE TABLE streaming_content (
    content_id INT PRIMARY KEY,
    title VARCHAR(100),
    genre VARCHAR(50),
    content_type VARCHAR(20),
    duration_minutes INT
);

CREATE TABLE streaming_sessions (
    session_id INT PRIMARY KEY,
    user_id INT REFERENCES streaming_users(user_id),
    content_id INT REFERENCES streaming_content(content_id),
    session_date DATE,
    watch_duration INT,
    completion_rate NUMERIC(4,2)
);

-- Insert sample data into streaming_users
INSERT INTO streaming_users (user_id, signup_date, country, subscription_tier) VALUES
(1, '2024-01-01', 'US', 'premium'),
(2, '2024-01-02', 'UK', 'basic'),
(3, '2024-01-03', 'US', 'premium'),
(4, '2024-01-04', 'IN', 'premium'),
(5, '2024-01-05', 'US', 'basic'),
(6, '2024-01-06', 'UK', 'premium');

-- Insert sample data into streaming_content
INSERT INTO streaming_content (content_id, title, genre, content_type, duration_minutes) VALUES
(501, 'Movie A', 'Action', 'movie', 120),
(502, 'Series B', 'Drama', 'series', 45),
(503, 'Movie C', 'Action', 'movie', 95),
(504, 'Series D', 'Comedy', 'series', 30),
(505, 'Movie E', 'Drama', 'movie', 110);

-- Insert sample data into streaming_sessions
INSERT INTO streaming_sessions (session_id, user_id, content_id, session_date, watch_duration, completion_rate) VALUES
(1001, 1, 501, '2024-01-15', 90, 0.75),
(1002, 1, 502, '2024-01-16', 45, 1.00),
(1003, 2, 501, '2024-01-17', 60, 0.50),
(1004, 3, 503, '2024-01-18', 95, 1.00),
(1005, 4, 504, '2024-01-19', 30, 1.00),
(1006, 5, 505, '2024-01-20', 110, 1.00),
(1007, 6, 502, '2024-01-21', 45, 1.00),
(1008, 6, 504, '2024-01-22', 30, 1.00),
(1009, 1, 503, '2024-01-23', 50, 0.53),
(1010, 3, 505, '2024-01-24', 100, 0.91),
(1011, 4, 501, '2024-01-25', 120, 1.00),
(1012, 2, 504, '2024-01-26', 25, 0.83);

-- streaming_users table
user_id | signup_date | country | subscription_tier
1       | 2024-01-01  | US      | premium
2       | 2024-01-02  | UK      | basic
3       | 2024-01-03  | US      | premium
4       | 2024-01-04  | IN      | premium
5       | 2024-01-05  | US      | basic
6       | 2024-01-06  | UK      | premium

-- streaming_content table
content_id | title      | genre   | content_type | duration_minutes
501        | Movie A    | Action  | movie        | 120
502        | Series B   | Drama   | series       | 45
503        | Movie C    | Action  | movie        | 95
504        | Series D   | Comedy  | series       | 30
505        | Movie E    | Drama   | movie        | 110

-- streaming_sessions table
session_id | user_id | content_id | session_date | watch_duration | completion_rate
1001       | 1       | 501        | 2024-01-15   | 90             | 0.75
1002       | 1       | 502        | 2024-01-16   | 45             | 1.0
1003       | 2       | 501        | 2024-01-17   | 60             | 0.5
1004       | 3       | 503        | 2024-01-18   | 95             | 1.0
1005       | 4       | 504        | 2024-01-19   | 30             | 1.0
1006       | 5       | 505        | 2024-01-20   | 110            | 1.0
1007       | 6       | 502        | 2024-01-21   | 45             | 1.0
1008       | 6       | 504        | 2024-01-22   | 30             | 1.0
1009       | 1       | 503        | 2024-01-23   | 50             | 0.53
1010       | 3       | 505        | 2024-01-24   | 100            | 0.91
1011       | 4       | 501        | 2024-01-25   | 120            | 1.0
1012       | 2       | 504        | 2024-01-26   | 25             | 0.83

Find the top genre by total watch time for each country-subscription tier combination. 
Include the total watch time and number of unique users.
Expected Output:
country | subscription_tier | top_genre | total_watch_time | unique_users
US      | premium          | Action    | 235              | 2
US      | basic            | Drama     | 110              | 1
UK      | basic            | Action    | 60               | 1
UK      | premium          | Drama     | 45               | 1
IN      | premium          | Action    | 120              | 1
*/

WITH streaming_metrics AS (
    SELECT
        u.country,
        u.subscription_tier,
        c.genre,
        COUNT(DISTINCT u.user_id) AS unique_users,
        SUM(watch_duration) AS total_watch_time
    FROM streaming_users u
    JOIN streaming_sessions s
    ON u.user_id = s.user_id
    JOIN streaming_content c
    ON c.content_id = s.content_id
    GROUP BY 1,2,3
) 
, ranked_genre AS (
SELECT 
    country,
    subscription_tier,
    genre,
    total_watch_time,
    unique_users,
    RANK() OVER(
        PARTITION BY country, subscription_tier ORDER BY total_watch_time DESC
    ) as genre_rank
FROM streaming_metrics
)
SELECT     
    country,
    subscription_tier,
    genre as top_genre,
    total_watch_time,
    unique_users 
FROM ranked_genre
WHERE genre_rank = 1
;