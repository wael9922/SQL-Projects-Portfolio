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