SELECT * FROM netflix;

SELECT 
   COUNT(*) as total_content
FROM netflix;   
SELECT 
    DISTINCT type
FROM netflix;	

--15  BUsiness Problem

-- 1. Count the number of Movies vs Tv Shows

SELECT 
    type,
	Count(*)as total_content
FROM netflix
GROUP BY type

--2. find the most common rating for movies and tv shows
SELECT 
     type,
	 rating
FROM
(
    SELECT
	    type,
		rating,
		COUNT(*),
		RANK() OVER (PARTITION BY type ORDER BY COUNT(*)DESC)as ranking
		FROM netflix
		GROUP BY 1,2
) as t1
WHERE 
    ranking=1

--3. list all movies relaesed in a specific year (e.g ,2020)
-- filter 2020
--movies
SELECT * FROM netflix
WHERE 
    type = 'Movie'
	AND
    release_year = 2020

--4. find the top 5 countries with the most content on netflix

SELECT
      UNNEST(STRING_TO_ARRAY(country,',')) as new_country,
      Count(show_id)as total_countent	
FROM netflix 
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 5

--5.Identify the larget movie??
SELECT * FROM netflix
WHERE 
    type = 'Movie'
	AND
	duration = (SELECT MAX (duration)FROM netflix)


--6. find content added in the last 5 years
SELECT
    *
FROM netflix
WHERE
    To_Date(date_added,'Month,DD,YYYY')>= CURRENT_DATE - INTERVAL '5years'

----7. find all movie / tv by director'Rajiv Chilaka'!
SELECT * FROM netflix  
WHERE  director = 'Rajiv Chilaka'


--8.list all the tv shows with more than 5 seasons
SELECT
    *
FROM netflix
WHERE 
    type = 'TV Show'
	AND
    SPLIT_PART(duration,' ',1)::numeric >5

--9.count the number of content iteams in each genre
SELECT
    UNNEST(STRING_TO_ARRAY(listed_in,','))as genre,
	Count(show_id)as total_content
FROM netflix
GROUP BY 1

--10. find the each year and the average number of content relasse in india
 on netflix . return top 5 year with highest avg content relase:

total content 333/972
SELECT
    EXTRACT(YEAR FROM TO_DATE(date_added,'Month,DD,YYYY')) as year,
	Count(*) as yearly_content ,
	ROUND(Count(*)::numeric/(SELECT COUNT(*)FROM netflix WHERE country = 'India')::numeric*100
	,2)as avg_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY 1

--11. list all movies that are documentaries
SELECT * FROM netflix
WHERE
listed_in Ilike '%documentaries%'


-12. find all content without a director
SELECT * FROM netflix
WHERE
   director is NULL

---13.find how many movies actor 'Salman Khan'appeared in last 10 years!
SELECT * FROM netflix
WHERE
 casts ILIKE'%Salman khan%'
 AND
 release_year> Extract(YEAR FROM CURRENT_DATE) - 10

--14. Find the top 10 actors who have appeared in the highest number of movies product in
India.
SELECT
UNNEST(STRING_TO_ARRAY(casts,',')) as actor,
COUNT(*)as total_content
FROM netflix
WHERE country ILIKE'%india'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10


15.categorize the content based on the presence of the keywords 'kill' and 'violence' in
the description field.Label content containing these keywords as 'BAD ' and all other 
content as 'good'count how many iteams fall into each category.

WITH new_table
AS
(
SELECT
*,
  CASE 
  WHEN description ILIKE'%kill%' OR 
       description ILIKE'%violence%' THEN 'Bad_content'
	   ELSE 'Good content'
  END category	   
FROM netflix
)
SELECT 
    category,
	COUNT(*) as total_content
FROM new_table
GROUP BY 1















	