-- Which cuisines should we focus on developing more menu items for based on the data?
SELECT mi.category,
    SUM(mi.price) AS revenue_per_cuisines,
    COUNT(*) AS number_of_orders_per_cuisines,
    ROUND(
        SUM(mi.price) / COUNT(DISTINCT mi.menu_item_id),
        2
    ) AS avg_revenue_per_item
FROM order_details od
    JOIN menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY mi.category
ORDER BY number_of_orders_per_cuisines DESC;