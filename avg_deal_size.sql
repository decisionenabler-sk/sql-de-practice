/*
Assuming company operates on a per user (per seat) pricing model, we have a table containing contracts data.
Write a query to calculate the average annual revenue per customer in three market segments: SMB, Mid-Market, and Enterprise. 
Each customer is represented by a single contract. Format the output to match the structure shown in the Example Output section below.
Assumptions:

Yearly seat cost refers to the cost per seat.
Each customer is represented by one contract.
The market segments are categorized as:-
SMB (less than 100 employees)
Mid-Market (100 to 999 employees)
Enterprise (1000 employees or more)
The terms "average deal size" and "average revenue" refer to the same concept which is the average annual revenue generated per customer in each market segment.

contracts Table:

customer_id	integer
num_seats	integer
yearly_seat_cost	integer

contracts Example Input:

customer_id	num_seats	yearly_seat_cost
2690	50	25
4520	200	50
4520	150	50
4520	150	50
7832	878	50

customers Table:
customer_id	integer
name	varchar
employee_count	integer (0-100,000)

customers Example Input:

customer_id	name	employee_count
4520	Bell Labs	500
2690	DescisionEnablers	99
7832	GitHub	878

Example Output:
smb_avg_revenue	mid_avg_revenue	enterprise_avg_revenue
1250	25000	43900
*/
SELECT FROM customers;
