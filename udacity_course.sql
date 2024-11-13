-- ORDER BY & LIMIT --

--1. Return the 10 earliest orders in the orders table. Include the id, occurred_at, and total_amt_usd.

SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at
LIMIT 10;

--2.Return the top 5 orders in terms of largest total_amt_usd. Include the id, account_id, and total_amt_usd. 
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 5;

--3. Return the lowest 20 orders in terms of smallest total_amt_usd. Include the id, account_id, and total_amt_usd.

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd
LIMIT 20;

--4. Write a query that displays the order ID, account ID, and total dollar amount for all the orders, 
--sorted first by the account ID (in ascending order), and then by the total dollar amount (in descending order).


SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY account_id ASC, total_amt_usd DESC;

--(all of the orders for each account ID are grouped together, and then within each of those groupings, 
--the orders appear from the greatest order amount to the least. )

--5. Write a query that again displays order ID, account ID, and total dollar amount for each order, 
--but this time sorted first by total dollar amount (in descending order), and then by account ID (in ascending order).

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC, account_id ASC;

--(since you sorted by the total dollar amount first, the orders appear from greatest to least regardless of which account ID they were from. 
--Then they are sorted by account ID next. (The secondary sorting by account ID is difficult to see here, 
--since only if there were two orders with equal total dollar amounts would there need to be any sorting by account ID.))

-- WHERE --

--1. Pulls the first 5 rows and all columns from the orders table that have a dollar amount of gloss_amt_usd greater than or equal to 1000.

SELECT *
FROM orders
WHERE gloss_amt_usd >=1000
LIMIT 5;

--2. Pulls the first 10 rows and all columns from the orders table that have a total_amt_usd less than 500.

SELECT *
FROM orders
WHERE total_amt_usd < 500
LIMIT 10;

--3. Filter the accounts table to include the company name, website, and the primary point of contact (primary_poc) 
--just for the Exxon Mobil company in the accounts table.


SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';
--(WHERE with Non-Numeric) 


-- Arithmetic Operators --

--1. Create a column that divides the standard_amt_usd by the standard_qty to find the unit price for standard paper for each order. 
  --Limit the results to the first 10 orders, and include the id and account_id fields.

SELECT id, account_id, standard_amt_usd/standard_qty AS unit_price --Derive column
FROM orders
LIMIT 10;

--2. Finds the percentage of revenue that comes from poster paper for each order. 
--You will need to use only the columns that end with _usd. (Try to do this without using the total column.) 
--Display the id and account_id fields also. NOTE - you will receive an error with the correct solution to this question. 
--Limit your calculations to the first 10 orders.

SELECT id, account_id, 
       poster_amt_usd/(standard_amt_usd + gloss_amt_usd + poster_amt_usd) AS post_per
FROM orders
LIMIT 10;

-- Logical Operators --

--1.LIKE
--All the companies whose names start with 'C'.
SELECT name
FROM accounts
WHERE name LIKE 'C%';
--All companies whose names contain the string 'one' somewhere in the name.
SELECT name
FROM accounts
WHERE name LIKE '%one%';
--All companies whose names end with 's'.
SELECT name
FROM accounts
WHERE name LIKE '%s';


--2.IN
--Use the accounts table to find the account name, primary_poc, and sales_rep_id for Walmart, Target, and Nordstrom.
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');
--Use the web_events table to find all information regarding individuals who were contacted via the channel of organic or adwords.
SELECT * 
FROM web_events
WHERE channel IN ('organic', 'adwords');


--3. NOT
--Use the accounts table to find the account name, primary poc, and sales rep id for all stores except Walmart, Target, and Nordstrom.
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');
--Use the web_events table to find all information regarding individuals who were contacted via any method except using organic or adwords methods.
SELECT * 
FROM web_events
WHERE channel NOT IN ('organic', 'adwords');


--4. AND & BETWEEN

--Write a query that returns all the orders where the standard_qty is over 1000, the poster_qty is 0, and the gloss_qty is 0.
SELECT *
FROM orders
WHERE standard_qty > 1000 
  AND poster_qty = 0 
  AND gloss_qty = 0;

--Using the accounts table, find all the companies whose names do not start with 'C' and end with 's'.
SELECT name
FROM accounts
WHERE name NOT LIKE 'C%' 
  AND name LIKE '%s';

--Writing a query that displays the order date and gloss_qty data for all orders where gloss_qty is between 24 and 29. 
--Then look at your output to see if the BETWEEN operator included the begin and end values or not.
SELECT occurred_at, gloss_qty
FROM orders
WHERE gloss_qty BETWEEN 24 AND 29;

--**the BETWEEN operator in SQL is inclusive; that is, the endpoint values are included **
--So the BETWEEN statement in this query is equivalent to having written "WHERE gloss_qty >= 24 AND gloss_qty <= 29"

--Use the web_events table to find all information regarding individuals who were contacted via the organic or adwords channels, 
--and started their account at any point in 2016, sorted from newest to oldest.

SELECT * FROM web_events
WHERE channel IN ('organic', 'adwords')
  AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY occurred_at DESC;

--** While BETWEEN is generally inclusive of endpoints, it assumes the time is at 00:00:00 (i.e. midnight) for dates. 
--This is the reason why we set the right-side endpoint of the period at '2017-01-01'.

-- 5. OR
--Works with arithmetic operators (+, *, -, /),* LIKE*,* IN*,* NOT*,* AND*, and* BETWEEN logic can all be linked together using the OR* operator.
--When combining multiple of these operations, we frequently might need to use parentheses to assure that logic we want to perform is being executed correctly. 

--Find list of orders ids where either gloss_qty or poster_qty is greater than 4000. Only include the id field in the resulting table.
SELECT id
FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000;

--Returns a list of orders where the standard_qty is zero and either the gloss_qty or poster_qty is over 1000.
SELECT *
FROM orders
WHERE standard_qty = 0 AND (gloss_qty > 1000 OR poster_qty > 1000);


--Find all the company names that start with a 'C' or 'W', and the primary contact contains 'ana' or 'Ana', but it doesn't contain 'eana'.

SELECT *
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%') --condition 1.
  AND ((primary_poc LIKE 'ana' OR  primary_poc LIKE 'Ana') AND primary_poc NOT LIKE '%eana%'); -- condition 2.


