/*
 Question: What skills are required for the top-paying data analyst jobs?
 - Use the top 10 highest-paying Data Analyst jobs from first query
 - Add the specific skills required for these roles
 - Why? It provides a detailed look at which high-paying jobs demand certain skills, 
 helping job seekers understand which skills to develop that align with top salaries
 */
WITH top_paying_jobs AS(
    SELECT job_id,
        job_title job,
        job_location location,
        job_schedule_type,
        salary_year_avg salary,
        job_posted_date
    FROM job_postings_fact
    WHERE job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_location = 'Anywhere'
    ORDER BY salary_year_avg DESC
    limit 10
)
SELECT tp.*,
    s.skills
FROM top_paying_jobs tp
    JOIN skills_job_dim sj ON tp.job_id = sj.job_id
    JOIN skills_dim s ON sj.skill_id = s.skill_id;