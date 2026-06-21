WITH trimester_averages AS (
    SELECT
        s.id AS student_id,
        s.name,

        ROUND(
            AVG(
                CASE
                    WHEN c.course_date BETWEEN '2022-10-01'
                                          AND '2022-12-31'
                    THEN c.score
                END
            ),
            2
        ) AS Michaelmas_avg,

        ROUND(
            AVG(
                CASE
                    WHEN c.course_date BETWEEN '2023-01-01'
                                          AND '2023-03-31'
                    THEN c.score
                END
            ),
            2
        ) AS Lent_avg,

        ROUND(
            AVG(
                CASE
                    WHEN c.course_date BETWEEN '2023-04-01'
                                          AND '2023-06-30'
                    THEN c.score
                END
            ),
            2
        ) AS Summer_avg

    FROM students s
    JOIN courses c
        ON s.id = c.student_id
    WHERE c.course_date BETWEEN '2022-10-01'
                            AND '2023-06-30'
    GROUP BY s.id, s.name
)
SELECT
    student_id,
    name,
    CONCAT(
        'Michaelmas (', Michaelmas_avg,
        '), Lent (', Lent_avg,
        '), Summer (', Summer_avg, ')'
    ) AS trimesters_avg_scores,

    CASE
        WHEN Lent_avg > Michaelmas_avg
         AND Summer_avg > Lent_avg
        THEN TRUE
        ELSE FALSE
    END AS consistent_improvement

FROM trimester_averages
ORDER BY student_id DESC;