SELECT * FROM netflix_titles

--1. How many total titles are available on Netflix?

SELECT COUNT(title) AS Total_titles FROM netflix_titles


--2. What is the distribution of Movies vs TV Shows?

SELECT type, COUNT(*) AS total_count FROM netflix_titles
GROUP BY type


--3. Which are the top 10 countries producing Netflix content?

SELECT country, COUNT(*) AS total_titles FROM netflix_titles
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_titles DESC
LIMIT 10


--4. Which content ratings are most common on Netflix?

SELECT rating, COUNT(*) AS total_titles FROM netflix_titles
WHERE rating IS NOT NULL
GROUP BY Rating
ORDER BY total_titles DESC


--5. How many titles were added to Netflix each year?

SELECT EXTRACT (YEAR FROM date_added) AS year_added, COUNT(*) AS total_titles FROM netflix_titles
WHERE Date_added IS NOT NULL
GROUP BY year_added
ORDER BY year_added DESC


--6. What are the top 10 longest movies on Netflix?

SELECT title, split_part(Duration, ' ', 1)::INT AS duration FROM netflix_titles
WHERE type = 'Movie'
ORDER BY Duration DESC
LIMIT 10


--7. Which directors have the most titles on Netflix?

SELECT director, COUNT(*) AS Total_titles FROM netflix_titles
GROUP BY director
ORDER BY Total_titles DESC


--8. Which genres dominate Netflix’s catalog?

SELECT UNNEST(string_to_array(listed_in, ', ')) AS genres, COUNT(*) AS total_titles FROM netflix_titles
GROUP BY genres
ORDER BY total_titles DESC


--9. How many Movies and TV Shows were released each year?

SELECT release_year, type, COUNT(*) AS total_titles FROM netflix_titles
GROUP BY release_year, type
ORDER BY release_year ASC


--10. Which actors appear most frequently on Netflix?

SELECT UNNEST(string_to_array(casts, ', ')) AS Actor, COUNT(*) AS Total_titles FROM netflix_titles
GROUP BY actor
ORDER BY Total_titles DESC


--11. How many titles are missing director information?

SELECT COUNT(*) AS missing_director_count FROM netflix_titles
WHERE director = 'Unknown'


--12. How has Netflix’s content grown year-over-year?

WITH yearly_content AS (
	SELECT EXTRACT(YEAR FROM date_added) AS Year, COUNT (*) AS total_titles FROM netflix_titles
	WHERE date_added IS NOT NULL
	GROUP BY Year
	ORDER BY year ASC)

SELECT year, total_titles, total_titles - LAG(total_titles) OVER (ORDER BY year) AS yoy_status FROM yearly_content


--13. Which country produces the most TV Shows?

SELECT UNNEST(string_to_array(country, ' ,')) AS Country, COUNT(*) AS total_TV_shows FROM netflix_titles
WHERE type = 'TV Show'
GROUP BY country
ORDER BY total_TV_shows DESC
LIMIT 1


--14. What percentage of Netflix content is Movies vs TV Shows?

SELECT type, ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),2) AS percentage_share FROM netflix_titles
GROUP BY type