/*
 Question: What are the top-paying data analyst jobs?
 - Identify the top 10 highest-paying Data Analyst roles that are available remotely
 - Focuses on job postings with specified salaries (remove nulls)
 - BONUS: Include company names of top 10 roles
 - Why? Highlight the top-paying opportunities for Data Analysts, offering insights into employment options and location flexibility.
 */
SELECT job_id,
    job_title job,
    name as company_name,
    job_location location,
    job_schedule_type,
    salary_year_avg salary,
    job_posted_date
FROM job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_location = 'Anywhere'
ORDER BY salary_year_avg DESC
limit 10