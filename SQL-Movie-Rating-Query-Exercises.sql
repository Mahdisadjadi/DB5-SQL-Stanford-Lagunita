/*
DB5-SQL-Stanford-Lagunita
SQL-Movie-Rating-Query-Exercises.sql
https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_movie_query_core/
*/

-- Q1

SELECT title
FROM movie
WHERE director = 'Steven Spielberg'

-- Q2

SELECT DISTINCT m.year
FROM (SELECT mID
        FROM rating
       WHERE stars = 4
          OR stars = 5) t
INNER JOIN movie m
ON m.mID = t.mID
ORDER BY 1 ASC;

-- Q3

SELECT m.title
FROM movie m
WHERE m.mID NOT IN (SELECT r.mID
                      FROM Rating r)
                      
-- Q4

SELECT r.name
FROM
    (SELECT DISTINCT rID AS "rID"
       FROM Rating
      WHERE ratingDate IS NULL) t     
INNER JOIN reviewer r
ON t.rID = r.rID

-- Q5

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

SELECT m.title, t.spread
FROM (SELECT mID, Max(stars) - Min(stars) As spread
FROM rating
GROUP BY mID) t
JOIN movie m
ON t.mID = m.mID
ORDER BY 2 DESC, 1;

-- Q9

SELECT AVG(CASE WHEN m.year < 1980 THEN t.score END)
       - AVG(CASE WHEN m.year > 1980 THEN t.score END)
FROM (SELECT mID, AVG(stars) AS score
        FROM rating r
       GROUP BY mID) t
JOIN movie m
ON t.mID = m.mID;
