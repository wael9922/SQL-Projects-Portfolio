WITH top_customers AS (
    SELECT
        customer_id,
        COUNT(rental_id) AS rentals_per_customer,
        COUNT(*) OVER() AS total_rentals,
        ROW_NUMBER() OVER (
            ORDER BY COUNT(rental_id) DESC
        ) AS rn
    FROM rental
    GROUP BY customer_id
),
top_20 AS (
    SELECT
        SUM(rentals_per_customer) AS total_top_20,
        (SELECT COUNT(*) FROM rental) AS total_rentals_count
    FROM top_customers
    WHERE rn <= CEIL(total_rentals * 0.2)
)
SELECT
    total_top_20::INT AS top_20_rentals_count,
    total_rentals_count,
    ROUND(
        (
            100.0 * total_top_20
            / total_rentals_count
        )::NUMERIC,
        2
    ) AS percentage_of_top_20
FROM top_20;