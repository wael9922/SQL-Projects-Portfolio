--Do any consoles seem to specialize in a particular genre?
WITH game_count as(
    SELECT console,
        genre,
        count(*) AS games_count
    FROM games
    GROUP BY console,
        genre
    ORDER BY console,
        games_count desc
),
genres as(
    SELECT *,
        RANK() OVER(
            PARTITION BY console
            ORDER BY games_count desc
        ) AS rank
    FROM game_count
),
console_count as(
    SELECT console,
        count(*) total_games
    FROM games
    GROUP BY console
)
SELECT g.console,
    g.genre,
    g.games_count,
    ROUND(g.games_count * 100.0 / cc.total_games, 2) AS genre_percentage
FROM genres g
    JOIN console_count cc ON g.console = cc.console
WHERE RANK = 1
    AND ROUND(g.games_count * 100.0 / cc.total_games, 2) > 50;
--Which genre had sold the most?
SELECT genre,
    sum(total_sales) AS copies_sold
FROM games
GROUP BY genre
ORDER BY copies_sold DESC
LIMIT 10;
--Which genre had sold the most?
SELECT genre,
    sum(total_sales) AS copies_sold
FROM games
GROUP BY genre
ORDER BY copies_sold DESC
LIMIT 10;
--Which genre had sold the most?
SELECT genre,
    sum(total_sales) AS copies_sold
FROM games
GROUP BY genre
ORDER BY copies_sold DESC
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
-- Which consoles are the most popular?
SELECT console,
    sum(total_sales) copies_sold,
    count(*) AS games_count
FROM games
WHERE total_sales IS NOT NULL
GROUP BY console
ORDER BY copies_sold DESC,
    games_count DESC
LIMIT 5;