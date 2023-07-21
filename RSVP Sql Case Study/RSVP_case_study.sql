USE imdb;

/* Now that you have imported the data sets, letâ€™s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/
-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT count(*) FROM director_mapping dm;
SELECT count(*) FROM genre g ;
SELECT count(*) FROM movie m ;
SELECT count(*) FROM names n ;
SELECT count(*) FROM ratings r ;
SELECT count(*) FROM role_mapping rm ;


-- Q2. Which columns in the movie table have null values?
-- Type your code below:



SELECT 
	sum(CASE WHEN id IS NULL THEN 1 ELSE 0 END ) AS nulls_in_id,
	sum(CASE WHEN title IS NULL THEN 1 ELSE 0 END ) AS nulls_in_title,
	sum(CASE WHEN year IS NULL THEN 1 ELSE 0 END ) AS nulls_in_year,
	sum(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END ) AS nulls_in_datepublished,
	sum(CASE WHEN duration IS NULL THEN 1 ELSE 0 END ) AS nulls_in_duration,
	sum(CASE WHEN country IS NULL THEN 1 ELSE 0 END ) AS nulls_in_country,
	sum(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END ) AS nulls_in_worldwidegrossincome,
	sum(CASE WHEN languages IS NULL THEN 1 ELSE 0 END ) AS nulls_in_languages,
	sum(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END ) AS nulls_in_productioncompany
FROM 
movie m ;

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT
	count(m.id),
	m.`year`
FROM
	movie m
GROUP BY
	m.`year`;

SELECT
	MONTH(m.date_published),
	count(m.id)
FROM
	movie m
GROUP BY
	MONTH(m.date_published)
ORDER BY
	MONTH(m.date_published) DESC;




/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, letâ€™s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT
	count(m.id)
FROM
	movie m
WHERE
	m.`year` = '2019'
	AND m.country IN ('USA', 'India');




/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Letâ€™s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT
	g.genre
FROM
	genre g
GROUP BY
	g.genre;




/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldnâ€™t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:


SELECT
	g.genre,
	count(m.id)
FROM
	movie m
INNER JOIN genre g 
ON
	m.id = g.movie_id
GROUP BY
	g.genre
ORDER BY
	count(m.id) DESC;



/* So, based on the insight that you just drew, RSVP Movies should focus on the â€˜Dramaâ€™ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, letâ€™s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:


SELECT
	count(*)
FROM
	(
	SELECT
		m.id,
		count(g.genre) AS count_of_genres
	FROM
		movie m
	INNER JOIN genre g 
	ON
		m.id = g.movie_id
	GROUP BY
		m.id
	HAVING
		count(g.genre)= 1
) foo;



/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Moviesâ€™ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:



SELECT
	g.genre ,
	avg(m.duration) AS avg_duration
FROM
	movie m
INNER JOIN genre g 
ON
	m.id = g.movie_id
GROUP BY
	g.genre;


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the â€˜thrillerâ€™ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


SELECT
	g.genre,
	count(m.id) AS movie_count,
	RANK() OVER (ORDER BY count(m.id) DESC) AS genre_rank
FROM
	movie m
INNER JOIN genre g 
ON
	m.id = g.movie_id
GROUP BY
	g.genre;





/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:


SELECT
	min(r.avg_rating) AS min_avg_rating,
	max(r.avg_rating) AS max_avg_rating,
	min(r.total_votes) AS min_total_votes,
	max(r.total_votes) AS max_total_votes,
	min(r.median_rating) AS min_median_rating,
	max(r.median_rating) AS max_median_rating
FROM
	ratings r;



/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, letâ€™s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH top_movies AS  (
	SELECT
		m.title,
		r.avg_rating AS avg_rating,
		RANK() OVER(ORDER BY r.avg_rating DESC) AS movie_rank
	FROM
		movie m
	INNER JOIN ratings r 
	ON
		m.id = r.movie_id 
)
SELECT * FROM top_movies WHERE movie_rank<=10



/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have



SELECT
	r.median_rating AS median_rating ,
	count(m.id) AS movie_count
FROM
	movie m
INNER JOIN ratings r 
ON
	m.id = r.movie_id
GROUP BY
	r.median_rating
ORDER BY
	r.median_rating DESC;



/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:



SELECT
	m.production_company,
	count(m.id) AS movie_count,
	RANK() OVER(ORDER BY count(m.id) DESC) AS prod_company_rank
FROM
	ratings r
INNER JOIN movie m 
ON
	r.movie_id = m.id
WHERE
	r.avg_rating > 8
	AND m.production_company IS NOT NULL
GROUP BY
	m.production_company;




-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT
	g.genre,
	count(m.id)
FROM
	movie m
INNER JOIN genre g 
ON
	m.id = g.movie_id
WHERE
	MONTH(m.date_published)= '3'
	AND YEAR(date_published)= '2017'
GROUP BY
	g.genre;





-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word â€˜Theâ€™ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT
	m.title,
	r.avg_rating,
	g.genre
FROM
	movie m
INNER JOIN genre g 
ON
	m.id = g.movie_id
INNER JOIN ratings r
ON
	m.id = r.movie_id
WHERE
	m.title LIKE 'The%'
	AND r.avg_rating > 8;



-- You should also try your hand at median rating and check whether the â€˜median ratingâ€™ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:


SELECT
	count(*)
FROM
	movie m
INNER JOIN ratings r 
ON
	m.id = r.movie_id
WHERE
	r.median_rating = 8
	AND m.date_published >= '2018-04-1 00:00:00'
	AND m.date_published <= '2019-04-01 00:00:00';


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:


SELECT
	m.country,
	sum(r.total_votes) AS total_votes
FROM
	ratings r
INNER JOIN movie m ON
	m.id = r.movie_id
WHERE
	m.country IN ('Germany', 'Italy')
GROUP BY
	m.country;


-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Letâ€™s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


SELECT
	sum(CASE WHEN n.id IS NULL THEN 1 ELSE 0 END ) AS NULLS_in_id,
	sum(CASE WHEN n.name IS NULL THEN 1 ELSE 0 END ) AS NULLS_in_name,
	sum(CASE WHEN n.height IS NULL THEN 1 ELSE 0 END ) AS NULLS_in_height,
	sum(CASE WHEN n.date_of_birth IS NULL THEN 1 ELSE 0 END ) AS NULLS_in_date_of_birth,
	sum(CASE WHEN n.known_for_movies IS NULL THEN 1 ELSE 0 END ) AS NULLS_in_known_for_movies
FROM
	names n;



/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Letâ€™s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:



WITH 
	top_genres AS
	(
		SELECT
			g.genre,
			count(m.id) AS movie_count,
			ROW_NUMBER() OVER(ORDER BY count(m.id) DESC) AS genre_rank
		FROM
			genre g
		INNER JOIN movie m ON
			g.movie_id = m.id
		INNER JOIN ratings r ON
			m.id = r.movie_id
		WHERE
			r.avg_rating > 8
		GROUP BY
			g.genre 
	),
	top_director AS (
		SELECT
			n.name,
			count(m2.id) AS movie_count,
			RANK() OVER(ORDER BY count(m2.id) DESC) AS director_rank
		FROM
			movie m2
		INNER JOIN director_mapping dm 
		ON
			m2.id = dm.movie_id
		INNER JOIN names n 
		ON
			dm.name_id = n.id
		INNER JOIN genre g2 
		ON
			g2.movie_id = m2.id
		INNER JOIN ratings r2 
		ON
			m2.id = r2.movie_id
		WHERE
			g2.genre IN (
			SELECT
				genre
			FROM
				top_genres
			WHERE
				genre_rank <= 3)
			AND r2.avg_rating >8
		GROUP BY
			n.name
	)
SELECT
	*
FROM
	top_director
WHERE
	director_rank <= 3;


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, letâ€™s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


WITH top_actors AS 
	(
	SELECT
		n.name,
		count(m.id) AS movie_count,
		RANK() OVER(ORDER BY count(m.id) DESC) AS actor_rank
	FROM
		role_mapping rm
	INNER JOIN movie m 
	ON
		m.id = rm.movie_id
	INNER JOIN ratings r 
	ON
		m.id = r.movie_id
	INNER JOIN names n 
	ON
		n.id = rm.name_id
	WHERE
		rm.category = 'actor'
		AND r.median_rating >= 8
	GROUP BY
		n.name
	)
SELECT
	name,
	movie_count
FROM
	top_actors
WHERE
	actor_rank <= 2;




/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Letâ€™s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
WITH top_production_companies AS
	(
	SELECT
		m.production_company,
		sum(r.total_votes) AS vote_count,
		RANK() OVER(
		ORDER BY sum(r.total_votes) DESC) AS prod_comp_rank
	FROM
		movie m
	INNER JOIN ratings r 
	ON
		m.id = r.movie_id
	GROUP BY
		m.production_company 
	)
SELECT
	*
FROM
	top_production_companies
WHERE
	prod_comp_rank <= 3;




/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Letâ€™s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:



WITH top_actor AS
	(
	SELECT
		n.name,
		sum(r.total_votes) AS total_votes,
		count(m.id) AS movie_count,
		Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actor_avg_rating,
		RANK() OVER(ORDER BY Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) DESC, sum(r.total_votes) DESC) AS actor_rank
	FROM
		movie m
	INNER JOIN 
	role_mapping rm 
	ON
		m.id = rm.movie_id
	INNER JOIN ratings r 
	ON
		m.id = r.movie_id
	INNER JOIN names n 
	ON
		rm.name_id = n.id
	WHERE
		rm.category = 'actor'
		AND m.country = 'India'
	GROUP BY
		n.name
	HAVING
		count(m.id) >= 5
	)
SELECT
	*
FROM
	top_actor;


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:



WITH top_actress AS
	(
	SELECT
		n.name,
		sum(r.total_votes) AS total_votes,
		count(m.id) AS movie_count,
		Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actor_avg_rating,
		RANK() OVER(
		ORDER BY Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) DESC,
		sum(r.total_votes) DESC) AS actress_rank
	FROM
		movie m
	INNER JOIN 
	role_mapping rm 
	ON
		m.id = rm.movie_id
	INNER JOIN ratings r 
	ON
		m.id = r.movie_id
	INNER JOIN names n 
	ON
		rm.name_id = n.id
	WHERE
		rm.category = 'actress'
		AND m.country = 'India'
		AND languages LIKE '%Hindi%'
	GROUP BY
		n.name
	HAVING
		count(m.id) >= 3
	)
SELECT
	*
FROM
	top_actress
WHERE
	actress_rank <= 5;




/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:


SELECT
	g.genre,
	r.avg_rating,
	CASE
		WHEN r.avg_rating > 8 THEN 'Superhit movies'
		WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
		WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
		ELSE 'Flop movies'
	END AS avg_rating_category
FROM
	ratings r
INNER JOIN movie m 
ON
	m.id = r.movie_id
INNER JOIN genre g 
ON
	m.id = g.movie_id
WHERE
	g.genre = 'Thriller';

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT
	g.genre,
	round(avg(m.duration), 2) AS avg_duration,
	SUM(ROUND(AVG(m.duration), 2)) OVER (
	ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
	AVG(ROUND(AVG(m.duration), 2)) OVER(
	ORDER BY genre ROWS 10 PRECEDING) AS moving_avg_duration
FROM
	movie m
INNER JOIN genre g ON
	m.id = g.movie_id
GROUP BY
	g.genre;



-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies


WITH top_genre AS
	(
	SELECT
		g.genre,
		COUNT(g.movie_id) AS movie_count,
		RANK() OVER(
		ORDER BY count(g.movie_id)) AS genre_rank
	FROM
		genre g
	GROUP BY
		g.genre
	),
top_movie AS
	(
	SELECT
		genre,
		YEAR,
		title AS movie_name,
		worlwide_gross_income,
		DENSE_RANK() OVER(PARTITION BY YEAR
	ORDER BY
		worlwide_gross_income DESC) AS movie_rank
	FROM
		movie m
	INNER JOIN genre g
	ON
		m.id = g.movie_id
	WHERE
		genre IN(
		SELECT
			genre
		FROM
			top_genre
		WHERE
			genre_rank <= 3)
	)
SELECT
	*
FROM
	top_movie
WHERE
	movie_rank <= 5;



-- Finally, letâ€™s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_company_summary AS
	(
	SELECT
		production_company,
		Count(*) AS movie_count
	FROM
		movie AS m
	INNER JOIN ratings AS r
							ON
		r.movie_id = m.id
	WHERE
		median_rating >= 8
		AND production_company IS NOT NULL
		AND POSITION(',' IN languages) > 0
	GROUP BY
		production_company
	ORDER BY
		movie_count DESC
	),
	top_production_company AS
	(
	SELECT
		*,
		RANK()
			 OVER(
	ORDER BY
		movie_count DESC) AS prod_comp_rank
	FROM
		production_company_summary
	)
SELECT
*
FROM
	top_production_company
WHERE
	prod_comp_rank <= 2;




-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:



WITH actress_summary AS
	(
	SELECT
		n.NAME AS actress_name,
		SUM(total_votes) AS total_votes,
		Count(r.movie_id) AS movie_count,
		Round(Sum(avg_rating * total_votes)/ Sum(total_votes), 2) AS actress_avg_rating
	FROM
		movie AS m
	INNER JOIN ratings AS r
			   ON
		m.id = r.movie_id
	INNER JOIN role_mapping AS rm
			   ON
		m.id = rm.movie_id
	INNER JOIN names AS n
			   ON
		rm.name_id = n.id
	INNER JOIN GENRE AS g
			   ON
		g.movie_id = m.id
	WHERE
		category = 'Actress'
		AND avg_rating>8
		AND genre = "Drama"
	GROUP BY
		NAME
	),
	top_actress AS
	(
	SELECT
		*,
		RANK() OVER(
		ORDER BY movie_count DESC) AS actress_rank
	FROM
		actress_summary
	)
SELECT 
	* 
FROM
	top_actress
WHERE 
	actress_rank<=3;




/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:




WITH next_date_published_summary AS
	(
	SELECT
		d.name_id,
		NAME,
		d.movie_id,
		duration,
		r.avg_rating,
		total_votes,
		m.date_published,
		LEAD(date_published, 1) OVER(PARTITION BY d.name_id
	ORDER BY
		date_published,
		movie_id ) AS next_date_published
	FROM
		director_mapping AS d
	INNER JOIN names AS n
			   ON
		n.id = d.name_id
	INNER JOIN movie AS m
			   ON
		m.id = d.movie_id
	INNER JOIN ratings AS r
			   ON
		r.movie_id = m.id 
	),
top_director_summary AS
	(
		SELECT
			*,
			Datediff(next_date_published, date_published) AS date_difference
		FROM
			next_date_published_summary
	),
top_directors AS (
	SELECT
		name_id AS director_id,
		NAME AS director_name,
		Count(movie_id) AS number_of_movies,
		Round(Avg(date_difference), 2) AS avg_inter_movie_days,
		Round(Avg(avg_rating), 2) AS avg_rating,
		Sum(total_votes) AS total_votes,
		Min(avg_rating) AS min_rating,
		Max(avg_rating) AS max_rating,
		Sum(duration) AS total_duration,
		RANK() over(ORDER BY Count(movie_id) desc) AS director_rank
	FROM
		top_director_summary
	GROUP BY
		director_id
)
SELECT * FROM top_directors WHERE director_rank<=9;
