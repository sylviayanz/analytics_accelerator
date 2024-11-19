------------------------------------ ORDER BY & LIMIT ------------------------------------


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

------------------------------------ WHERE ------------------------------------


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


------------------------------------ Arithmetic Operators ------------------------------------


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

------------------------------------ Logical Operators ------------------------------------

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


------------------------------------ JOIN ------------------------------------

--Provide a table for all web_events associated with account name of Walmart. 
--There should be three columns. Be sure to include the primary_poc, time of the event, 
--and the channel for each event. Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.

SELECT w.occurred_at, w.channel, a.name, a.primary_poc
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
WHERE a.name = 'Walmart';

--Provide a table that provides the region for each sales_rep along with their associated accounts. 
--Your final table should include three columns: the region name, the sales rep name, and the account name. 
--Sort the accounts alphabetically (A-Z) according to account name.

SELECT r.name, s.name, a.name
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON a.sales_rep_id = s.id
ORDER BY a.name;

--Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
--Your final table should have 3 columns: region name, account name, and unit price. 
--A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.

SELECT r.name, a.name, o.total_amt_usd/(o.total+0.01) AS  unit_price --coz we don't want to divided by 0, so add 0.01
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON a.sales_rep_id = s.id 
JOIN orders o
ON o.account_id = a.id;


--Provide a table that provides the region for each sales_rep along with their associated accounts. 
--This time only for the Midwest region. Your final table should include three columns: the region name, the sales rep name, 
--and the account name. Sort the accounts alphabetically (A-Z) according to account name.

SELECT r.name AS region_name, s.name AS sales_rep_name, a.name AS account_name
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest'
ORDER BY account_name;


--Provide a table that provides the region for each sales_rep along with their associated accounts. 
--This time only for accounts where the sales rep has a first name starting with S and in the Midwest region. 
--Your final table should include three columns: the region name, the sales rep name, and the account name. 
--Sort the accounts alphabetically (A-Z) according to account name.

SELECT r.name AS region_name, s.name AS sales_rep_name, a.name AS account_name
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest' AND s.name LIKE 'S%'
ORDER BY account_name;


--Provide a table that provides the region for each sales_rep along with their associated accounts. 
--This time only for accounts where the sales rep has a last name starting with K and in the Midwest region. 
--Your final table should include three columns: the region name, the sales rep name, and the account name. 
--Sort the accounts alphabetically (A-Z) according to account name.
  
SELECT r.name AS region_name, s.name AS sales_rep_name, a.name AS account_name
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest' AND s.name LIKE '% K%'
ORDER BY account_name;


--Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
--However, you should only provide the results if the standard order quantity exceeds 100. 
--Your final table should have 3 columns: region name, account name, and unit price. 
--In order to avoid a division by zero error, adding .01 to the denominator here is helpful total_amt_usd/(total+0.01).

SELECT r.name AS region_name, a.name AS account_name, total_amt_usd/(total+0.01) AS unit_price
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id =a.id
WHERE o.standard_qty > 100;


--Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
--However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. 
--Your final table should have 3 columns: region name, account name, and unit price. Sort for the smallest unit price first.
--In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).


SELECT r.name AS region_name, a.name AS account_name, total_amt_usd/(total+0.01) AS unit_price
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id =a.id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price;


--Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order.
--However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. 
--Your final table should have 3 columns: region name, account name, and unit price. Sort for the largest unit price first. 
--In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).


SELECT r.name AS region_name, a.name AS account_name, total_amt_usd/(total+0.01) AS unit_price
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id =a.id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price DESC;


--What are the different channels used by account id 1001? Your final table should have only 2 columns: account name and the different channels. 
--You can try SELECT DISTINCT to narrow down the results to only the unique values.

SELECT DISTINCT a.name, w.channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE a.id = '1001';

--Find all the orders that occurred in 2015. Your final table should have 4 columns: occurred_at, account name, order total, and order total_amt_usd.

SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM accounts a
JOIN orders o
ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '01-01-2015' AND '01-01-2016'
ORDER BY o.occurred_at DESC;




------------------------------------ Aggregation ----------------------------------

--1. COUNT
--COUNT does not consider rows that have NULL values--

--2. SUM
-- only use SUM on numeric columns --

--3. MIN and MAX 
-- can be used on non-numerical columns. 
--Depending on the column type, MIN will return the lowest number, earliest date, or non-numerical value as early in the alphabet as possible. 
--MAX does the opposite—it returns the highest number, the latest date, or the non-numerical value closest alphabetically to “Z.”

--4. AVG
-- ignores the NULL values in both the numerator and the denominator.
--If you want to count NULLs as zero, you will need to use SUM and COUNT, like SUM()/COUNT(), rather than just using AVG()

