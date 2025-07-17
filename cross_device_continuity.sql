/*
CREATE TABLE devices (
    device_id INT PRIMARY KEY,
    device_type VARCHAR(20),
    user_id INT
);

CREATE TABLE device_sessions (
    session_id INT PRIMARY KEY,
    user_id INT,
    device_id INT REFERENCES devices(device_id),
    content_id INT,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    position_start_sec INT,
    position_end_sec INT
);

-- Insert sample data into devices
INSERT INTO devices (device_id, device_type, user_id) VALUES
(101, 'TV', 1),
(102, 'mobile', 1),
(103, 'tablet', 1),
(104, 'TV', 2);

-- Insert sample data into viewing_sessions
INSERT INTO device_sessions (session_id, user_id, device_id, content_id, start_time, end_time, position_start_sec, position_end_sec) VALUES
(8001, 1, 101, 501, '2024-01-15 20:00:00', '2024-01-15 20:30:00', 0, 1800),
(8002, 1, 102, 501, '2024-01-15 20:35:00', '2024-01-15 21:00:00', 1800, 3300),
(8003, 1, 103, 501, '2024-01-15 21:05:00', '2024-01-15 21:30:00', 3300, 4800),
(8004, 2, 101, 502, '2024-01-15 19:00:00', '2024-01-15 19:45:00', 0, 2700),
(8005, 2, 101, 502, '2024-01-15 21:00:00', '2024-01-15 21:30:00', 2700, 4500),
(8006, 3, 102, 503, '2024-01-15 22:00:00', '2024-01-15 22:30:00', 300, 2100);
-- Add more sample data to include unsuccessful handoffs

-- User 1: Unsuccessful handoff (gap > 10 min)
INSERT INTO device_sessions (session_id, user_id, device_id, content_id, start_time, end_time, position_start_sec, position_end_sec) VALUES
(8007, 1, 101, 504, '2024-01-16 10:00:00', '2024-01-16 10:30:00', 0, 1800),
(8008, 1, 102, 504, '2024-01-16 11:00:00', '2024-01-16 11:30:00', 1800, 3300), -- 30 min gap

-- User 2: Unsuccessful handoff (position not continuous)

(8009, 2, 104, 505, '2024-01-17 09:00:00', '2024-01-17 09:30:00', 0, 1800),
(8010, 2, 101, 505, '2024-01-17 09:35:00', '2024-01-17 10:00:00', 2000, 3500), -- position_start_sec does not match previous position_end_sec

-- User 3: Successful handoff (gap < 10 min, position continuous)

(8011, 3, 102, 506, '2024-01-18 08:00:00', '2024-01-18 08:30:00', 0, 1800),
(8012, 3, 103, 506, '2024-01-18 08:35:00', '2024-01-18 09:00:00', 1800, 3300), -- 5 min gap, position continuous

-- User 3: Unsuccessful handoff (gap < 10 min, position not continuous)

(8013, 3, 101, 507, '2024-01-18 10:00:00', '2024-01-18 10:30:00', 0, 1800),
(8014, 3, 102, 507, '2024-01-18 10:35:00', '2024-01-18 11:00:00', 1000, 2500); -- 5 min gap, but position not continuous
-- device_sessions table
session_id | user_id | device_id | content_id | start_time           | end_time             | position_start_sec | position_end_sec
8001       | 1       | 101       | 501        | 2024-01-15 20:00:00  | 2024-01-15 20:30:00  | 0                 | 1800
8002       | 1       | 102       | 501        | 2024-01-15 20:35:00  | 2024-01-15 21:00:00  | 1800              | 3300
8003       | 1       | 103       | 501        | 2024-01-15 21:05:00  | 2024-01-15 21:30:00  | 3300              | 4800
8004       | 2       | 101       | 502        | 2024-01-15 19:00:00  | 2024-01-15 19:45:00  | 0                 | 2700
8005       | 2       | 101       | 502        | 2024-01-15 21:00:00  | 2024-01-15 21:30:00  | 2700              | 4500
8006       | 3       | 102       | 503        | 2024-01-15 22:00:00  | 2024-01-15 22:30:00  | 300               | 2100
8007       | 1       | 101       | 504        | 2024-01-16 10:00:00  | 2024-01-16 10:30:00  | 0                 | 1800
8008       | 1       | 102       | 504        | 2024-01-16 11:00:00  | 2024-01-16 11:30:00  | 1800              | 3300
8009       | 2       | 104       | 505        | 2024-01-17 09:00:00  | 2024-01-17 09:30:00  | 0                 | 1800
8010       | 2       | 101       | 505        | 2024-01-17 09:35:00  | 2024-01-17 10:00:00  | 2000              | 3500
8011       | 3       | 102       | 506        | 2024-01-18 08:00:00  | 2024-01-18 08:30:00  | 0                 | 1800
8012       | 3       | 103       | 506        | 2024-01-18 08:35:00  | 2024-01-18 09:00:00  | 1800              | 3300
8013       | 3       | 101       | 507        | 2024-01-18 10:00:00  | 2024-01-18 10:30:00  | 0                 | 1800
8014       | 3       | 102       | 507        | 2024-01-18 10:35:00  | 2024-01-18 11:00:00  | 1000              | 2500
-- devices table
device_id | device_type | user_id
101       | TV          | 1
102       | mobile      | 1  
103       | tablet      | 1
104       | TV          | 2
Identify cross-device viewing patterns. Find viewing sessions where a user switched devices within 10 minutes to continue watching the same content. 
Calculate handoff_success_rate (sessions with position continuity / total handoffs) and avg_handoff_gap_minutes by user.
Expected Output:
user_id | total_handoffs | successful_handoffs | handoff_success_rate | avg_handoff_gap_minutes
1       | 2             | 2                   | 1.00                  | 5.0
2       | 1             | 0                   | 0.00                  | 5.0
3       | 2             | 1                   | 0.50                  | 5.0
*/
WITH cross_device_sessions AS (
    SELECT 
        s1.user_id,
        s1.session_id AS first_session,
        s2.session_id AS second_session,
        s1.end_time AS first_session_end_time,
        s2.start_time AS second_session_start_time,
        s1.position_end_sec,
        s2.position_start_sec,
        EXTRACT(EPOCH FROM (s2.start_time - s1.end_time)) / 60 AS handoff_gap_minutes,
        s1.position_end_sec = s2.position_start_sec AS is_position_continuous
    FROM device_sessions s1
    JOIN device_sessions s2
    ON s1.content_id = s2.content_id
    AND s1.user_id = s2.user_id
    AND s1.start_time < s2.start_time
    WHERE  s1.device_id <> s2.device_id 
    AND ROUND(EXTRACT(EPOCH FROM (s2.start_time - s1.end_time)) / 60,0) <=10 
)
SELECT 
    user_id,
    COUNT(*) AS total_handoffs,
    COUNT(*) FILTER (WHERE is_position_continuous) AS successful_handoffs,
    ROUND(
        COUNT(*) FILTER (WHERE is_position_continuous)::DECIMAL
        / NULLIF(COUNT(*), 0), 2
    ) AS handoff_success_rate,
    ROUND(AVG(handoff_gap_minutes),1) AS avg_handoff_gap_minutes
FROM cross_device_sessions
GROUP BY 1
;