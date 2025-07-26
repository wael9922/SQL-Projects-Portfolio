-- Which game sold the most worldwide?
SELECT title,
    console,
    genre,
    total_sales AS copies_sold,
    release_date
FROM games
WHERE total_sales = (
        SELECT MAX(total_sales)
        FROM games
    );
-- Which games sold the most worldwide?
SELECT title,
    max(total_sales) AS copies_sold
FROM games
WHERE total_sales IS NOT NULL
GROUP BY title
ORDER BY copies_sold desc
LIMIT 10;
-- Which game sold the most worldwide per console?
SELECT title,
    console,
    genre,
    copies_sold
FROM (
        SELECT title,
            console,
            genre,
            total_sales AS copies_sold,
            rank() OVER(
                PARTITION BY console
                ORDER BY total_sales DESC
            ) AS rank
        FROM games
        WHERE total_sales IS NOT NULL
    ) sales_per_console
WHERE RANK = 1;
-- Which games have the highest critic score?
SELECT title,
    AVG(critic_score) AS critic_score
FROM games
WHERE critic_score IS NOT null
GROUP BY title
ORDER BY critic_score DESC
LIMIT 10;
-- what is the average critic score for each title across all consoles?
SELECT title,
    AVG(critic_score) AS critic_score
FROM games
WHERE critic_score IS NOT null
GROUP BY title;