/*
DB5-SQL-Stanford-Lagunita
SQL-Movie-Rating-Query-Exercises.sql
https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_movie_query_extra/

Tables & Schema:

Movie ( mID, title, year, director ) 
English: There is a movie with ID number mID, a title, a release year, and a director. 

Reviewer ( rID, name ) 
English: The reviewer with ID number rID has a certain name. 

Rating ( rID, mID, stars, ratingDate ) 
English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate. 
*/

-- Q1
-- Find the names of all reviewers who rated Gone with the Wind. 

SELECT rev.name
FROM reviewer rev
JOIN (SELECT DISTINCT r.rID
        FROM Rating r
       WHERE r.mID = (SELECT m.mID
                        FROM movie m
                       WHERE m.title = 'Gone with the Wind')
      ) t
ON rev.rID = t.rID;

-- Q2
-- For any rating where the reviewer is the same as the director of the movie, 
-- return the reviewer name, movie title, and number of stars. 

SELECT rev.name, 
       mov.title, 
       rat.stars
FROM rating rat
JOIN reviewer rev
ON rat.rID = rev.rID
JOIN movie mov
ON rat.mID = mov.mID
WHERE rev.name = mov.director
;

-- Q3
-- Return all reviewer names and movie names together in a single list, alphabetized. 
-- (Sorting by the first name of the reviewer and first word in the title is fine;
-- no need for special processing on last names or removing "The".) 

SELECT name FROM reviewer
UNION ALL
SELECT title FROM movie
ORDER BY name ASC;

-- Q4
-- Find the titles of all movies not reviewed by Chris Jackson. 
SELECT movie.title
  FROM movie
 WHERE mID NOT IN (SELECT DISTINCT mID
                     FROM rating
                    WHERE rID = (SELECT rID
                                   FROM Reviewer 
                                  WHERE name = 'Chris Jackson'))
 ORDER BY 1;
 
 
 -- Q5
 -- For all pairs of reviewers such that both reviewers gave a rating 
 -- to the same movie, return the names of both reviewers. Eliminate duplicates,
 -- don't pair reviewers with themselves, and include each pair only once. 
 -- For each pair, return the names in the pair in alphabetical order. 

SELECT DISTINCT rev1.name, rev2.name
  FROM Rating rat1,
       Rating rat2, 
       Reviewer rev1,
       Reviewer rev2
 WHERE rat1.rid = rev1.rid
   AND rat2.rid = rev2.rid
   AND rat1.mid = rat2.mid
   AND rev1.name < rev2.name;
