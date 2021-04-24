/*
1.
List the films where the yr is 1962 [Show id, title] 
*/

SELECT id, title
FROM movie
WHERE yr = 1962


/*
2.
Give year of 'Citizen Kane'
*/

SELECT yr
FROM movie
WHERE title = 'Citizen Kane'


/*
3.
List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year. 
*/

SELECT id, title, yr
FROM movie
WHERE title LIKE 'Star Trek%'
 ORDER BY yr

 
/*
4.
What id number does the actor 'Glenn Close' have? 
*/

SELECT id
FROM actor
WHERE name = 'Glenn Close'


/*
5.
What is the id of the film 'Casablanca' 
*/

SELECT id
FROM movie
WHERE title = 'Casablanca'


/*
6.
Obtain the cast list for 'Casablanca'.
what is a cast list? The cast list is the names of the actors who were in the movie.
Use movieid=11768, (or whatever value you got from the previous question) 
*/

SELECT actor.name
FROM actor JOIN casting ON (actor.id = casting.actorid)
WHERE casting.movieid = (SELECT id 
                         FROM movie
                         WHERE title = 'Casablanca')

-- Line 60 joins table actor to table casting 
-- Line 61 joins table casting to table movie 
-- Line 61 pulls the entire casting for the movie Casablanca


/*
7.
Obtain the cast list for the film 'Alien'  
*/

SELECT name
FROM movie 
 JOIN casting ON (movie.id = casting.movieid)
 JOIN actor ON (casting.actorid = actor.id)
WHERE movie.title = 'Alien'

-- Line 77, we join table movie to table casting
-- our table now is movie-casting, we then join table table-casting to table actor
-- table is now movie-casting-actor
-- Line 79 filters from our merged table for the title 'Alien'


-- SOLUTION 2
SELECT name
  FROM movie, casting, actor
  WHERE title='Alien'
    AND movieid=movie.id
    AND actorid=actor.id


/*
8.
List the films in which 'Harrison Ford' has appeared  
*/

SELECT title
FROM movie
 JOIN casting ON (movie.id = casting.movieid)
 JOIN actor ON (casting.actorid = actor.id)
WHERE actor.name = 'Harrison Ford'

-- The joined tables result in combined: movie-casting-actor
-- Line 104 filters from our merged table for the name 'Harrison Ford' from column actor 


-- SOLUTION 2 
SELECT title
FROM movie, casting, actor
WHERE name='Harrison Ford'
 AND movieid=movie.id
 AND actorid=actor.id


/*
9.
List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role] 
*/

SELECT title
FROM movie
 JOIN casting ON (movie.id = casting.movieid)
 JOIN actor ON (casting.actorid = actor.id)
WHERE actor.name = 'Harrison Ford'
 AND casting.ord != 1

 -- 1 in casting table indicates starring role. 
 -- Hence, != 1, means not in a starring role.


-- SOLUTION 2
SELECT title
FROM movie, casting, actor
 WHERE name='Harrison Ford'
    AND movieid = movie.id
    AND actorid = actor.id
    AND casting.ord <> 1


/*
10.
List the films together with the leading star for all 1962 films. 
*/

SELECT movie.title, actor.name
FROM movie
 JOIN casting ON (movie.id = casting.movieid)
 JOIN actor ON (casting.actorid = actor.id)
WHERE movie.yr = 1962
 AND casting.ord = 1


-- SOLUTION 2

SELECT title, name
FROM movie, casting, actor
 WHERE yr=1962
    AND movieid=movie.id
    AND actorid=actor.id
    AND ord=1


/*
11.
Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies. 
*/

SELECT movie.yr, COUNT(movie.title)
FROM movie
 JOIN casting ON (movie.id = casting.movieid)
 JOIN actor ON (casting.actorid = actor.id)
WHERE actor.name = 'Rock Hudson'
 GROUP BY movie.yr 
 HAVING COUNT(title) > 2

