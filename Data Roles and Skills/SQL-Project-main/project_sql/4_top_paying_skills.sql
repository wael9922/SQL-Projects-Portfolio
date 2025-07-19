SELECT s.skills,
    ROUND(AVG(jps.salary_year_avg), 0) as average_salary
FROM job_postings_fact jps
    JOIN skills_job_dim sj ON jps.job_id = sj.job_id
    JOIN skills_dim s ON s.skill_id = sj.skill_id
WHERE jps.job_title_short = 'Data Analyst' --   AND job_work_from_home = True
    AND jps.salary_year_avg IS NOT NULL
GROUP BY s.skills
ORDER BY average_salary DESC
LIMIT 25