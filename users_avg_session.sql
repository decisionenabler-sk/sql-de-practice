/*
Calculate each user's average session time.
A session is defined as the time difference between a page_load and a page_exit. 
Assume each user has only one session per day. 
If there are multiple page_load or page_exit events on the same day, use only the latest page_load and the earliest page_exit, ensuring the page_load occurs before the page_exit. 
Output the user_id and their average session time.
*/
SELECT
    user_id,
    ROUND(AVG(TIMESTAMPDIFF(SECOND, session_start_time, session_end_time) /60), 2)  AS avg_session_duration
FROM (
    SELECT 
        user_id,
        DATE(timestamp) AS session_date,
        MAX( IF( action = 'page_load', timestamp, NULL)) AS session_start_time,
        MIN( IF( action = 'page_exit', timestamp, NULL)) AS session_end_time
    FROM facebook_web_log
    WHERE action IN ( 'page_load' ,'page_exit')
    GROUP BY 1,2
) t
GROUP BY 1
;