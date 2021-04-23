/*
1.
The first example shows the goal scored by a player with the last name 'Bender'. The * says to list all the columns in the table - a shorter way of saying matchid, teamid, player, gtime
Modify it to show the matchid and player name for all goals scored by Germany. To identify German players, check for: teamid = 'GER'
*/

SELECT matchid, player
FROM goal 
WHERE teamid LIKE 'GER';

-- SOLUTION 2

SELECT matchid, player
FROM goal 
WHERE teamid = 'GER';


/*
2.
From the previous query you can see that Lars Bender's scored a goal in game 1012. Now we want to know what teams were playing in that match.
Notice in the that the column matchid in the goal table corresponds to the id column in the game table. We can look up information about game 1012 by finding that row in the game table.
Show id, stadium, team1, team2 for just game 1012
*/

SELECT id,stadium,team1,team2
FROM game
WHERE id = 1012


/*
3.
You can combine the two steps into a single query with a JOIN.
SELECT *
  FROM game JOIN goal ON (id=matchid)
The FROM clause says to merge data from the goal table with that from the game table. The ON says how to figure out which rows in game go with which rows in goal - the matchid from goal must match id from game. (If we wanted to be more clear/specific we could say
ON (game.id=goal.matchid)
The code below shows the player (from the goal) and stadium name (from the game table) for every goal scored.
Modify it to show the player, teamid, stadium and mdate for every German goal.
*/

SELECT goal.player, goal.teamid, game.stadium, game.mdate 
FROM game JOIN goal ON (game.id = goal.matchid)
WHERE goal.teamid = 'GER'

-- player, teamid is from table 'goal'
-- stadium, mdate is from table 'game'
-- id = match are the sharing keys from each table 
-- teamid = 'GER' is from the table 'goal' where it shows every goal scored by german player 


/*
4.
Use the same JOIN as in the previous question.
Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'
*/

SELECT game.team1, game.team2, goal.player
FROM game JOIN goal ON (game.id = goal.matchid)
WHERE goal.player LIKE 'Mario%'

-- team1, team2, is from table 'game' 
-- player is from table 'goal'
-- 'Mario%', % is wild card, any term after Mario 
-- HENCE, it shows all goals scored by Mario in relation to team vs team columns


/*
5.
The table eteam gives details of every national team including the coach. You can JOIN goal to eteam using the phrase goal JOIN eteam on teamid=id
Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10
*/

SELECT goal.player, goal.teamid, eteam.coach, goal.gtime
FROM goal JOIN eteam ON (goal.teamid = eteam.id)
WHERE goal.gtime <= 10

-- player, teamid, gtime is from table: goal 
-- coach is from table: eteam


/*
6.
To JOIN game with eteam you could use either
game JOIN eteam ON (team1=eteam.id) or game JOIN eteam ON (team2=eteam.id)
Notice that because id is a column name in both game and eteam you must specify eteam.id instead of just id
List the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.
*/

SELECT game.mdate, eteam.teamname
FROM game JOIN eteam ON (game.team1 = eteam.id)
WHERE eteam.coach='Fernando Santos'

-- mdate is from table: game
-- teamname is from table: eteam


/*
7.
List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'
*/

SELECT player
FROM goal JOIN game ON (game.id = goal.matchid)
WHERE game.stadium = 'National Stadium, Warsaw';


/*
8.
The example query shows all goals scored in the Germany-Greece quarterfinal.
Instead show the name of all players who scored a goal against Germany.


Select goals scored only by non-German players in matches where GER was the id of either team1 or team2.
You can use teamid!='GER' to prevent listing German players.
You can use DISTINCT to stop players being listed twice.
*/

SELECT DISTINCT goal.player
FROM game JOIN goal ON (goal.matchid = game.id)
WHERE (game.team1 = 'GER' OR game.team2 = 'GER')
 AND goal.teamid!='GER'

-- teamid! = 'GER' means any goal NOT associated with Germany in the goals table, 
-- hence, this implicates goals scored against Germany in games where Germany was involved (team1 = 'GER' OR team2 = 'GER')


/*
9.
Show teamname and the total number of goals scored.
COUNT and GROUP BY
*/

SELECT eteam.teamname, COUNT(goal.teamid)
FROM eteam JOIN goal ON (eteam.id = goal.teamid)
GROUP BY eteam.teamname


/*
10.
Show the stadium and the number of goals scored in each stadium.
*/

SELECT game.stadium, COUNT(goal.teamid)
FROM goal JOIN game ON (game.id = goal.matchid)
GROUP BY stadium


/*
11.
For every match involving 'POL', show the matchid, date and the number of goals scored.
*/

SELECT goal.matchid, game.mdate, COUNT(goal.teamid)
FROM game JOIN goal ON (goal.matchid = game.id) 
WHERE (game.team1 = 'POL' OR game.team2 = 'POL')
 GROUP BY goal.matchid, game.mdate

-- GROUP BY clause normally used with aggregate functions lke COUNT, SUM, AVG, MAX, MIN. 
-- WHERE clause introduces a condition on individual rows; 
-- HAVING clause introduces a condition on aggregations
-- HAVING clause appears immediately after the GROUP BY clause

-- GROUP BY used only on the columns without the aggregate function  (excludes the COUNT)


/*
12.
For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'
*/

SELECT goal.matchid, game.mdate, COUNT(goal.teamid)
FROM game JOIN goal ON (goal.matchid = game.id)
WHERE (goal.teamid = 'GER')
 GROUP BY goal.matchid, game.mdate

-- GROUP BY used only on the columns without the aggregate function  (excludes the COUNT)

 /*
13.
List every match with the goals scored by each team as shown. This will use "CASE WHEN" which has not been explained in any previous exercises.
mdate	team1	score1	team2	score2
1 July 2012	ESP	4	ITA 	0
10 June 2012	ESP	1	ITA	1
10 June 2012	IRL	1	CRO	3
Notice in the query given every goal is listed. If it was a team1 goal then a 1 appears in score1, otherwise there is a 0. You could SUM this column to get a count of the goals scored by team1. Sort your result by mdate, matchid, team1 and team2. 
*/

SELECT game.mdate,
  game.team1,
  SUM(CASE WHEN goal.teamid = game.team1 THEN 1 ELSE 0 END) AS score1,

  game.team2,
  SUM(CASE WHEN goal.teamid = game.team2 THEN 1 ELSE 0 END) AS score2

FROM game LEFT JOIN goal ON (goal.matchid = game.id) 
GROUP BY game.mdate, goal.matchid, game.team1, game.team2

-- GROUP BY used only on the columns without the aggregate function  (excludes the two SUM columns)