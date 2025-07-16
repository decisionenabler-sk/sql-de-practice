/*
Given Tables:
content table
content_id | title           | genre  | release_date | duration_minutes
501        | Stranger Things | Drama  | 2024-01-01   | 60
502        | The Crown      | Drama  | 2024-01-05   | 55
503        | Squid Game     | Thriller| 2024-01-10   | 50

content_session table
session_id | user_id | content_id | session_date | watch_duration_minutes | completed
1001       | 1       | 501        | 2024-01-15   | 45                    | false
1002       | 2       | 501        | 2024-01-16   | 60                    | true
1003       | 1       | 502        | 2024-01-17   | 30                    | false
1004       | 3       | 503        | 2024-01-18   | 50                    | true
Question:
Rank content by engagement score within each genre. Engagement score = (completion_rate * 0.6) + (avg_watch_percentage * 0.4). 
Show title, genre, engagement_score, and rank.
Expected Output:
title	genre	engagement_score	rank_in_genre
Stranger Things	Drama	0.65	1
Bridgerton	Drama	0.60	2
The Crown	Drama	0.43	3
Squid Game	Thriller	0.69	1
Dark	Thriller	0.68	2


-- Create tables
CREATE TABLE IF NOT EXISTS content (
    content_id INT PRIMARY KEY,
    title VARCHAR(100),
    genre VARCHAR(50),
    release_date DATE,
    duration_minutes INT
);

CREATE TABLE IF NOT EXISTS content_session (
    session_id INT PRIMARY KEY,
    user_id INT,
    content_id INT REFERENCES content(content_id),
    session_date DATE,
    watch_duration_minutes INT,
    completed BOOLEAN
);

-- Insert sample data into content
INSERT INTO content (content_id, title, genre, release_date, duration_minutes) VALUES
(501, 'Stranger Things', 'Drama', '2024-01-01', 60),
(502, 'The Crown', 'Drama', '2024-01-05', 55),
(503, 'Squid Game', 'Thriller', '2024-01-10', 50),
(504, 'Dark', 'Thriller', '2024-02-01', 45),
(505, 'Bridgerton', 'Drama', '2024-02-10', 50);

-- Insert sample data into content_session
INSERT INTO content_session (session_id, user_id, content_id, session_date, watch_duration_minutes, completed) VALUES
(1001, 1, 501, '2024-01-15', 45, FALSE),
(1002, 2, 501, '2024-01-16', 60, TRUE),
(1003, 1, 502, '2024-01-17', 30, FALSE),
(1004, 3, 503, '2024-01-18', 50, TRUE),
(1005, 2, 504, '2024-02-15', 45, TRUE),
(1006, 4, 504, '2024-02-16', 40, FALSE),
(1007, 3, 505, '2024-02-20', 50, TRUE),
(1008, 1, 505, '2024-02-21', 25, FALSE),
(1009, 5, 502, '2024-02-22', 55, TRUE),
(1010, 5, 503, '2024-02-23', 25, FALSE),
(1011, 3, 503, '2024-02-26', 35, TRUE),
(1003, 2, 502, '2024-02-26', 10, FALSE);
*/
-- Assuming the grain is content_id, we need to calculate 2 KPIs completion_rate = completed_sessions / total_sessions, avg_watch_pct = avg_watch_duration_minutes / total_duration_minutes
WITH session_metrics AS (
    SELECT 
        content_id,
        COUNT(CASE WHEN completed = TRUE THEN 1 ELSE NULL END) * 1.00 / COUNT(1) AS completion_rate
    FROM content_session
    GROUP BY 1
)
, watch_metrics AS (
    SELECT
        cs.content_id,
        AVG(cs.watch_duration_minutes * 1.00 / c.duration_minutes) AS avg_watch_pct
    FROM content_session cs
    JOIN content c
    ON c.content_id = cs.content_id
    GROUP BY 1
)
SELECT
    c.title,
    c.genre,
    ROUND(sm.completion_rate* 0.6 + wm.avg_watch_pct * 0.4, 2) AS engagement_score,
    RANK() OVER (
        PARTITION BY genre ORDER BY sm.completion_rate* 0.6 + wm.avg_watch_pct * 0.4 DESC 
    ) AS rank_in_genre
FROM content c
JOIN session_metrics sm
    ON sm.content_id = c.content_id
JOIN watch_metrics wm
    ON wm.content_id = c.content_id

;