--When was the earliest order ever placed?
SELECT MIN(occurred_at) 
FROM orders;

--OR
SELECT occurred_at 
FROM orders 
ORDER BY occurred_at
LIMIT 1;

--When did the most recent (latest) web_event occur?
SELECT MAX(occurred_at)
FROM web_events;

--OR
SELECT occurred_at
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;

--Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of each paper type purchased per order. 
--Your final answer should have 6 values - one for each paper type for the average number of sales, as well as the average amount.
SELECT AVG(standard_qty) mean_standard, AVG(gloss_qty) mean_gloss, 
              AVG(poster_qty) mean_poster, AVG(standard_amt_usd) mean_standard_usd, 
              AVG(gloss_amt_usd) mean_gloss_usd, AVG(poster_amt_usd) mean_poster_usd
FROM orders;

--what is the MEDIAN total_usd spent on all orders?
SELECT *
FROM (SELECT total_amt_usd
         FROM orders
         ORDER BY total_amt_usd
         LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;

--(Since there are 6912 orders - we want the average of the 3457 and 3456 order amounts when ordered. 
--This is the average of 2483.16 and 2482.55. This gives the median of 2482.855. 
--This obviously isn't an ideal way to compute. If we obtain new orders, we would have to change the limit. 
--SQL didn't even calculate the median for us. 
--The above used a SUBQUERY, but you could use any method to find the two necessary values, and then you just need the average of them.)

--5. GROUP BY 
--Any column in the SELECT statement that is not within an aggregator must be in the GROUP BY clause.

--Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.
SELECT a.name, o.occurred_at
FROM accounts a
JOIN orders o
ON a.id =o.account_id
ORDER BY  o.occurred_at 
LIMIT 1;

--Find the total sales in usd for each account. You should include two columns - the total sales for each company's orders in usd and the company name.
SELECT a.name, SUM(o.total_amy_usd) AS total_sales
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;

--Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? 
--Your query should return only three values - the date, channel, and account name.

SELECT w.occurred_at, w.channel, a.name
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
ORDER BY w.occurred_at DESC
LIMIT 1;

--Find the total number of times each type of channel from the web_events was used. 
--Your final table should have two columns - the channel and the number of times the channel was used.

SELECT channel, COUNT(*)
FROM web_events
GROUP BY channel;

--Who was the primary contact associated with the earliest web_event?
SELECT a.primary_poc
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
ORDER BY w.occurred_at
LIMIT 1;

--What was the smallest order placed by each account in terms of total usd. 
--Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.

SELECT a.name, MIN(o.total_amt_usd) AS smallest_order
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY smallest_order ASC;

--Find the number of sales reps in each region. 
--Your final table should have two columns - the region and the number of sales_reps. Order from fewest reps to most reps.

SELECT r.name, COUNT(s.id) AS num_of_sales
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
GROUP BY r.name
ORDER BY num_of_sales;

----------------------------------------------------------------------------------------------------------------------------

--You can GROUP BY multiple columns at once, often useful to aggregate across a number of different segments.
--The order of column names in your GROUP BY clause doesn’t matter—the results will be the same regardless.
--As with ORDER BY, you can substitute numbers for column names in the GROUP BY clause.
--Any column that is not within an aggregation must show up in your GROUP BY statement. 

----------------------------------------------------------------------------------------------------------------------------


--For each account, determine the average amount of each type of paper they purchased across their orders. 
--Your result should have four columns - one for the account name and one for the average quantity purchased for each of the paper types for each account.

SELECT a.name, AVG(o.standard_qty) avg_stand, AVG(o.gloss_qty) avg_gloss, AVG(o.poster_qty) avg_post
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;

--If you need to consider all orders, regardless of whether some orders include purchases of a specific paper type, you should use the first method (SUM()/COUNT()).
--However, if you only want to calculate the average quantity based on orders that actually purchased a specific paper type, the second method (AVG()) is recommended.
--In most business scenarios, the second method is more applicable, as analyses typically focus on orders with actual purchasing behavior.

----------------------------------------------------------------------------------------------------------------------------------------------------

--For each account, determine the average amount spent per order on each paper type. 
--Your result should have four columns - one for the account name and one for the average amount spent on each paper type.

SELECT a.name, AVG(o.standard_amt_usd) avg_stand, AVG(o.gloss_amt_usd) avg_gloss, AVG(o.poster_amt_usd) avg_post
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;

--Determine the number of times a particular channel was used in the web_events table for each sales rep. 
--Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences. 
--Order your table with the highest number of occurrences first.

SELECT s.name, w.channel, COUNT(w.*) AS num_events
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name, w.channel
ORDER BY num_events DESC;


--Determine the number of times a particular channel was used in the web_events table for each region. 
--Your final table should have three columns - the region name, the channel, and the number of occurrences. 
--Order your table with the highest number of occurrences first.

SELECT r.name, w.channel, COUNT(w.*) AS num_events
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
GROUP BY  r.name, w.channel
ORDER BY num_events DESC;

----------------------------------------------------------------------------------------------------------------------------------------------------
       -------------------------------------------------------DISTINCT---------------------------------------------------------
--DISTINCT is always used in SELECT statements, and it provides the unique rows for all columns written in the SELECT statement. 
--Therefore, only use DISTINCT once in any particular SELECT statement.
--Using DISTINCT, particularly in aggregations, can slow your queries down quite a bit.
----------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------------
       -------------------------------------------------------HAVING---------------------------------------------------------
--HAVING is the “clean” way to filter a query that has been aggregated, but this is also commonly done using a subquery(opens in a new tab). 
--Essentially, any time you want to perform a WHERE on an element of your query that was created by an aggregate, you need to use HAVING instead.

----------------------------------------------------------------------------------------------------------------------------------------------------

--How many of the sales reps have more than 5 accounts that they manage?
SELECT COUNT(*) AS num_rep
FROM(SELECT s.id, s.name, COUNT(a.id) AS num_account
  FROM sales_reps s
  JOIN accounts a
  ON s.id = a.sales_rep_id
  GROUP BY s.id, s.name
  HAVING COUNT(a.id) > 5 )AS table1;

--How many accounts have more than 20 orders?
SELECT COUNT(*)
FROM (SELECT a.id, a.name, COUNT(o.id) AS num_order
  FROM accounts a
  JOIN orders o
  ON a.id = o.account_id
  GROUP BY a.id, a.name
  HAVING COUNT(o.id) > 20) AS table2;

--Which account has the most orders?

SELECT a.id, a.name, COUNT(o.id) AS num_order
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY num_order DESC
LIMIT 1;


--How many accounts spent more than 30,000 usd total across all orders?

SELECT COUNT(*)
FROM (SELECT a.id, a.name, SUM(o.total_amt_usd) AS sum_total
  FROM accounts a
  JOIN orders o
  ON a.id = o.account_id
  GROUP BY a.id, a.name
  HAVING SUM(o.total_amt_usd) > 30000) AS table3;


--How many accounts spent less than 1,000 usd total across all orders?

SELECT COUNT(*)
FROM (SELECT a.id, a.name, SUM(o.total_amt_usd) AS sum_total
  FROM accounts a
  JOIN orders o
  ON a.id = o.account_id
  GROUP BY a.id, a.name
  HAVING SUM(o.total_amt_usd) < 1000) AS table4;

--Which account has spent the most with us?
SELECT a.id, a.name, SUM(o.total_amt_usd) AS sum_total
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY sum_total DESC
LIMIT 1;

--Which account has spent the least with us?

SELECT a.id, a.name, SUM(o.total_amt_usd) AS sum_total
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY sum_total 
LIMIT 1;

--Which accounts used facebook as a channel to contact customers more than 6 times?

SELECT a.id, a.name, COUNT(w.id) AS num_facebook_contacts
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE w.channel = 'facebook' 
GROUP BY a.id, a.name
HAVING COUNT(w.id) > 6 
ORDER BY num_facebook_contacts DESC;


--Which account used facebook most as a channel?

SELECT a.id, a.name, COUNT(w.id) AS num_facebook_contacts
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE w.channel = 'facebook' 
GROUP BY a.id, a.name
ORDER BY num_facebook_contacts DESC
LIMIT 1;


--Which channel was most frequently used by most accounts?
SELECT w.channel, COUNT(a.id) AS num_account
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
GROUP BY w.channel
ORDER BY COUNT(a.id) DESC
LIMIT 1;



----------------------------------------------------------------------------------------------------------------------------------------------------
       -------------------------------------------------------DATE---------------------------------------------------------
--1. DATE_TRUNC: To truncate your date to a particular part of your date-time column. Common trunctions are day, month, and year
--2. DATE_PART: Pulling a specific portion of a date, but notice pulling month or day of the week (dow) means that you are no longer keeping the years in order. 
--Rather you are grouping for certain components regardless of which year they belonged in.
----------------------------------------------------------------------------------------------------------------------------------------------------


--Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. Do you notice any trends in the yearly sales totals?

SELECT DATE_PART('year', occurred_at) AS ord_year, SUM(total_amt_usd) AS total_spent
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

--Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly represented by the dataset?

SELECT DATE_PART('month', occurred_at) AS ord_year, SUM(total_amt_usd) AS total_spent
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

--Which year did Parch & Posey have the greatest sales in terms of total number of orders? Are all years evenly represented by the dataset?


SELECT DATE_PART('year', occurred_at) AS ord_year, COUNT(*) AS total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC;


--Which month did Parch & Posey have the greatest sales in terms of total number of orders? Are all months evenly represented by the dataset?

SELECT DATE_PART('month', occurred_at) AS ord_year, COUNT(*) AS total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

--In which month of which year did Walmart spend the most on gloss paper in terms of dollars?

SELECT DATE_TRUNC('month', o.occurred_at) ord_date, SUM(o.gloss_amt_usd) AS total_spent
FROM orders o
JOIN accounts a
ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

----------------------------------------------------------------------------------------------------------------------------------------------------
       -------------------------------------------------------CASE WHEN---------------------------------------------------------
--The CASE statement always goes in the SELECT clause.
--CASE must include the following components: WHEN, THEN, and END. 
--ELSE is an optional component to catch cases that didn’t meet any of the other previous CASE conditions.
--You can make any conditional statement using any conditional operator (like WHERE(opens in a new tab)) between WHEN and THEN.
--This includes stringing together multiple conditional statements using AND and OR.
--You can include multiple WHEN statements, as well as an ELSE statement again, to deal with any unaddressed conditions.
----------------------------------------------------------------------------------------------------------------------------------------------------
--Write a query to display for each order, the account ID, total amount of the order, 
--and the level of the order - ‘Large’ or ’Small’ - depending on if the order is $3000 or more, or less than $3000.
SELECT id, total_amt_usd, 
  CASE WHEN total_amt_usd > 3000 THEN 'Large' 
  ELSE 'Small' END AS order_level
FROM orders;


--Write a query to display the number of orders in each of three categories, based on the total number of items in each order. 
--The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.

SELECT CASE WHEN total >= 2000 THEN 'At Least 2000'
      WHEN total >= 1000 AND total < 2000 THEN 'Between 1000 and 2000'
      ELSE 'Less than 1000' END AS order_category,
  COUNT(*) AS order_count
FROM orders
GROUP BY 1;

--We would like to understand 3 different branches of customers based on the amount associated with their purchases. 
--The top branch includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. 
--The second branch is between 200,000 and 100,000 usd. The lowest branch is anyone under 100,000 usd. 
--Provide a table that includes the level associated with each account. 
--You should provide the account name, the total sales of all orders for the customer, and the level. Order with the top spending customers listed first.


SELECT a.name, SUM(o.total_amt_usd) AS total_sales,
    CASE WHEN SUM(o.total_amt_usd) >=200000 THEN 'top branch'
    WHEN SUM(o.total_amt_usd) >= 100000 AND SUM(o.total_amt_usd) < 200000 THEN 'second branch'
    ELSE 'third branch' END AS customer_level
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC;

--We would now like to perform a similar calculation to the first, but we want to obtain the total amount spent by customers only in 2016 and 2017. 
--Keep the same levels as in the previous question. Order with the top spending customers listed first.


SELECT a.name, SUM(o.total_amt_usd) AS total_sales,
    CASE WHEN SUM(o.total_amt_usd) >=200000 THEN 'top branch'
    WHEN SUM(o.total_amt_usd) >= 100000 AND SUM(o.total_amt_usd) < 200000 THEN 'second branch'
    ELSE 'third branch' END AS customer_level
FROM accounts a
JOIN orders o
ON a.id = o.account_id
WHERE o.occurred_at BETWEEN '2016-01-01' AND '2018-01-01' 
GROUP BY 1
ORDER BY 2 DESC;

--We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders. 
--Create a table with the sales rep name, the total number of orders, and a column with top or not depending on if they have more than 200 orders. 
--Place the top sales people first in your final table.


SELECT s.name, COUNT(o.*) AS orders,
    CASE WHEN COUNT(o.*)> 200 THEN 'top' ELSE 'not top' END AS performance
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY 1
ORDER BY 2 DESC;

--The previous didn't account for the middle, nor the dollar amount associated with the sales. 
--Management decides they want to see these characteristics represented as well. 
--We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders or more than 750000 in total sales. 
--The middle group has any rep with more than 150 orders or 500000 in sales. 
--Create a table with the sales rep name, the total number of orders, total sales across all orders, and a column with top, middle, or low depending on this criteria. 
--Place the top sales people based on dollar amount of sales first in your final table.


SELECT 
    s.name, 
    COUNT(o.*) AS orders, 
    SUM(o.total_amt_usd) AS total_sales,
    CASE 
        WHEN COUNT(o.*) > 200 OR SUM(o.total_amt_usd) > 750000 THEN 'top' 
        WHEN COUNT(o.*) > 150 OR (SUM(o.total_amt_usd) > 500000 AND SUM(o.total_amt_usd) <= 750000) THEN 'middle'
        ELSE 'low' 
    END AS performance
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY total_sales DESC;



















