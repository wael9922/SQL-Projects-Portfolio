--EDA
SELECT *
FROM games;
SELECT DISTINCT console
FROM games;
SELECT DISTINCT genre
FROM games;
SELECT count(*)
FROM games;
SELECT count(*),
	(
		SELECT count(*)
		FROM games
	),
	(
		SELECT count(*)
		FROM games
	) - count(*) AS sales_not_null
FROM games
WHERE total_sales IS null --Data Range
SELECT Min(release_date) start_of_range,
	MAX(release_date) end_of_range,
	AGE(MAX(release_date), Min(release_date))
FROM games;
-- Which game sold the most worldwide?
SELECT title,
	console,
	genre,
	total_sales AS copies_sold,
	release_date
FROM games
WHERE total_sales = (
		SELECT max(total_sales)
		FROM games
	);
---- Which titles sold the most worldwide?
SELECT title,
	max(total_sales) AS copies_sold
FROM games
WHERE total_sales IS NOT NULL
GROUP BY title
ORDER BY copies_sold desc
LIMIT 10;
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
--What titles are popular in one region but flop in another? 
-- for each console
WITH regions as(
	SELECT title,
		console,
		total_sales,
		COALESCE(round((na_sales * 1.0 / total_sales), 2), 0) north_america,
		COALESCE(round((jp_sales * 1.0 / total_sales), 2), 0) japan,
		COALESCE(round((pal_sales * 1.0 / total_sales), 2), 0) europe_africa,
		COALESCE(round((other_sales * 1.0 / total_sales), 2), 0) other
	FROM games
)
SELECT *,
	CASE
		WHEN north_america > japan
		AND north_america > europe_africa
		AND north_america > other THEN 'North America'
		WHEN japan > north_america
		AND japan > europe_africa
		AND japan > other THEN 'Japan'
		WHEN europe_africa > north_america
		AND europe_africa > japan
		AND europe_africa > other THEN 'Europe and Africa'
		ELSE 'Other Regions'
	END AS popular,
	CASE
		WHEN north_america < japan
		AND north_america < europe_africa
		AND north_america < other THEN 'North America'
		WHEN japan < north_america
		AND japan < europe_africa
		AND japan < other THEN 'Japan'
		WHEN europe_africa < north_america
		AND europe_africa < japan
		AND europe_africa < other THEN 'Europe and Africa'
		ELSE 'Other Regions'
	END AS not_popular
FROM regions;
--What titles are popular in one region but flop in another? 
-- for all consoles
WITH total_sales as(
	SELECT title,
		sum(total_sales) AS total_sales,
		sum(na_sales) AS na_sales,
		sum(jp_sales) AS jp_sales,
		sum(pal_sales) AS pal_sales,
		sum(other_sales) AS other_sales
	FROM games
	WHERE total_sales IS NOT NULL
	GROUP BY title
),
regions as(
	SELECT title,
		total_sales,
		COALESCE(round((na_sales * 1.0 / total_sales), 2), 0) north_america,
		COALESCE(round((jp_sales * 1.0 / total_sales), 2), 0) japan,
		COALESCE(round((pal_sales * 1.0 / total_sales), 2), 0) europe_africa,
		COALESCE(round((other_sales * 1.0 / total_sales), 2), 0) other
	FROM total_sales
	WHERE total_sales <> 0
)
SELECT *,
	CASE
		WHEN north_america > japan
		AND north_america > europe_africa
		AND north_america > other THEN 'North America'
		WHEN japan > north_america
		AND japan > europe_africa
		AND japan > other THEN 'Japan'
		WHEN europe_africa > north_america
		AND europe_africa > japan
		AND europe_africa > other THEN 'Europe and Africa'
		ELSE 'Other Regions'
	END AS popular,
	CASE
		WHEN north_america < japan
		AND north_america < europe_africa
		AND north_america < other THEN 'North America'
		WHEN japan < north_america
		AND japan < europe_africa
		AND japan < other THEN 'Japan'
		WHEN europe_africa < north_america
		AND europe_africa < japan
		AND europe_africa < other THEN 'Europe and Africa'
		ELSE 'Other Regions'
	END AS not_popular
FROM regions
ORDER BY total_sales desc;
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
-- what is the average critic score for each title across all consoles?
SELECT title,
	AVG(critic_score) AS critic_score
FROM games
WHERE critic_score IS NOT null
GROUP BY title;
-- Which titles have the highest critic score?
SELECT title,
	AVG(critic_score) AS critic_score
FROM games
WHERE critic_score IS NOT null
GROUP BY title
ORDER BY critic_score DESC
LIMIT 10;
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