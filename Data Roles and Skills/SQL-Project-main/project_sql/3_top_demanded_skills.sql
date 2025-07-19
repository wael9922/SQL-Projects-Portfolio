/*
 Question: What are the most in-demand skills for data analysts?
 - Join job postings to inner join table similar to query 2
 - Identify the top 5 in-demand skills for a data analyst.
 - Focus on all job postings.
 - Why? Retrieves the top 5 skills with the highest demand in the job market, 
 providing insights into the most valuable skills for job seekers.
 */
SELECT s.skills,
    COUNT(jps.job_id) job_counts
FROM job_postings_fact jps
    JOIN skills_job_dim sj ON jps.job_id = sj.job_id
    JOIN skills_dim s ON s.skill_id = sj.skill_id
WHERE jps.job_title_short = 'Data Analyst'
    AND job_work_from_home = True
GROUP BY s.skills
ORDER BY job_counts DESC
LIMIT 5