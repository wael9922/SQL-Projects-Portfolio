/*
 Answer: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill)?
 - Identify skills in high demand and associated with high average salaries for Data Analyst roles
 - Concentrates on remote positions with specified salaries
 - Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), 
 offering strategic insights for career development in data analysis
 */
SELECT s.skills,
    COUNT(jps.job_id) job_counts,
    ROUND(AVG(jps.salary_year_avg), 0) as average_salary
FROM job_postings_fact jps
    JOIN skills_job_dim sj ON jps.job_id = sj.job_id
    JOIN skills_dim s ON s.skill_id = sj.skill_id
WHERE jps.job_title_short = 'Data Analyst'
    AND job_work_from_home = True
    AND jps.salary_year_avg IS NOT NULL
GROUP BY s.skills
HAVING COUNT(jps.job_id) > 10
ORDER BY job_counts DESC,
    average_salary DESC
LIMIT 25;