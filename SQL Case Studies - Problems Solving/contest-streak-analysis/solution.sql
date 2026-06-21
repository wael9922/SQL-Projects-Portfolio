WITH hackes_streak AS (
    SELECT
        submission_date,
        hacker_id,
        (
            SELECT COUNT(DISTINCT ss.submission_date)
            FROM Submissions ss
            WHERE ss.hacker_id = s.hacker_id
              AND ss.submission_date BETWEEN '2016-03-01'
                                         AND s.submission_date
        ) AS streak,
        DAY(submission_date) AS contest_day
    FROM Submissions s
),
daily_count AS (
    SELECT
        submission_date,
        COUNT(DISTINCT hacker_id) AS total_hackers
    FROM hackes_streak
    WHERE streak = contest_day
    GROUP BY submission_date
),
daily_hacker_submissions_count AS (
    SELECT
        submission_date,
        hacker_id,
        COUNT(submission_id) AS total_submissions,
        ROW_NUMBER() OVER (
            PARTITION BY submission_date
            ORDER BY COUNT(*) DESC, hacker_id
        ) AS rn
    FROM Submissions
    GROUP BY submission_date, hacker_id
),
maximum_submissions_hackers AS (
    SELECT
        submission_date,
        h.hacker_id,
        h.name
    FROM daily_hacker_submissions_count ds
    JOIN Hackers h
        ON ds.hacker_id = h.hacker_id
    WHERE ds.rn = 1
)
SELECT
    dc.*,
    ms.hacker_id,
    ms.name
FROM daily_count dc
JOIN maximum_submissions_hackers ms
    ON dc.submission_date = ms.submission_date
ORDER BY dc.submission_date;