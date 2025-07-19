-- My approach to find the number of acitve and churned customers
SELECT customer_status,
	COUNT(customer_status)
FROM(
		SELECT customerkey,
			cleaned_name,
			MAX(orderdate) AS last_purchase,
			CASE
				WHEN MAX(orderdate) >= (
					SELECT MAX(orderdate)
					FROM sales
				) - INTERVAL '6 MONTHS' THEN 'Active'
				ELSE 'Churned'
			END customer_status
		FROM cohort_analysis
		GROUP BY customerkey,
			cleaned_name
	)
GROUP BY customer_status -- -- My approach to find the number of acitve and churned customers based on cohort year
	WITH customer_status_summary AS (
		SELECT customerkey,
			cleaned_name,
			cohort_year,
			first_purchase_date,
			MAX(orderdate) AS last_purchase_date,
			CASE
				WHEN MAX(orderdate) >= (
					SELECT MAX(orderdate)
					FROM sales
				) - INTERVAL '6 months' THEN 'Active'
				ELSE 'Churned'
			END AS customer_status
		FROM cohort_analysis
		WHERE first_purchase_date < (
				SELECT MAX(orderdate)
				FROM sales
			) - INTERVAL '6 months'
		GROUP BY customerkey,
			cleaned_name,
			cohort_year,
			first_purchase_date
	)
SELECT cohort_year,
	customer_status,
	COUNT(customerkey) AS num_customers,
	SUM(COUNT(customerkey)) OVER(PARTITION BY cohort_year) AS total_customers,
	ROUND(
		COUNT(customerkey) * 100.0 / SUM(COUNT(customerkey)) OVER(PARTITION BY cohort_year),
		2
	) AS status_percentage
FROM customer_status_summary
GROUP BY cohort_year,
	customer_status
ORDER BY cohort_year,
	customer_status;
-- the guided approach
WITH customer_status_summary AS (
	SELECT customerkey,
		cleaned_name,
		cohort_year,
		first_purchase_date,
		MAX(orderdate) AS last_purchase_date,
		CASE
			WHEN MAX(orderdate) >= (
				SELECT MAX(orderdate)
				FROM sales
			) - INTERVAL '6 months' THEN 'Active'
			ELSE 'Churned'
		END AS customer_status
	FROM cohort_analysis
	WHERE first_purchase_date < (
			SELECT MAX(orderdate)
			FROM sales
		) - INTERVAL '6 months'
	GROUP BY customerkey,
		cleaned_name,
		cohort_year,
		first_purchase_date
)
SELECT cohort_year,
	customer_status,
	COUNT(customerkey) AS num_customers,
	SUM(COUNT(customerkey)) OVER(PARTITION BY cohort_year) AS total_customers,
	ROUND(
		COUNT(customerkey) * 100.0 / SUM(COUNT(customerkey)) OVER(PARTITION BY cohort_year),
		2
	) AS status_percentage
FROM customer_status_summary
GROUP BY cohort_year,
	customer_status
ORDER BY cohort_year,
	customer_status;