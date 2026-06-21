WITH challenges_count AS (
    SELECT
        h.hacker_id,
        h.name,
        COUNT(*) AS total_challenges
    FROM Hackers h
    JOIN Challenges c
        ON h.hacker_id = c.hacker_id
    GROUP BY h.hacker_id, h.name
),
ties AS (
    SELECT
        total_challenges,
        COUNT(*) AS hackers_count,
        CASE
            WHEN COUNT(*) > 1 THEN 1
            ELSE 0
        END AS has_ties
    FROM challenges_count
    GROUP BY total_challenges
)
SELECT
    cc.hacker_id,
    cc.name,
    cc.total_challenges
FROM challenges_count cc
JOIN ties t
    ON cc.total_challenges = t.total_challenges
WHERE
    has_ties = 0
    OR (
        has_ties = 1
        AND cc.total_challenges =
            (
                SELECT MAX(total_challenges)
                FROM challenges_count
            )
    )
ORDER BY
    cc.total_challenges DESC,
    cc.hacker_id;