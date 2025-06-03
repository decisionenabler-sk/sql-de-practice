/*
Find the top 5 states with the most 5 star businesses. 
Output the state name along with the number of 5-star businesses and order records by the number of 5-star businesses in descending order. 
In case there are ties in the number of businesses, return all the unique states. 
If two states have the same result, sort them in alphabetical order.
*/
WITH ranked_states AS (
SELECT 
    state, 
    COUNT(IF(stars = 5,business_id, NULL)) AS five_star_business_count,
    DENSE_RANK() OVER(ORDER BY COUNT(IF(stars = 5,business_id, NULL)) DESC) AS five_star_business_rank
FROM yelp_business
GROUP BY 1
)

SELECT 
    state, 
    five_star_business_count
FROM ranked_states
WHERE five_star_business_rank <= 5
ORDER BY 2 DESC, state
;