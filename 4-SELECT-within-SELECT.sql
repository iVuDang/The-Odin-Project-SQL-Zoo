/*
1.
List each country name where the population is larger than that of 'Russia'.
world(name, continent, area, population, gdp)
*/

SELECT name
FROM world 
WHERE population > (SELECT population
                    FROM world
                    WHERE name = 'Russia');


/*
2.
Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.
Per Capita GDP
*/

SELECT name 
FROM world
WHERE continent = 'Europe'
 AND gdp/population > (SELECT gdp/population 
                       FROM world
                       WHERE name = 'United Kingdom'); 


/*
3.
List the name and continent of countries in the continents containing either Argentina or Australia. Order by name of the country.
*/

SELECT name, continent
FROM world
WHERE continent IN (SELECT continent
                    FROM world 
                    WHERE name IN ('Australia', 'Argentina'))
ORDER BY name;


/*
4.
Which country has a population that is more than Canada but less than Poland? Show the name and the population.
*/

SELECT name, population
FROM world 
WHERE population BETWEEN (SELECT population+1
                          FROM world 
                          WHERE name = 'Canada')
                 AND (SELECT population-1
                      FROM world 
                      WHERE name = 'Poland');


/*
5.
Germany (population 80 million) has the largest population of the countries in Europe. Austria (population 8.5 million) has 11% of the population of Germany.
Show the name and the population of each country in Europe. Show the population as a percentage of the population of Germany.
*/

SELECT name, CONCAT(CAST(ROUND(100*population/(SELECT population 
                                                FROM world 
                                                WHERE name = 'Germany'), 0) 
                                                AS int), '%')
FROM world
WHERE continent = 'Europe';

-- CONCAT() // adds two strings together '' and '%' 
-- CAST('' AS int) // converts a value to an int datatype
-- ROUND (, 0) // zero decimal places


/*
6.
Which countries have a GDP greater than every country in Europe? [Give the name only.] (Some countries may have NULL gdp values) 
*/

SELECT name 
FROM world 
  WHERE gdp > ALL (SELECT gdp 
                   FROM world
                   WHERE continent = 'Europe' 
                   AND gdp IS NOT NULL)

-- ALL here will select all gdps for Europe excluding the blanks 
-- NULL is equivalent of blanks


/*
7.
Find the largest country (by area) in each continent, show the continent, the name and the area: 
*/

SELECT continent, name, area
FROM world x
WHERE area >= ALL (SELECT area 
                   FROM world y
                   WHERE y.continent = x.continent
                   AND area > 0);

-- need to have a way to compare each country with all the other countries in the same continent.
-- find the country whose area is greater than or equal to all the countries in its continent
-- we "pretend" that we have two different tables, SQL matches them up and we get one result per continent.
/*It's like

SELECT continent, name, area
FROM world [referred to from now on as x]
Where area >= ALL
(SELECT area FROM world [referred to from now on as y]
WHERE y.continent=x.continent
AND area>0)

It's just a kind of workaround to select twice from the same table.

WHERE y.continent=x.continent basically allows it to compare the area of countries where the continents match and ignore the others, 
It goes down the list, continent by continent, and pops out the ones with the largest area
It's like it builds two tables of "countries in Africa" and compares all of them with all of them to make sure weve found the biggest, repeat for other continents.

*/



/*
8.
List each continent and the name of the country that comes first alphabetically.
*/

SELECT continent, name  
FROM world x
WHERE x.name <= ALL (SELECT name
                     FROM world y
                     WHERE x.continent = y.continent);


-- x.continent = y.continent compares the country name of an instance from x with the country name of an instance from y if they share the same continent
-- So use continent of Asia for example:
-- Japen gets filtered out because Japan <= All(Afghanistan,Taiwan,Japan) is false since Japan is not less or equal to Afghanistan (A comes before J)
-- Taiwan gets filtered out because Taiwan <= All(Afghanistan,Taiwan,Japan) is false since Taiwan is not less or equal to Afghanistan.
-- Afghanistan does not get filtered out because Afghanistan <= All(Afghanistan,Taiwan,Japan) is true since Afghanistan is equal to Afghanistan

/*
9.
Find the continents where all countries have a population <= 25000000. Then find the names of the countries associated with these continents. Show name, continent and population. 
*/
SELECT name, continent, population 
FROM world x
WHERE 25000000 >= ALL (SELECT population 
                       FROM world y
                       WHERE x.continent=y.continent
                       AND y.population > 0);

-- The 'ALL' part compares the population of all the countries in a continent with 25000000 and if it less than 25000000, it prints names, population of all countries in it.


/*
10.
Some countries have populations more than three times that of any of their neighbours (in the same continent). Give the countries and continents.
*/

SELECT name, continent 
FROM world x 
WHERE population > ALL (SELECT population*3 
                        FROM world y
                        WHERE y.continent = x.continent
                        AND y.name != x.name)


-- 
