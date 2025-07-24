-- What were the least ordered items? What categories were they in?
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
ORDER BY number_of_orders
LIMIT 5;