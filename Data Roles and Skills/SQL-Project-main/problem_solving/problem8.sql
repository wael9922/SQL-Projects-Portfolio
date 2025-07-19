/*
 Find job postings from the first quarter that have a salary greater than $70K
 - Combine job posting tables from the first quarter of 2023 (Jan-Mar)
 - Gets job postings with an average yearly salary > $70,000 
 - Filter for Data Analyst Jobs and order by salary
 */
-- My own approach
SELECT job_title_short,
    job_location,
    job_via,
    job_posted_date::DATE
FROM job_postings_fact
WHERE EXTRACT(
        MONTH
        FROM job_posted_date
    ) < 4
    AND EXTRACT(
        YEAR
        FROM job_posted_date
    ) = 2023
    AND salary_year_avg > 70000
    AND job_title_short = 'Data Analyst'
ORDER BY salary_year_avg DESC;
-- Course Guided approach
SELECT job_title_short,
    job_location,
    job_via,
    job_posted_date::DATE,
    salary_year_avg
FROM (
        SELECT *
        FROM january_jobs
        UNION ALL
        SELECT *
        FROM february_jobs
        UNION ALL
        SELECT *
        FROM march_jobs
    ) AS quarter1_job_postings
WHERE salary_year_avg > 70000
    AND job_title_short = 'Data Analyst'
ORDER BY salary_year_avg DESC