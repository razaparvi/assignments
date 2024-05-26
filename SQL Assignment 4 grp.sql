 select * from items;
 select * from orders;
 select * from customers;
 -- QNO.1
WITH ItemTypeAvg AS (
    SELECT 
        item_type,
        AVG(item_price) AS item_type_avg
    FROM 
        items
    GROUP BY 
        item_type
),
ItemsHigherThanAvg AS (
    SELECT 
        i.item_id,
        i.item_name,
        i.item_type,
        i.item_price,
        ita.item_type_avg
    FROM 
        items i
    INNER JOIN 
        ItemTypeAvg ita ON i.item_type = ita.item_type
    WHERE 
        i.item_price > ita.item_type_avg
)
SELECT 
    item_id,
    item_name,
    item_type,
    item_price,
    ROUND(item_type_avg, 2) AS item_type_avg
FROM 
    ItemsHigherThanAvg;

-- QNO.2
WITH CustomerTotalAmount AS (
    SELECT 
        o.customer_id,
        SUM(i.item_price) AS total_amount
    FROM
    orders o 
   
    INNER JOIN 
        items i ON o.item_id = i.item_id
    GROUP BY 
        o.customer_id
)
SELECT 
    c.customer_id,
    cta.total_amount
FROM 
    customers c
INNER JOIN 
    CustomerTotalAmount cta ON c.customer_id = cta.customer_id
WHERE 
    cta.total_amount > 100;
    
-- [Question 2b]
ALTER TABLE customers
ADD customer_value VARCHAR(15);
    
-- [Question 2c]

WITH CustomerTotalAmount AS (
    SELECT 
        c.customer_id,
        (
            SELECT SUM(i.item_price) 
            FROM orders o 
            INNER JOIN items i ON o.item_id = i.item_id 
            WHERE o.customer_id = c.customer_id
        ) AS total_amount
    FROM 
        customers c
)
UPDATE customers
SET customer_value = 
    CASE 
        WHEN (
            SELECT total_amount 
            FROM CustomerTotalAmount cta 
            WHERE cta.customer_id = customers.customer_id
        ) > 150 THEN 'high value'
        WHEN (
            SELECT total_amount 
            FROM CustomerTotalAmount cta 
            WHERE cta.customer_id = customers.customer_id
        ) BETWEEN 100 AND 150 THEN 'median value'
        ELSE 'low value'
    END;
    
-- [Question 2d]
    
    SELECT *
FROM customers
ORDER BY 
    CASE 
        WHEN customer_value = 'high value' THEN 1
        WHEN customer_value = 'median value' THEN 2
        ELSE 3
    END DESC, 
    customer_id ASC;
    
-- [Question 3] 
SELECT 
    customer_id,
    last_name,
    address,
    street,
    city,
    COUNT(*) OVER (PARTITION BY street, city) AS customer_count_in_street_city
FROM 
    customers
ORDER BY 
    customer_id
LIMIT 100;

-- [Question 4]
SELECT 
    item_id,
    item_name,
    item_type,
    item_price,
    DENSE_RANK() OVER (PARTITION BY item_type ORDER BY item_price DESC) AS rank_within_type
FROM 
    items;
-- [Question 5] 
SELECT 
    item_type,
    ROUND(AVG(item_price), 3) AS item_type_avg,
    DENSE_RANK() OVER (ORDER BY AVG(item_price) DESC) AS ranks
FROM 
    items
GROUP BY 
    item_type;
    
    -- [Question 6a] 
    WITH CustomerPurchase AS (
    SELECT 
        o.customer_id,
        MAX(i.item_price) AS max_purchase,
        AVG(i.item_price) AS avg_purchase
    FROM 
        orders o
    JOIN 
        items i ON o.item_id = i.item_id
    GROUP BY 
        o.customer_id
)
SELECT 
    customer_id,
    max_purchase,
    avg_purchase,
    RANK() OVER (ORDER BY max_purchase DESC) AS max_purchase_rank,
    RANK() OVER (ORDER BY avg_purchase DESC) AS avg_purchase_rank
FROM 
    CustomerPurchase;
    
   -- [Question 6b] 
    
    WITH CustomerPurchase AS (
    SELECT 
        o.customer_id,
        MAX(i.item_price) AS max_purchase,
        AVG(i.item_price) AS avg_purchase
    FROM 
        orders o
    JOIN 
        items i ON o.item_id = i.item_id
    GROUP BY 
        o.customer_id
)
SELECT 
    customer_id,
    max_purchase,
    avg_purchase,
    max_purchase_rank,
    avg_purchase_rank
FROM (
    SELECT 
        customer_id,
        max_purchase,
        avg_purchase,
        RANK() OVER (ORDER BY max_purchase DESC) AS max_purchase_rank,
        RANK() OVER (ORDER BY avg_purchase DESC) AS avg_purchase_rank
    FROM 
        CustomerPurchase
) RankedCustomers
WHERE 
    max_purchase_rank = avg_purchase_rank;
    
-- [Question 7]
    WITH OrderDates AS (
    SELECT 
        customer_id,
        order_id,
        order_date,
        LEAD(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS next_order_date
    FROM 
        orders
)
SELECT 
    customer_id,
    order_id,
    order_date AS current_row_date,
    next_order_date,
    DATEDIFF(next_order_date, order_date) AS difference
FROM 
    OrderDates
WHERE 
    next_order_date IS NOT NULL;
    
    -- [Question 8]
    SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.phone_number,
    MAX(o.order_date) AS last_order_date,
    '2022-07-01' AS date_today,
    DATEDIFF('2022-07-01', MAX(o.order_date)) AS difference
FROM 
    customers c 
JOIN 
    orders o  ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name, c.phone_number
HAVING 
    DATEDIFF('2022-07-01', MAX(o.order_date)) > 50
order by c.customer_id;

-- BONUS QUESTIONS

-- [Question 9]

-- nahin ho raha
    
-- [Question 10a]
    
SELECT 
    o.customer_id,
    c.date_of_birth,
    o.order_date
FROM 
    orders o
JOIN 
    customers c ON o.customer_id = c.customer_id
WHERE 
    MONTH(o.order_date) = MONTH(c.date_of_birth);
    
    
-- [Question 10b]

SELECT 
    o.customer_id,
    c.date_of_birth,
    o.order_date
FROM 
    orders o
JOIN 
    customers c ON o.customer_id = c.customer_id
WHERE 
    day(o.order_date) = day(c.date_of_birth);

    










