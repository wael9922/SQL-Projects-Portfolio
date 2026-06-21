
 -- inspect raw data shape and spot-check values
SELECT TOP 100
* FROM orders;
-- ============================================================


-- Overall summary KPIs across the full date range
SELECT 
	COUNT(*) as total_sessions,
	SUM(order_value) as total_revenue,
	SUM(CAST(added_to_cart AS INT)) as total_sessions_added_to_cart,
	SUM(CAST(started_checkout AS INT)) as total_sessions_reached_checkout,
	SUM(CAST(payment_success AS INT)) as total_completed_orders
FROM orders;
-- ============================================================


-- Monthly revenue and traffic trend
SELECT 
	FORMAT(order_date, 'yyyy-MM') as months,
	SUM(order_value) as monthly_revenue,
	COUNT(*) as monthly_sessions
FROM orders
GROUP BY FORMAT(order_date, 'yyyy-MM') 
ORDER BY FORMAT(order_date, 'yyyy-MM');
-- ============================================================


-- Monthly revenue and traffic broken down by city
-- Checks whether the drop is concentrated in specific locations
SELECT 
	city,
	FORMAT(order_date, 'yyyy-MM') as months,
	SUM(order_value) as monthly_revenue,
	COUNT(*) as monthly_sessions
FROM orders
GROUP BY city, FORMAT(order_date, 'yyyy-MM') 
ORDER BY FORMAT(order_date, 'yyyy-MM');
-- ============================================================


-- Monthly revenue and traffic broken down by device type
SELECT 
	device_type,
	FORMAT(order_date, 'yyyy-MM') as months,
	SUM(order_value) as monthly_revenue,
	COUNT(*) as monthly_sessions
FROM orders
GROUP BY device_type, FORMAT(order_date, 'yyyy-MM') 
ORDER BY FORMAT(order_date, 'yyyy-MM');
-- ============================================================


-- Funnel conversion rates by device type, per month
-- Trying to isolates *where* in the funnel the drop occurs
WITH monthly_report_device as(
	SELECT 
		device_type,
		FORMAT(order_date, 'yyyy-MM') as months,
		COUNT(*) as total_sessions,
		SUM(order_value) as total_revenue,
		SUM(CAST(added_to_cart AS INT)) as total_sessions_added_to_cart,
		SUM(CAST(started_checkout AS INT)) as total_sessions_reached_checkout,
		SUM(CAST(payment_success AS INT)) as total_completed_orders
	FROM orders
	GROUP BY device_type, FORMAT(order_date, 'yyyy-MM')
)
SELECT
	device_type,
	months,
	total_revenue,
	ROUND(100.00*total_sessions_added_to_cart    / NULLIF(total_sessions, 0), 2)                   as added_to_cart_rate,
	ROUND(100.00*total_sessions_reached_checkout / NULLIF(total_sessions_added_to_cart, 0), 2)     as checkout_rate,
	ROUND(100.00*total_completed_orders          / NULLIF(total_sessions_reached_checkout, 0), 2)  as successful_payment_rate
FROM monthly_report_device
ORDER BY months;
-- ============================================================



-- Funnel conversion rates by payment method, per month
-- Tests whether a single payment method is driving the successful payment rate down
WITH monthly_report_payment_method as(
	SELECT 
		payment_method,
		FORMAT(order_date, 'yyyy-MM') as months,
		COUNT(*) as total_sessions,
		SUM(order_value) as total_revenue,
		SUM(CAST(added_to_cart AS INT)) as total_sessions_added_to_cart,
		SUM(CAST(started_checkout AS INT)) as total_sessions_reached_checkout,
		SUM(CAST(payment_success AS INT)) as total_completed_orders
	FROM orders
	GROUP BY payment_method, FORMAT(order_date, 'yyyy-MM')
)
SELECT
	payment_method,
	months,
	total_revenue,
	ROUND(100.00*total_sessions_added_to_cart    / NULLIF(total_sessions, 0), 2)                   as added_to_cart_rate,
	ROUND(100.00*total_sessions_reached_checkout / NULLIF(total_sessions_added_to_cart, 0), 2)     as checkout_rate,
	ROUND(100.00*total_completed_orders          / NULLIF(total_sessions_reached_checkout, 0), 2)  as successful_payment_rate
FROM monthly_report_payment_method
ORDER BY months;
-- ============================================================


-- Funnel conversion rates by city
-- Rules out geography as the primary driver of the drop
WITH cities_report_march as(
	SELECT 
		city,
		FORMAT(order_date, 'yyyy-MM') as months,
		COUNT(*) as total_sessions,
		SUM(order_value) as total_revenue,
		SUM(CAST(added_to_cart AS INT)) as total_sessions_added_to_cart,
		SUM(CAST(started_checkout AS INT)) as total_sessions_reached_checkout,
		SUM(CAST(payment_success AS INT)) as total_completed_orders
	FROM orders
	WHERE FORMAT(order_date, 'yyyy-MM') = '2026-03'
	GROUP BY city, FORMAT(order_date, 'yyyy-MM')
)
SELECT
	city,
	months,
	total_revenue,
	ROUND(100.00*total_sessions_added_to_cart    / NULLIF(total_sessions, 0), 2)                   as added_to_cart_rate,
	ROUND(100.00*total_sessions_reached_checkout / NULLIF(total_sessions_added_to_cart, 0), 2)     as checkout_rate,
	ROUND(100.00*total_completed_orders          / NULLIF(total_sessions_reached_checkout, 0), 2)  as successful_payment_rate
FROM cities_report_march
ORDER BY months;
-- ============================================================


-- Funnel conversion rates by device for the cities with the most drop in conversion rate from the previous query
WITH cities_device_report_ as(
	SELECT 
		city,
		device_type,
		FORMAT(order_date, 'yyyy-MM') as months,
		COUNT(*) as total_sessions,
		SUM(order_value) as total_revenue,
		SUM(CAST(added_to_cart AS INT)) as total_sessions_added_to_cart,
		SUM(CAST(started_checkout AS INT)) as total_sessions_reached_checkout,
		SUM(CAST(payment_success AS INT)) as total_completed_orders
	FROM orders
	WHERE FORMAT(order_date, 'yyyy-MM') = '2026-03' AND city IN('Amman', 'Irbid')
	GROUP BY city,device_type , FORMAT(order_date, 'yyyy-MM')
)
SELECT
	city,
	device_type,
	months,
	total_revenue,
	ROUND(100.00*total_sessions_added_to_cart    / NULLIF(total_sessions, 0), 2)                   as added_to_cart_rate,
	ROUND(100.00*total_sessions_reached_checkout / NULLIF(total_sessions_added_to_cart, 0), 2)     as checkout_rate,
	ROUND(100.00*total_completed_orders          / NULLIF(total_sessions_reached_checkout, 0), 2)  as successful_payment_rate
FROM cities_device_report_
ORDER BY city;

