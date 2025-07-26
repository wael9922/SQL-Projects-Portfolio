--Which year had the highest sales?
SELECT EXTRACT(
        YEAR
        FROM release_date
    ) AS years,
    sum(total_sales) AS copies_sold
FROM games
WHERE total_sales IS NOT NULL
    AND EXTRACT(
        YEAR
        FROM release_date
    ) IS NOT null
GROUP BY years
ORDER BY copies_sold DESC
LIMIT 1;
--Has the industry grown over time? 
WITH yearly_sales AS(
    SELECT EXTRACT(
            YEAR
            FROM release_date
        ) AS years,
        sum(total_sales) AS copies_sold
    FROM games
    WHERE total_sales IS NOT NULL
        AND EXTRACT(
            YEAR
            FROM release_date
        ) IS NOT null
    GROUP BY years
    ORDER BY years
)
SELECT years,
    copies_sold,
    lag(copies_sold) over(
        ORDER BY years
    ) AS last_year_copies_sold,
    round(
        (
            copies_sold - lag(copies_sold) over(
                ORDER BY years
            )
        ) / lag(copies_sold) over(
            ORDER BY years
        ) * 100,
        2
    ) AS yearly_growth
FROM yearly_sales;