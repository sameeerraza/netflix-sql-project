CREATE DATABASE NetflixMoviesData;

USE NetflixMoviesData;

-- Checking if data imported is complete or not
SELECT COUNT(*) AS total_content FROM netflix;

-- Renaming column header
EXEC sp_rename 'Netflix.type', 'show_type', 'COLUMN';


SELECT DISTINCT show_type FROM netflix;


SELECT * FROM netflix;


-- 1) Count the number of Movies vs TV Shows
SELECT show_type, COUNT(*) AS total_content
FROM netflix
GROUP BY show_type;


-- 2) Find the most common rating for movies and TV shows
SELECT show_type, rating, COUNT(*) as rating_count
FROM netflix
GROUP BY show_type, rating
ORDER BY rating_count DESC;

-- Approach 1
WITH movie as (
	SELECT TOP 1 show_type, rating, COUNT(*) AS rating_count
	FROM netflix
	WHERE show_type = 'Movie'
	GROUP BY show_type, rating
	ORDER BY rating_count DESC
	),
tv_show AS (
	SELECT TOP 1 show_type, rating, COUNT(*) AS rating_count
	FROM netflix
	WHERE show_type = 'TV Show'
	GROUP BY show_type, rating
	ORDER BY rating_count DESC
	)
SELECT m.show_type, m.rating, m.rating_count
FROM movie m
UNION
SELECT t.show_type, t.rating, t.rating_count
FROM tv_show t;


-- Approach 2
SELECT *
FROM (
	SELECT show_type, rating, COUNT(*) AS rating_count,
	RANK() OVER(PARTITION BY show_type ORDER BY COUNT(*) DESC) AS rank_num
	FROM netflix
	GROUP BY show_type, rating
	) AS t1
WHERE t1.rank_num = 1;


-- 3) List all movies released in a specific year (e.g., 2020)
SELECT title, date_added, release_year 
FROM netflix 
WHERE show_type = 'Movie' AND release_year = 2020;


-- 4) Find the top 5 countries with the most content on Netflix
SELECT 
	TOP 5 
	TRIM(value) AS distinct_countries, 
	COUNT(show_id) AS most_content
FROM 
	netflix
CROSS APPLY 
	STRING_SPLIT(country, ',')
GROUP BY 
	TRIM(value)
ORDER BY 
	most_content DESC;


-- 5. Identify the longest movie
SELECT
	TOP 1
	title,
	TRY_CAST(REPLACE(duration, ' min', '') AS INT) AS duration_in_minutes
FROM
	netflix
WHERE 
	show_type = 'Movie'
ORDER BY 
	duration_in_minutes DESC;


-- 6. Find content added in the last 5 years
SELECT 
	show_id, title, show_type, 
	date_added, release_year 
FROM 
	netflix
WHERE 
	TRY_CAST(date_added AS DATE) >= DATEADD(YEAR, -5, GETDATE());


-- 7. Find all the movies/TV shows by director 'Christopher Nolan'!
SELECT 
	show_id, 
	title, 
	show_type, 
	TRIM(value) AS distinct_director
FROM netflix
CROSS APPLY STRING_SPLIT(director, ',')
WHERE TRIM(value) = 'Christopher Nolan';


-- 8. List all TV shows with more than 5 seasons
WITH tv_shows AS ( 
	SELECT 
	show_id,
	title,
	TRY_CAST(REPLACE(REPLACE(duration, ' Seasons', ''), ' Season', '') AS INT) AS updated_duration
	FROM netflix
	WHERE show_type = 'TV Show'
	)
SELECT *
FROM tv_shows
WHERE updated_duration > 5;


-- 9. Count the number of content items in each genre
SELECT 
	TRIM(value) AS genre,
	COUNT(*) AS total_content
FROM netflix
CROSS APPLY STRING_SPLIT(listed_in, ',') AS distinct_genre
GROUP BY TRIM(value);


-- 10. Calculate the average number of content releases per month in the United States. Return the top 5 years with the highest averages.
SELECT TOP 5
    year_added,
    AVG(monthly_count) AS avg_releases
FROM (
    SELECT 
    YEAR(TRY_CAST(date_added AS DATE)) AS year_added,
    MONTH(TRY_CAST(date_added AS DATE)) AS month_added,
    COUNT(*) AS monthly_count
	FROM netflix
	WHERE country LIKE '%United States%'
	GROUP BY YEAR(TRY_CAST(date_added AS DATE)), MONTH(TRY_CAST(date_added AS DATE))
) AS monthly_data
GROUP BY year_added
ORDER BY avg_releases DESC;


-- 11. List all movies that are documentaries
-- approach 1
SELECT *
FROM netflix
WHERE listed_in LIKE '%Documentaries%';


-- approach 2
SELECT *
FROM netflix
CROSS APPLY STRING_SPLIT(listed_in, ',')
WHERE TRIM(value) = 'Documentaries';


-- 12. Find all content without a director
SELECT *
FROM netflix
WHERE director IS NULL OR LTRIM(RTRIM(director)) = '';


-- 13. Find how many movies actor 'Jackie Chan' appeared in last 10 years!
SELECT COUNT(*) AS total_movies
FROM netflix
WHERE show_type = 'Movie'
  AND casts LIKE '%Jackie Chan%'
  AND release_year >= YEAR(GETDATE()) - 10;


-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in United States.
SELECT TOP 10 
    TRIM(value) AS actor,
    COUNT(*) AS movie_count
FROM netflix
CROSS APPLY STRING_SPLIT(casts, ',')
WHERE country LIKE '%United States%'
GROUP BY TRIM(value)
ORDER BY movie_count DESC;


-- 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.
SELECT 
    CASE 
        WHEN LOWER(description) LIKE '%kill%' OR LOWER(description) LIKE '%violence%' THEN 'Bad'
        ELSE 'Good'
    END AS content_category,
    COUNT(*) AS total_count
FROM netflix
GROUP BY 
    CASE 
        WHEN LOWER(description) LIKE '%kill%' OR LOWER(description) LIKE '%violence%' THEN 'Bad'
        ELSE 'Good'
    END;
