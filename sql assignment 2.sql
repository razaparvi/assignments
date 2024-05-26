-- [Question 1] find out top 5 customers with the most orders

SELECT customer_id, COUNT(order_id) as order_count
FROM orders
GROUP BY customer_id
ORDER BY order_count DESC
LIMIT 5;


-- [Question 2] find out the top 3 most sold items


select * from orders;


SELECT item_id, SUM(item_id) as total_sold
FROM orders
GROUP BY item_id
ORDER BY total_sold DESC
LIMIT 3;


-- [Question 3] show customers and total order only for customers with more than 4 orders

SELECT customer_id, COUNT(order_id) as total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > 4
ORDER BY total_orders DESC;


-- [Question 4] only show records for customers that live on oak st, pine st or cedar st and belong to either anyville or anycity


select * from customers;

SELECT *
FROM customers
WHERE (address IN ('Oak St', 'Pine St', 'Cedar St'))
    AND (city IN ('Anyville', 'Anycity'));
    
    SELECT *
FROM customers
WHERE (address IN ("Oak St", "Pine St", "Cedar St"))
    AND (city IN ("Anyville", "Anycity"));



-- [Question 5] In a simple select query, create a column called price_label in which label each item's price as:
-- low price if its price is below 10
-- moderate price if its price is between 10 and 50
-- high price if its price is above 50
-- "unavailable" in all other cases

select * from items;

SELECT item_name,
       item_price,
       CASE
           WHEN item_price < 10 THEN 'low price'
           WHEN item_price >= 10 AND item_price <= 50 THEN 'moderate price'
           WHEN item_price > 50 THEN 'high price'
           ELSE 'unavailable'
       END AS price_label
FROM items;


-- order this query by price in descending order

SELECT item_name,
       item_price,
       CASE
           WHEN item_price < 10 THEN 'low price'
           WHEN item_price >= 10 AND item_price <= 50 THEN 'moderate price'
           WHEN item_price > 50 THEN 'high price'
           ELSE 'unavailable'
       END AS price_label
FROM items
order by item_price desc;

-- [Question 6] Using DDL commands, add a column called stock_level to the items table.

ALTER TABLE items
ADD COLUMN stock_level VARCHAR(300);

select * from items;


-- [Question 7] Update this column in the following way:
-- low stock if the amount is below 20
-- moderate stock if the amount is between 20 and 50
-- high stock if the amount is over 50

UPDATE items
SET stock_level =
    CASE
        WHEN amount_in_stock < 20 THEN 'low stock'
        WHEN amount_in_stock >= 20 AND amount_in_stock <= 50 THEN 'moderate stock'
        WHEN amount_in_stock > 50 THEN 'high stock'
        ELSE 'unknown'
    END;


select * from items;


-- [Question 8] from the customers table, delete the column country

select * from customers;

ALTER TABLE customers
DROP COLUMN country;

select  * from customers;





-- [Question 9] find out the total no of customers in anytown without using group by and having

SELECT COUNT(*)
FROM customers
WHERE city = 'Anytown';


-- [Question 10] use DDL commands to add a column to the customers table called street. add this column directly after the address column
-- hint: google how to add a column before/after another column in MySQL 

 select * from customers;
 
ALTER TABLE customers
ADD COLUMN street VARCHAR(255) AFTER address;

select * from customers;





-- [Question 11] update this column by extracting the street name from address
-- (hint: MySQL also has mid/left/right functions the same as excel. You can first test these with SELECT before using UPDATE)

UPDATE customers
SET street = SUBSTRING_INDEX(address, ',', 1);

 select * from customers;
 


-- [Question 12] Find out the number of customers per city per street. 
-- order the results in ascending order by city and then descending order by street


SELECT city, street, COUNT(*) as num_customers
FROM customers
GROUP BY city, street
ORDER BY city ASC, street DESC;


-- [Question 13] in the orders table, update shipping date and order date to the correct format. also change the data types of these columns to date. 
-- (try to change both columns in one update statement and one alter statement)

select * from orders;

UPDATE orders
SET shipping_date = STR_TO_DATE(shipping_date, "%m/%d/%Y"),
    order_date = STR_TO_DATE(order_date, "%m/%d/%Y");


ALTER TABLE orders
MODIFY COLUMN shipping_date DATE,
MODIFY COLUMN order_date DATE;






UPDATE orders
SET shipping_date = STR_TO_DATE(shipping_date, '%Y/%m/%d'),
    order_date = STR_TO_DATE(order_date, '%Y/%m/%d');

-- Alter the table to change the data types
ALTER TABLE orders
MODIFY COLUMN shipping_date DATE,
MODIFY COLUMN order_date DATE;





-- [Question 14] write a query to get order id, order date, shipping date and difference in days between order date and shipping date for each order
-- (google which function in MySQL can help you do this)
-- what do you observe in the results?

SELECT order_id, order_date, shipping_date, DATEDIFF(shipping_date, order_date) as days_difference
FROM orders;


-- [Question 15] find out items priced higher than the avg price of all items (hint: you will need to use a subquery here)

SELECT item_id, item_name, item_price
FROM items
WHERE item_price > (SELECT AVG(item_price) FROM items);


-- [Question 16] using inner joins, get customer_id, first_name, last_name, order_id, order_date, item_id, item_name and item_price
-- (hint: you will need to join all three tables)

SELECT 
    c.customer_id, c.first_name, c.last_name,
    o.order_id, o.order_date,
    i.item_id, i.item_name, i.item_price AS item_price
FROM 
    customers c
    INNER JOIN orders o ON c.customer_id = o.customer_id
    INNER JOIN items i ON o.item_id = i.item_id;



-- 