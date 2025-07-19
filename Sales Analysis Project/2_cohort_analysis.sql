SELECT cohort_year,
    SUM(total_revenue) AS total_revenue,
    COUNT(DISTINCT customerkey) total_customers,
    SUM(total_revenue) / COUNT(DISTINCT customerkey) customer_revenue
FROM cohort_analysis
WHERE orderdate = first_purchase_date
GROUP BY cohort_year
ORDER BY cohort_year