-- SOLUTION 2

SELECT yr, COUNT(title) FROM
  movie JOIN casting ON movie.id=movieid
        JOIN actor   ON actorid=actor.id
WHERE name = 'Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2

-- GROUP BY clause normally used with aggregate functions lke COUNT, SUM, AVG, MAX, MIN. 
-- WHERE clause introduces a condition on individual rows; 
-- HAVING clause introduces a condition on aggregations
-- HAVING clause appears immediately after the GROUP BY clause

-- GROUP BY used only on the columns without the aggregate function  (excludes the COUNT)


/*
12.
List the film title and the leading actor for all of the films 'Julie Andrews' played in.
Did you get "Little Miss Marker twice"?
*/

SELECT movie.title, actor.name
FROM movie
 JOIN casting ON (movie.id = casting.movieid)
 JOIN actor ON (casting.actorid = actor.id)
WHERE casting.ord = 1 
 AND casting.movieid IN (SELECT casting.movieid 
                         FROM casting
                         JOIN actor ON (casting.actorid = actor.id)
                         WHERE actor.name = 'Julie Andrews')

-- we need to compare a merged list vs (or in) another merged list
-- we have movie-casting-actor table, and we need to compare to casting-actor table. 
-- because the movie table cannot directly filter by the actor table, there's no tying link

-- SOLUTION 2

SELECT title, name
  FROM movie, casting, actor
  WHERE movieid=movie.id
    AND actorid=actor.id
    AND ord=1
    AND movieid IN
    (SELECT movieid FROM casting, actor
     WHERE actorid=actor.id
     AND name='Julie Andrews')


/*
13.
Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles. 
*/

SELECT actor.name
FROM casting JOIN actor ON (casting.actorid = actor.id)
WHERE casting.ord = 1
GROUP BY actor.name
 HAVING COUNT(casting.movieid) >= 15

-- GROUP BY clause normally used with aggregate functions lke COUNT, SUM, AVG, MAX, MIN. 
-- WHERE clause introduces a condition on individual rows; 
-- HAVING clause introduces a condition on aggregations
-- HAVING clause appears immediately after the GROUP BY clause

-- GROUP BY used only on the columns without the aggregate function  (excludes the COUNT)


-- SOLUTION 2
SELECT name
    FROM casting JOIN actor
      ON  actorid = actor.id
    WHERE ord=1
    GROUP BY name
    HAVING COUNT(movieid)>=15


/*
14.
List the films released in the year 1978 ordered by the number of actors in the cast, then by title. 
*/

SELECT movie.title, COUNT(casting.actorid)
FROM casting JOIN movie ON (casting.movieid = movie.id)
WHERE yr = 1978
GROUP BY title
 ORDER BY COUNT(casting.actorid) DESC, movie.title ASC


-- SOLUTION 2
  SELECT title, COUNT(actorid)
  FROM casting, movie                
  WHERE yr=1978
        AND movieid=movie.id
  GROUP BY title
  ORDER BY 2 DESC,1 ASC



/*
15.
List all the people who have worked with 'Art Garfunkel'. 
*/

SELECT DISTINCT actor.name
FROM movie
 JOIN casting ON (movie.id = casting.movieid)
 JOIN actor ON (casting.actorid = actor.id)
WHERE movie.id IN (SELECT movieid 
                   FROM casting 
                   JOIN actor ON (casting.actorid = actor.id)
                   WHERE actor.name = 'Art Garfunkel')
                    AND actor.name <> 'Art Garfunkel'

-- we need to compare a merged list vs (in) another merged list
-- we have movie-casting-actor table, and we need to compare to casting-actor table. 

-- SOLUTION 2
SELECT DISTINCT d.name
FROM actor d JOIN casting a ON (a.actorid=d.id)
   JOIN casting b on (a.movieid=b.movieid)
   JOIN actor c on (b.actorid=c.id 
                and c.name='Art Garfunkel')
  WHERE d.id!=c.id





