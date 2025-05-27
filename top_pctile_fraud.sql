/* 
We want to identify the most suspicious claims in each state. 
We'll consider the top 5 percentile of claims with the highest fraud scores in each state as potentially fraudulent.
The output should include the policy number, state, claim cost, and fraud score.

*/

WITH percentile AS (
    SELECT
    *,
    ROUND(PERCENT_RANK() OVER(PARTITION BY state ORDER BY fraud_score DESC),2) AS top_fraud_score
FROM
    fraud_score
)
SELECT policy_num, state, claim_cost, fraud_score
FROM percentile
WHERE top_fraud_score <= 0.05
;