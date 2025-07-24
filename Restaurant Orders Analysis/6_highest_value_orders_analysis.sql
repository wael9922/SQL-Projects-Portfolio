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