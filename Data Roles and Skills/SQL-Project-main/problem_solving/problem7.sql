/*
 Find the count of the number of remote job postings per skill
 - Display the top 5 skills by their demand in remote jobs
 - Include skill ID, name, and count of postings requiring the skill
 */
WITH skill_count AS(
    SELECT sj.skill_id,
        COUNT(sj.job_id) job_counts
    FROM skills_job_dim sj
        JOIN job_postings_fact jps ON sj.job_id = jps.job_id
    WHERE jps.job_work_from_home = TRUE
    GROUP BY sj.skill_id
)
SELECT sc.skill_id,
    s.skills,
    sc.job_counts
FROM skill_count sc
    JOIN skills_dim s ON s.skill_id = sc.skill_id
ORDER BY job_counts DESC
LIMIT 5;