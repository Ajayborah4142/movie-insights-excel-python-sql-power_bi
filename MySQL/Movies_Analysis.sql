DROP DATABASE IF EXISTS Movies_db;
CREATE DATABASE Movies_db;

USE Movies_db;

DROP TABLE IF EXISTS movies;

CREATE TABLE movies (
title VARCHAR(100) ,
release_date DATE ,
original_language VARCHAR(100) ,
popularity FLOAT ,
vote_count INT ,
vote_average FLOAT ,
overview VARCHAR(700) 

);

SET GLOBAL LOCAL_INFILE=ON;
LOAD DATA LOCAL INFILE "C:/Users/Lenovo/OneDrive/Documents/Movies Analysis/Data/cleand_movies_dataset.csv"  INTO TABLE movies
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

-------------------------------------------------------------------------------------------------------------------------------------

#                                      1. Popularity & Audience Engagement

# Q.1) Which movies are the most popular based on the popularity score?

SELECT *
FROM
    movies
WHERE
    vote_average > 9;

# Q.2) What is the average popularity of movies released each year?

SELECT YEAR(release_date) AS Year , 
       ROUND(AVG(popularity),2) AS Avg_popularity
FROM movies
GROUP BY YEAR(release_date)
ORDER BY YEAR(release_date) DESC ; 

# Q.3) How does vote count affect popularity? (Correlation)

SELECT 
    (SUM(vote_count * popularity) - 
     (SUM(vote_count) * SUM(popularity)) / COUNT(*))
    /
    (SQRT(
        (SUM(vote_count * vote_count) - (SUM(vote_count) * SUM(vote_count)) / COUNT(*)) *
        (SUM(popularity * popularity) - (SUM(popularity) * SUM(popularity)) / COUNT(*))
    )) AS correlation
FROM movies;

# Q.4) Which movies got high popularity but low votes? (Indicates trending or new movies)

SELECT 
    title,
    popularity,
    vote_count
FROM movies
WHERE popularity > (SELECT AVG(popularity) FROM movies)
  AND vote_count < (SELECT AVG(vote_count) FROM movies)
ORDER BY popularity DESC, vote_count ASC;

#                                        2. Ratings & Reviews

# # Q.5) Which movies have the highest rating (vote_average)?

SELECT *
	  FROM movies
WHERE
    vote_average IN (SELECT 
            MAX(vote_average)
			FROM movies);

# Q.6) What is the average rating for each year or decade?

SELECT YEAR(release_date) AS Year,
       ROUND(AVG(vote_average),2) AS Avg_Rating
FROM movies 
GROUP BY YEAR(release_date)
ORDER BY YEAR(release_date) DESC 
LIMIT 123 OFFSET 2 ;

# Q.7) Which movies perform better: high rating but low popularity?

SELECT * 
        FROM movies 
WHERE vote_average IN (SELECT MAX(vote_average) FROM movies) AND 
                      (SELECT MIN(popularity) FROM movies ) ;

#                                3. Language-Based Insights

# Q.8) Which original languages produce the highest-rated movies?

SELECT original_language,
       ROUND(AVG(vote_average), 2) AS avg_vote_rating,
       COUNT(*) AS total_movies
FROM movies
GROUP BY original_language
HAVING total_movies > 5       -- optional: filter very small groups
ORDER BY avg_vote_rating DESC;

# Q.9) Which languages generate most total vote_count (large audience base)?

SELECT original_language,
       SUM(vote_count) AS Total_Vote 
FROM movies 
WHERE vote_count > (SELECT AVG(vote_count) FROM movies)
GROUP BY original_language
ORDER BY Total_Vote DESC ;

# Q.10) Are English-language movies more popular than others?

SELECT 
    CASE 
        WHEN original_language = 'English' THEN 'English'
        ELSE 'Non-English'
    END AS language_group,
    AVG(popularity) AS avg_popularity,
    COUNT(*) AS total_movies
FROM movies
GROUP BY language_group;




SELECT * FROM movies ;