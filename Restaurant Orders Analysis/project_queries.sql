-- What were the most ordered items? What categories were they in?
SELECT item_name,
    category,
    number_of_orders
FROM (
        SELECT mi.menu_item_id,
            COUNT(*) AS number_of_orders
        FROM menu_items mi
            JOIN order_details od ON mi.menu_item_id = od.item_id
        GROUP BY mi.menu_item_id
    ) item_order_counts
    JOIN menu_items mi ON mi.menu_item_id = item_order_counts.menu_item_id
ORDER BY number_of_orders DESC
LIMIT 5;
-- What were the least ordered items? What categories were they in?
SELECT mi.menu_item_id AS id,
    mi.category,
    COUNT(*) AS number_of_orders
FROM menu_items mi
    JOIN order_details od ON mi.menu_item_id = od.item_id
GROUP BY id,
    mi.category
ORDER BY number_of_orders
LIMIT 5;
-- Were there certain times that had more or less orders?
SELECT DATE_TRUNC('HOUR', od.order_time) as hours,
    COUNT(od.order_details_id) AS number_of_orders,
    SUM(mi.price) AS revenue_per_hour
FROM order_details od
    JOIN menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY hours
ORDER BY number_of_orders DESC,
    revenue_per_hour DESC;
-- Which cuisines should we focus on developing more menu items for based on the data?
SELECT mi.category,
    SUM(mi.price) AS revenue_per_cuisines,
    COUNT(*) AS number_of_orders_per_cuisines
FROM order_details od
    JOIN menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY mi.category
ORDER BY number_of_orders_per_cuisines DESC;
--What do the highest spend orders look like? Which items did they buy and how much did they spend?
WITH orders AS (
    SELECT od.order_details_id,
        od.order_id AS orders,
        od.item_id,
        mi.item_name AS name,
        mi.price AS price
    FROM order_details od
        JOIN menu_items mi ON od.item_id = mi.menu_item_id
)
SELECT orders,
    STRING_AGG(name, ', ') AS order_items,
    COUNT(*) AS item_count,
    sum(price) as total_amount
FROM orders
GROUP BY orders
ORDER BY total_amount DESC
LIMIT 20;
-- In the 10 highest value orders which items were ordered the most
WITH orders AS (
    SELECT od.order_details_id,
        od.order_id AS orders,
        od.item_id,
        mi.item_name AS name,
        mi.price AS price
    FROM order_details od
        JOIN menu_items mi ON od.item_id = mi.menu_item_id
),
highest_value_orders AS (
    SELECT orders,
        name AS order_items,
        COUNT(*) over(PARTITION BY orders) AS item_count,
        sum(price) over(PARTITION BY orders) as total_amount
    FROM orders
    WHERE orders IN (
            SELECT orders
            FROM orders
            GROUP BY orders
            ORDER BY sum(price) DESC
            LIMIT 10
        )
    ORDER BY total_amount DESC
)
SELECT order_items,
    count(*) as item_counts
FROM highest_value_orders
GROUP BY order_items
ORDER BY item_counts DESC
LIMIT 5;