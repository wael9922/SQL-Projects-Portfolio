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