-- Were there certain times that had more or less orders?
SELECT DATE_TRUNC('HOUR', od.order_time) as hours,
    COUNT(DISTINCT od.order_id) AS number_of_orders,
    SUM(mi.price) AS revenue_per_hour
FROM order_details od
    JOIN menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY hours
ORDER BY number_of_orders DESC,
    revenue_per_hour DESC;