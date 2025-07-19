SELECT 
	customer_segment,
	SUM(total_ltv) AS revenue_per_segment
FROM(
WITH customer_ltv AS(
SELECT
	customerkey ,
	cleaned_name,
	SUM(total_revenue) AS total_ltv
FROM
	cohort_analysis
GROUP BY
	customerkey,
	cleaned_name
), customer_segment AS(
SELECT 
	PERCENTILE_CONT(0.25) within GROUP(ORDER BY total_ltv) AS ltv_25th_percentile,
	PERCENTILE_CONT(0.75) within GROUP(ORDER BY total_ltv) AS ltv_75th_percentile
FROM 
	customer_ltv
)
SELECT 
	customer_ltv.*,
	CASE 
		WHEN total_ltv< ltv_25th_percentile THEN '1- Low Value'
		WHEN total_ltv <= ltv_75th_percentile THEN '2- Mid Value'
		ELSE '3- High Value'
	END customer_segment
FROM
	customer_ltv,
	customer_segment)
GROUP BY customer_segment
ORDER BY customer_segment DESC