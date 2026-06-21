WITH RECURSIVE calendar AS (
    SELECT
        MIN(registered_at)::DATE AS date
    FROM users

    UNION ALL

    SELECT
        (date + INTERVAL '1 DAY')::DATE
    FROM calendar
    WHERE date <
          (
              SELECT MAX(registered_at)::DATE
              FROM users
          )
)
SELECT
    c.date,
    COUNT(u.id) AS sign_ups,
    ROUND(
        AVG(COUNT(u.id))
        OVER (
            ORDER BY c.date
            ROWS BETWEEN 7 PRECEDING
                     AND CURRENT ROW
        ),
        2
    ) AS avg_signups
FROM calendar c
LEFT JOIN users u
    ON c.date = u.registered_at::DATE
GROUP BY c.date
ORDER BY c.date;