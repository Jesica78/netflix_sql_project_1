# Netflix Movies and TV Shows Data Analysis using SQL

![Netflix Logo](https://github.com/Jesica78/netflix_sql_project_1/blob/main/netflix%20212.jpg)

##Overview

 This project is focused on analyzing the Netflix Movies and TV Shows dataset using SQL.
The dataset includes details such as title, director, cast, country, release year, rating, and duration.
By applying SQL queries, the project extracts valuable insights about the type, distribution, and trends of Netflix content.

Objectives

* Analyze the distribution of content types (Movies vs TV Shows)
* Identify the most common ratings for Movies and TV Shows
* List and analyze content based on release year, country, and duration
* Explore and categorize content based on specific criteria and keywords

DataSet 
The data for this project is sourced from the Kaggle dataset.
* Dataset Link: https://www.kaggle.com/datasets/shivamb/netflix-shows.

## 📌 Schema

```sql
DROP TABLE IF EXISTS netflix;

CREATE TABLE netflix (
    show_id       VARCHAR(5),
    type          VARCHAR(10),
    title         VARCHAR(250),
    director      VARCHAR(550),
    casts         VARCHAR(1050),
    country       VARCHAR(550),
    date_added    VARCHAR(55),
    release_year  INT,
    rating        VARCHAR(15),
    duration      VARCHAR(15),
    listed_in     VARCHAR(250),
    description   VARCHAR(550)
);


Business Problems and Solutions

#  Netflix SQL Case Study  

## 1️⃣ Count the number of Movies vs TV Shows
```sql
SELECT 
    type,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1;

## 2️⃣ Most common rating for Movies and TV Shows
SELECT 
    type,
    rating
FROM (
    SELECT
        type,
        rating,
        COUNT(*) AS cnt,
        RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
    FROM netflix
    GROUP BY 1, 2
) AS t1
WHERE ranking = 1;

##3️⃣ List all Movies released in a specific year (e.g., 2020)
SELECT *
FROM netflix
WHERE type = 'Movie'
  AND release_year = 2020;

##4️⃣ Top 5 countries with the most content on Netflix
SELECT
    UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
    COUNT(show_id) AS total_content
FROM netflix 
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 5;

##5️⃣ Identify the longest Movie
SELECT *
FROM netflix
WHERE type = 'Movie'
  AND duration = (
      SELECT MAX(duration)
      FROM netflix
      WHERE type = 'Movie'
  );
##6️⃣ Content added in the last 5 years
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month,DD,YYYY') >= CURRENT_DATE - INTERVAL '5 years';

##7️⃣ All Movies/TV Shows by director 'Rajiv Chilaka'
SELECT *
FROM netflix  
WHERE director = 'Rajiv Chilaka';

##8️⃣ TV Shows with more than 5 seasons
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::NUMERIC > 5;

##9️⃣ Number of content items in each genre
SELECT
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1;

##🔟 Yearly content release in India (Top 5 Years with highest avg %)
Total Content: 333/972
SELECT
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month,DD,YYYY')) AS year,
    COUNT(*) AS yearly_content,
    ROUND(
        COUNT(*)::NUMERIC /
        (SELECT COUNT(*) FROM netflix WHERE country = 'India')::NUMERIC * 100, 2
    ) AS avg_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY yearly_content DESC
LIMIT 5;

##1️⃣1️⃣ List all Movies that are Documentaries
SELECT *
FROM netflix
WHERE listed_in ILIKE '%Documentaries%';

##1️⃣2️⃣ Find all content without a director
SELECT *
FROM netflix
WHERE director IS NULL;

1️⃣3️⃣ Movies actor 'Salman Khan' appeared in (last 10 years)
SELECT *
FROM netflix
WHERE casts ILIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

##1️⃣4️⃣ Top 10 actors in Indian Movies
SELECT
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*) AS total_content
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

##1️⃣5️⃣ Categorize content based on keywords ('kill' / 'violence')
WITH new_table AS (
    SELECT *,
           CASE 
               WHEN description ILIKE '%kill%' OR description ILIKE '%violence%'
                    THEN 'Bad_content'
               ELSE 'Good_content'
           END AS category
    FROM netflix
)
SELECT 
    category,
    COUNT(*) AS total_content
FROM new_table
GROUP BY 1;














