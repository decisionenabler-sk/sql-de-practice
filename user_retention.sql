/*
CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY,
    signup_date DATE,
    subscription_tier VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS viewing_sessions (
    session_id INT PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    content_id INT,
    session_date DATE,
    watch_duration_minutes INT
);

INSERT INTO users (user_id, signup_date, subscription_tier) VALUES
(1, '2024-01-15', 'premium'),
(2, '2024-01-16', 'basic'),
(3, '2024-01-20', 'premium'),
(4, '2024-02-05', 'basic'),
(5, '2024-02-10', 'premium'),
(6, '2024-03-01', 'basic');

INSERT INTO viewing_sessions (session_id, user_id, content_id, session_date, watch_duration_minutes) VALUES
(1001, 1, 501, '2024-01-15', 45),
(1002, 1, 502, '2024-02-10', 30),
(1003, 2, 501, '2024-01-20', 60),
(1004, 3, 503, '2024-01-25', 90),
(1005, 2, 504, '2024-02-15', 40),
(1006, 3, 505, '2024-03-05', 50),
(1007, 4, 506, '2024-02-06', 70),
(1008, 4, 507, '2024-03-10', 60),
(1009, 5, 508, '2024-02-12', 80),
(1010, 5, 509, '2024-03-15', 55),
(1011, 6, 510, '2024-03-02', 65);
Question:
Calculate the monthly retention rate for users. 
For each signup month, show what percentage of users were still active (had at least one viewing session) in each subsequent month.
Expected Output:
signup_month | months_after_signup | retention_rate
2024-01      | 1                   | 0.67
2024-01      | 2                   | 0.67
2024-01      | 3                   | 0.33
2024-02      | 1                   | 1.00
2024-02      | 2                   | 0.67
2024-03      | 1                   | 1.00
*/

/*
Approach: 1st calculate the count of active users where month > signup_month and count of total active users in each month cohort
2024-01 Cohort (users 1, 2, 3)
Month 1: All 3 users have a session in Jan (1.00)
Month 2: Users 1 and 2 have sessions in Feb (2/3 = 0.67)
Month 3: Only user 3 has a session in Mar (1/3 = 0.33)
2024-02 Cohort (users 4, 5)
Month 1: Both users have sessions in Feb (2/2 = 1.00)
Month 2: Both users have sessions in Mar (2/2 = 1.00)
2024-03 Cohort (user 6)
Month 1: User 6 has a session in Mar (1/1 = 1.00)
*/
WITH user_cohorts AS (
    SELECT 
        user_id,
        TO_CHAR(signup_date, 'YYYY-MM') AS signup_month,
        signup_date
    FROM users
),
user_activity AS (
    SELECT
        u.user_id,
        u.signup_month,
        TO_CHAR(s.session_date, 'YYYY-MM') AS active_month,
        (EXTRACT(YEAR FROM s.session_date) - EXTRACT(YEAR FROM u.signup_date)) * 12 +
        (EXTRACT(MONTH FROM s.session_date) - EXTRACT(MONTH FROM u.signup_date)) + 1 AS months_after_signup
    FROM user_cohorts u
    JOIN viewing_sessions s ON u.user_id = s.user_id
    WHERE s.session_date >= u.signup_date
),
cohort_sizes AS (
    SELECT 
        signup_month, 
        COUNT(DISTINCT user_id) AS cohort_size
    FROM user_cohorts
    GROUP BY signup_month
),
retention_data AS (
    SELECT
        ua.signup_month,
        ua.months_after_signup,
        COUNT(DISTINCT ua.user_id) AS active_users
    FROM user_activity ua
    GROUP BY 1,2
)
SELECT
    r.signup_month,
    r.months_after_signup,
    ROUND(r.active_users::DECIMAL / c.cohort_size, 2) AS retention_rate
FROM retention_data r
JOIN cohort_sizes c ON r.signup_month = c.signup_month
ORDER BY r.signup_month, r.months_after_signup;

