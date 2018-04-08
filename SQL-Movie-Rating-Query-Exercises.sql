/*
DB5-SQL-Stanford-Lagunita
SQL-Movie-Rating-Query-Exercises.sql
https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_movie_query_core/
*/

-- Q1
-- Find the titles of all movies directed by Steven Spielberg. 

SELECT title
FROM movie
WHERE director = 'Steven Spielberg'

-- Q2
-- Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. 

SELECT DISTINCT m.year
FROM (SELECT mID
        FROM rating
       WHERE stars = 4
          OR stars = 5) t
INNER JOIN movie m
ON m.mID = t.mID
ORDER BY 1 ASC;

-- Q3
-- Find the titles of all movies that have no ratings. 

SELECT m.title
FROM movie m
WHERE m.mID NOT IN (SELECT r.mID
                      FROM Rating r)
                      
-- Q4
-- Some reviewers didn't provide a date with their rating. 
-- Find the names of all reviewers who have ratings with a NULL value for the date. 

SELECT r.name
FROM
    (SELECT DISTINCT rID AS "rID"
       FROM Rating
      WHERE ratingDate IS NULL) t     
INNER JOIN reviewer r
ON t.rID = r.rID

-- Q5
-- Write a query to return the ratings data in a more readable format: 
-- reviewer name, movie title, stars, and ratingDate. Also, sort the data, 
-- first by reviewer name, then by movie title, and lastly by number of stars. 

SELECT rev.name, 
       mov.title, 
       rat.stars,
       rat.ratingDate
  FROM rating rat
  JOIN Reviewer rev
    ON rat.rID = rev.rID
  JOIN Movie mov
    ON rat.mID = mov.mID
 ORDER BY 1,2,3;
 
-- Q6
-- For all cases where the same reviewer rated the same movie twice 
-- and gave it a higher rating the second time, return the reviewer's 
-- name and the title of the movie. 

SELECT rev.name, m.title
FROM Rating r1
JOIN Rating r2
ON (r1.rID = r2.rID
   AND
   r2.mID = r1.mID
   AND
   r2.ratingDate > r1.ratingDate
   AND
   r2.stars > r1.stars)
JOIN Movie m
  ON m.mID = r1.mID
JOIN Reviewer rev
  ON rev.rID = r1.rID;
  
-- Q7
-- For each movie that has at least one rating, find the highest number 
-- of stars that movie received. Return the movie title and number of 
-- stars. Sort by movie title. 

SELECT m.title,
       t.max_stars
FROM (SELECT r.mID, 
       MAX(r.stars) AS max_stars
      FROM Rating r
      WHERE r.stars IS NOT NULL
      GROUP BY r.mID) t
JOIN movie m
ON t.mID = m.mID
ORDER BY m.title;

-- Q8
-- For each movie, return the title and the 'rating spread', that is, 
-- the difference between highest and lowest ratings given to that movie. 
-- Sort by rating spread from highest to lowest, then by movie title. 

SELECT m.title, t.spread
FROM (SELECT mID, Max(stars) - Min(stars) As spread
FROM rating
GROUP BY mID) t
JOIN movie m
ON t.mID = m.mID
ORDER BY 2 DESC, 1;

-- Q9
-- Find the difference between the average rating of movies released before 1980 and 
-- the average rating of movies released after 1980. (Make sure to calculate the 
-- average rating for each movie, then the average of those averages for movies before 
-- 1980 and movies after. Don't just calculate the overall average rating before and after 1980.)

SELECT AVG(CASE WHEN m.year < 1980 THEN t.score END)
       - AVG(CASE WHEN m.year > 1980 THEN t.score END)
FROM (SELECT mID, AVG(stars) AS score
        FROM rating r
       GROUP BY mID) t
JOIN movie m
ON t.mID = m.mID;
