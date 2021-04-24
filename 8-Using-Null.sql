/*
1.
List the teachers who have NULL for their department.
Why we cannot use =

You might think that the phrase dept=NULL would work here but it doesn't - you can use the phrase dept IS NULL 
*/

SELECT name
FROM teacher
WHERE dept IS NULL

-- IS NULL is equivalent for blanks 


/*
2.
Note the INNER JOIN misses the teachers with no department and the departments with no teacher. 
*/

SELECT teacher.name, dept.name
FROM teacher JOIN dept ON (teacher.dept = dept.id)


-- SOLUTION 2

SELECT teacher.name, dept.name
FROM teacher INNER JOIN dept ON (teacher.dept = dept.id)


/*
3.
Use a different JOIN so that ALL TEACHERS are listed. 
*/

SELECT teacher.name, dept.name
FROM teacher LEFT JOIN dept ON (teacher.dept = dept.id)

-- JOIN connected and showed only teachers with dept with an ID from the teacher table in relation to dept table.
-- LEFT JOIN showed all teachers from the teacher table (even lines with no ID) in relation to the dept table, hence, shows NULL for teachers that could not link to dept table
-- assuming teacher values was on the left, our LEFT JOIN displays all the corresponding dept values on the right (as if we had joined the dept table to the left)


/*
4.
Use a different JOIN so that ALL DEPARTMENTS are listed. 
*/

SELECT teacher.name, dept.name
FROM teacher RIGHT JOIN dept ON (teacher.dept = dept.id)

-- assuming teacher table was on the left, RIGHT JOIN assumes our right table which is dept table, is our primary table where all values will be displayed
-- Hence, the dept table will link up all values corresponding to the teacher table
-- For teacher values that the dept table cannot link, dept table value will still display, but will show as null on the teacher column


/*
5.
Use COALESCE to print the mobile number. Use the number '07986 444 2266' if there is no number given. Show teacher name and mobile number or '07986 444 2266' 
*/

SELECT name, COALESCE(mobile,'07986 444 2266')
FROM teacher

-- COALESCE(refers to the column to search for blank/null values, replace with new value)


/*
6.
Use the COALESCE function and a LEFT JOIN to print the teacher name and department name. Use the string 'None' where there is no department. 
*/

SELECT teacher.name, COALESCE(dept.name,'None')
FROM teacher LEFT JOIN dept ON (teacher.dept = dept.id)

-- COALESCE(refers to name column in table dept for blank values, replace with new value)
-- assuming teacher table on the left, assumes the teacher table is the primary table, and displays all values of teacher name column
-- LEFT JOIN will attach any correpsonding value to the existing teacher column, and fills 'none' for any blank values. 


/*
7.
Use COUNT to show the number of teachers and the number of mobile phones. 
*/

SELECT COUNT(teacher.name), COUNT(mobile)
FROM teacher


/*
8.
Use COUNT and GROUP BY dept.name to show each department and the number of staff. Use a RIGHT JOIN to ensure that the Engineering department is listed. 
*/

SELECT dept.name, COUNT(teacher.name)
FROM teacher RIGHT JOIN dept ON (teacher.dept = dept.id)
GROUP BY dept.name

-- assuming our teacher table is on left, RIGHT JOIN will assume our dept table as our primary table, displaying all values in our dept name column
-- remember, GROUP BY only references to columns listed in our SELECT line, excluding the aggregate functions. 

/*
9.
Use CASE to show the name of each teacher followed by 'Sci' if the teacher is in dept 1 or 2 and 'Art' otherwise. 
*/

SELECT teacher.name, CASE WHEN dept IN (1,2) THEN 'Sci' 
             ELSE 'Art' END
FROM teacher

-- two tables used here, teacher table, and dept table. 


/*
10.
Use CASE to show the name of each teacher followed by 'Sci' if the teacher is in dept 1 or 2, show 'Art' if the teacher's dept is 3 and 'None' otherwise. 
*/

SELECT teacher.name, CASE WHEN dept IN (1,2) THEN 'Sci'
              WHEN dept = 3 THEN 'Art'
              ELSE 'None' END
FROM teacher

-- two tables used here, teacher table and dept table. 