USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
/*
We use sql COUNT function to claculate total number of rows in the table.  
*/
-- 1. role_mapping hving 15615 rows
SELECT 
	COUNT(*) AS total_records
FROM
	role_mapping;

-- 2. genre having 14662 rows
SELECT 
	COUNT(*) AS total_records
FROM
	genre;

-- 3. ratings having 7997 rows
SELECT 
	COUNT(*) AS total_records
FROM
	ratings;
    
-- 4. director_mapping having 3867 rows
SELECT 
	COUNT(*) AS total_records
FROM
	director_mapping;

-- 5. names table 25735 rows
SELECT 
	COUNT(*) AS total_records
FROM
	names;

-- 6. movie table having 7997 rows
SELECT 
	COUNT(*) AS total_records
FROM
	movie;


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

-- Use Case to count the number of null values in the columns of movie table
SELECT 
	SUM(CASE
			WHEN id IS NULL THEN 1
            ELSE 0
	   END) AS id_null_count,
	SUM(CASE
			WHEN title IS NULL THEN 1
            ELSE 0
		END) AS title_null_count,
   SUM(CASE
			WHEN year IS NULL THEN 1
            ELSE 0
		END) AS year_null_count,
	SUM(CASE
            WHEN date_published IS NULL THEN 1
			ELSE 0
		END) AS date_published_null_count,
	SUM(CASE
			WHEN duration IS NULL THEN 1
			ELSE 0
		END) AS duration_null_count,
	SUM(CASE
            WHEN country IS NULL THEN 1
			ELSE 0
		END) AS country_null_count,
	SUM(CASE
             WHEN worlwide_gross_income IS NULL THEN 1
             ELSE 0
			END) AS worlwide_gross_income_null_count,
	SUM(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
			END) AS languages_null_count,
	SUM(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
			END) AS production_company_null_count
FROM   
	movie; 

-- Result shows that country, world_wise_gross_income, languages, production_company column having null values

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

-- No. of movie released in a year, we use GROUP BY clause on year
SELECT 
	Year,
    COUNT(Year) AS number_of_movies
FROM
	movie
GROUP BY
	year
ORDER BY
	number_of_movies DESC;

-- Highest no. of movies released on the year 2017 with  3052 movies

-- NUmber movies produced in each month, For that we  use GROUP BY on month part of date_published column
-- of movie table. To get the Month from the date we use MONTH function.
SELECT 
	MONTH(date_published) AS month_num,
	COUNT(MONTH(date_published))   AS number_of_movies
FROM   
	movie
GROUP  BY 
	MONTH(date_published)
ORDER  BY 
	number_of_movies DESC; 
    
-- Highest number of movies were released in in the March Month of 824 movies




/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

/*
 For that we filter the movie which produced in INDIA or USA, for case insensitive search we use Upper
 function, movie may produced for multiple country, for that reason we use LIKE to find whether 
 country column value having USA or INDIA, and year is 2019 then consider that record.
*/
SELECT 
	COUNT(id) AS number_of_movies
FROM   
	movie
WHERE  
	 (
		UPPER(country) LIKE '%USA%'
		OR
		UPPER(country) LIKE '%INDIA%'
	)
	AND 
		year = 2019; 
        
-- In the year 2019, INDIA or USA produced 1059 movies




/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

/*
	We use GROUP BY on genre column to fetch the unique genre exits in the genre table, instead of 
    costly distinct clause.
*/
SELECT 
	 genre
FROM   
	genre
GROUP BY
	genre; 

-- There having 13 distinct genere on which movies produced


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

-- We group the data on the basis of genre and count the movies produced under that genre
SELECT     
	genre,
    COUNT(genre) AS number_of_movies
FROM      
	genre  AS g
GROUP BY   
	genre
ORDER BY   
	number_of_movies DESC 
LIMIT 1 ;


-- Highest no. of 4285 movies produced in the genre of Drama movies.





/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
/*
	First get the movie list which belongs to one genre, then count that movies. For that first part 
    we use CTE.
*/
WITH unique_movie_genre AS
(
	SELECT 
		movie_id
	FROM   
		genre
	 GROUP BY 
		movie_id
	HAVING Count(movie_id) = 1	
) 
SELECT 
	COUNT(movie_id) AS total_unique_genre_movie_count
FROM
	unique_movie_genre;
    
-- Total 3289 movies belongs to one genre only
	

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

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
/*
	We group the movies on the basis of genre and calculate the avg duration time of the movie of that genre
*/
SELECT     
	genre,
    ROUND( AVG(duration), 2 ) AS avg_duration
FROM      
	movie AS m
	INNER JOIN 
		genre AS g
	ON 
		g.movie_id = m.id
GROUP BY   
	genre;
		
-- Drama genre movie having avg duration of 106.77


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
/*
We group the movies on the basis of genre and the count no. of movies produced in that genre.
Also on the basis of no. of movie produced we give rank to that genre using RANK window function.
*/
SELECT
	genre,
    COUNT( movie_id )  AS movie_count,
	RANK() OVER( ORDER BY COUNT( movie_id ) DESC ) AS genre_rank
FROM       
	genre                                 
GROUP BY   
	genre;

-- Total movies produced in Thriller genre is 1484 and its rank is 3 


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|max_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
	MIN( avg_rating ) AS min_avg_rating,
	MAX( avg_rating ) AS max_avg_rating,
	MIN( total_votes ) AS min_total_votes,
	MAX( total_votes ) AS max_total_votes,
	MIN( median_rating ) AS min_median_rating,
	MAX( median_rating ) AS max_median_rating
FROM   
	ratings; 



    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

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
/*
1. First we get all the details title, avg rating, and give rank to movie on the basis of its avg rating.
2. After fetching all these data we filter top 10 movie on the basis of their ranking.
*/
WITH movie_rank_summary AS
(
	SELECT
		title,
        avg_rating,
        RANK() OVER( ORDER BY avg_rating DESC ) AS movie_rank
	FROM       
		ratings  AS r
		INNER JOIN 
			movie AS m
			ON 
				m.id = r.movie_id 
)
SELECT 
	*
FROM 
	movie_rank_summary
WHERE
	movie_rank <= 10;



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
/*
We get median rating of the film from rating table and group movies on the basis of median rating.
We count the movies produced under each median rating.
*/
SELECT 
	median_rating,
    COUNT( movie_id ) AS movie_count
FROM   
	ratings
GROUP BY 
	median_rating
ORDER BY 
	movie_count DESC; 

-- Median_rating 7 having maximum movie count of 2257


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
/*
First we filter the movies which having avg rating >8 after that we group the movies by their production company.
We give rank to production company on the basis of no. of movies produced by each company.
2. Finally filter the production company which having rank = 1. 
*/
WITH production_company_movie_summary AS 
(
	SELECT 
		production_company,
        COUNT( movie_id ) AS movie_count,
		RANK() OVER(
						ORDER BY COUNT( movie_id ) DESC 
					) AS prod_company_rank
	FROM   
		ratings AS r
		INNER JOIN 
			movie AS m
			ON 
				m.id = r.movie_id
	WHERE  
		avg_rating > 8
		AND 
			production_company IS NOT NULL
	GROUP BY 
		production_company
)
SELECT 
	*
FROM   
	production_company_movie_summary
WHERE  
	prod_company_rank = 1; 


-- Dream Warrior Pictures and National Theatre Live having maximum hit movie count 3

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
/*
We use Where clause to specify the filter conditions.
*/
SELECT 
	genre,
	COUNT(m.id) AS movie_count
FROM   
	movie AS m
	INNER JOIN 
		genre AS g
		ON 
			g.movie_id = m.id
       INNER JOIN 
		ratings AS r
		ON 
			r.movie_id = m.id
WHERE  
	year = 2017
	AND 
		MONTH(date_published) = 3
	AND 
		UPPER(country) LIKE '%USA%'
	AND 
		total_votes > 1000
GROUP BY 
	genre;




-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
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
/*
We use where clause to specify the filter condition.
*/
SELECT  
	title,
    avg_rating,
    genre
FROM   
	movie AS m
	INNER JOIN 
		genre AS g
		ON 
			g.movie_id = m.id
	INNER JOIN 
		ratings AS r
		ON 
			r.movie_id = m.id
WHERE  
	avg_rating > 8
	AND 
		title LIKE 'The%'
ORDER BY
	avg_rating DESC,
	genre ASC;
	


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

/*
We use where clause to specify the filter condition.
*/
SELECT 
	COUNT(m.id) AS movie_count
FROM   
	movie AS m
	INNER JOIN 
		ratings AS r
		ON 
			r.movie_id = m.id
WHERE  
	median_rating = 8
	AND 
		date_published BETWEEN '2018-04-01' AND '2019-04-01';
        
-- 361 movies have released between 1 April 2018 and 1 April 2019 with a median rating of 8



-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
/*
	For this we first categories the movie on the basis of country or language, if any of this having Germany then we 
    consider that Germany. On than other hand if it having Italy then consider that as Italian movie. 
    After this categorization, we sum the votes of these movies. So using CTE first we categorize the movie. 
    After than sum the votes against that movies type using group by.
*/

WITH movie_type_details AS
(
	SELECT
		CASE
			WHEN ( UPPER(country) like '%GERMANY%') 
					OR 
					( UPPER(languages) like '%GERMAN%')
                    THEN 'Germany'
            WHEN ( UPPER(country) like '%ITALY%' )
					OR 
					( UPPER(languages) like '%ITALIAN%')
					THEN 'Italy'
            ELSE 'Other'
		END AS movie_type,
        total_votes
	FROM
		movie AS m
		INNER JOIN 
			ratings as r 
				ON m.id=r.movie_id
	WHERE 
		( UPPER( country ) like '%GERMANY%') 
        OR 
        ( UPPER( country ) like '%ITALY%')
        OR
        ( UPPER( languages ) like '%GERMAN%')
        OR 
        ( UPPER( languages ) like '%ITALIAN%')
        
)
SELECT 
	movie_type,
    sum(total_votes) total_votes
FROM
	movie_type_details
GROUP BY
	movie_type;


-- YES German movies get more votes ( 5793475 ) than Italian movies ( 2203945 )


-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
/*
We use case clause to count the null values in each column of name table
*/
SELECT 
		SUM(
			CASE 
				WHEN name IS NULL 
					THEN 1 
                    ELSE 0 
			END) AS name_nulls, 
		SUM(
			CASE 
				WHEN height IS NULL 
					THEN 1 
					ELSE 0 
			END
			) AS height_nulls,
		SUM(
				CASE 
					WHEN date_of_birth IS NULL 
						THEN 1 
						ELSE 0 
				END
			) AS date_of_birth_nulls,
		SUM(
				CASE 
					WHEN known_for_movies IS NULL 
						THEN 1 
						ELSE 0 
				END
			) AS known_for_movies_nulls
		
FROM 
	names;

-- Height, date_of_birth, known_for_movies columns having NULLS, name column does not have NULLs



/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

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
/*
For that we have get the top three which having maximum movies of avg_rating > 8, 
from that movie's directors, who are directed maximum movies of avg_rating > 8.
For getting the top 3 genre we use CTE, with RANK(), on the value of rank function we filter genre which
having rank value <=3. It gives us top 3 genre having avg_rating > 8 and maximum movie produced in that genre.
Using this we get the directors of that movies who directed maximum movie of avg_rating > 8. 
*/
WITH genres_movie_count AS
(
	SELECT
		genre,
        COUNT(g.movie_id)  AS movie_count ,
		Rank() OVER( ORDER BY COUNT( g.movie_id ) DESC ) AS genre_rank
	 FROM 
		genre AS g
		INNER JOIN 
			ratings AS r
			USING(movie_id)
	 WHERE  
		avg_rating > 8
	GROUP BY   
		genre  
),  
	-- Filter top 3 three genre
	top_3_genres AS
    (
		SELECT 
			genre
		FROM
			genres_movie_count
		WHERE
			genre_rank <=3
	)
    -- Top 3 three directed who had directed maximum movies belongs to top 3 genre, of avg_rating > 8.
    SELECT
		n.name  AS director_name ,
		COUNT( d.movie_id ) AS movie_count
	FROM
		director_mapping  AS d 
	INNER JOIN 
		genre AS g
		using(movie_id)
	INNER JOIN 
		names AS n
		ON  n.id = d.name_id
	INNER JOIN 
		ratings
		using(movie_id)
WHERE      
	avg_rating > 8
    AND  -- movies belongs to top 3 genre 
    genre in (
				SELECT *
				FROM
					top_3_genres
			)
GROUP BY
	name
ORDER BY   
	movie_count DESC 
LIMIT 3 ;

-- James Mangold had directed maximum movies of top3 genre having avg_rating > 8.


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
/*
We first rank the actors who had done maximum movies of median rating >= 8 using RANK, after that filters those 
actors whose rank is <=2, to get the desired output. For ranking the actors as per the specified condition,
we use CTE, so that we can avoid using LIMIT to male query cost effective.
*/

-- Assign rank to actors on the basis of  number of movies they acted on, which having median rating >= 8 
WITH top_actor_details AS
(
	SELECT 
		n.name AS actor_name,
		COUNT(movie_id) AS movie_count,
		RANK() OVER( ORDER BY COUNT(movie_id) DESC ) actor_rank  
	FROM   
		role_mapping AS rm
		   INNER JOIN 
			movie AS m
				ON m.id = rm.movie_id
		   INNER JOIN 
			ratings AS r 
				USING( movie_id )
		   INNER JOIN 
			names AS n
				ON n.id = rm.name_id
	WHERE  
		r.median_rating >= 8
		AND 
			UPPER( category ) = 'ACTOR'
	GROUP BY 
		actor_name
)
-- Filter the top 2 actor who having rank <=2 on the basis of condition specified earlier.
SELECT 
	actor_name,
    movie_count
FROM
	top_actor_details
WHERE
	actor_rank <=2;

-- Mammootty comes out to be the top actor who had done maximum movies of median rating >=8, with movie count - 8. and
-- Mohanlal secured second rank with the count of movies 2.




/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

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

/*
We first gives rank to production company on the basis of vote_count. After that we filter first three production
company which secured maximum no. of votes. For giving Rank we use CTE and rank function. After that we filter the top
3 production company. Here also we use RANK method to filter the top production company instead of costly Limit function.
*/
-- Assign rank to production company on the basis of number of votes that received for the movie they produced
WITH production_company_ranking_details AS
(
	SELECT 
		production_company, 
        sum(total_votes) AS vote_count,
		RANK() OVER( ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
	FROM 
		movie AS m
		INNER JOIN 
			ratings AS r 
				ON r.movie_id = m.id
	WHERE 
		production_company IS NOT NULL
	GROUP BY 
		production_company
) 
-- Filter top 3 production companies having rank < = 3.
SELECT 
	*
FROM 
	production_company_ranking_details
WHERE 
	prod_comp_rank <= 3;
    
-- With 2656967 no. of votes, Marvel Studios ranking 1 postion. Twentieth Century Fox comes second with total vote
-- 2411163 and Warner Bros. third with  2396057 votes.



/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

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
/*
	We first get the actors who acted in atleast 5 movies which are released in India, their total votes and 
    weighted votes. 
    In the second part we assign RANK to those actor as per the weighted rating 
    For then first part we use CTE to fetch all those actors along with their rating details. Here we use LIKE caluse to extract the movies in India
    Becuse some movie may release in other country along with India also.
    In the Second part we simply use RANK function to give rank to those selected actors on the basis of their ratings.
*/

-- Select the actors who had acted in atleast five movies which are released in India, along with total votes.
WITH indian_actor_details  AS 
(
	SELECT 
		n.NAME AS actor_name,
        SUM( total_votes ) AS total_votes,
	    COUNT( r.movie_id ) AS movie_count,
		ROUND( SUM( avg_rating * total_votes ) / SUM( total_votes ), 2) AS actor_avg_rating
         FROM   
			movie AS m
			INNER JOIN 
				ratings AS r
					ON m.id = r.movie_id
			INNER JOIN 
				role_mapping AS rm
					ON m.id = rm.movie_id
			INNER JOIN 
				names AS n
					ON rm.name_id = n.id
         WHERE  
			UPPER(category) = 'ACTOR'
            AND 
				UPPER( country ) LIKE "%INDIA%"
         GROUP BY 
			name
         HAVING movie_count >= 5
)
-- Fetch actor with their movie count and weighted rating along with rank which is assigned as per the rating. 
SELECT *,
       Rank()
         OVER(
           ORDER BY actor_avg_rating DESC) AS actor_rank
FROM   indian_actor_details; 

-- Actor Vijay Sethupathi is standing as number one postion with avg rating of 8.42.






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
/*
For this we divide the query in two part. In the first part we select all the actoress those are acted
in Indian movies and acted atleast 3 movies. We also we rank to actress as per their avg rating.
In the second part we filter top 5 actresses on the basis of their rank, in this way we avoid using 
limit function, which is costly option.
*/
WITH indian_Hindi_movie_actress_summary AS
(
	SELECT
		n.name AS actress_name,
		SUM( total_votes ) AS total_votes,
		COUNT( r.movie_id ) AS movie_count,
		ROUND( SUM( avg_rating * total_votes )/ SUM( total_votes ), 2 ) AS actress_avg_rating,
        Rank() OVER( 
						ORDER BY 
							ROUND( SUM( avg_rating * total_votes )/ SUM( total_votes ), 2 ) 
						DESC
                    ) AS actress_rank
	FROM
		movie AS m
		INNER JOIN 
			ratings AS r
				ON m.id=r.movie_id
		INNER JOIN 
			role_mapping AS rm
				ON m.id = rm.movie_id
		INNER JOIN 
			names AS n
		ON rm.name_id = n.id
	WHERE
		UPPER( category ) = 'ACTRESS'
		AND
			UPPER( country ) LIKE "%INDIA%"
		AND
			UPPER(languages) LIKE '%HINDI%'
	GROUP BY
		name
	HAVING     movie_count>=3 
)
-- Filter top 5 actresses as per their rank
SELECT   
	*
FROM 
	indian_Hindi_movie_actress_summary 
WHERE
	actress_rank <=5;

-- Taapsee Pannu is the top actress with having 7.74 avg rating







/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
/*
First we get all the movies which are belongs to Thriller category. Then we categorize them as per their rating.
For the first part, we use CTE to fetch all the movie ID that belong to Thriller genre.
After that we get the rating of the movie from the rating table, we check that movie id belongs to thriller genre
for that we use IN operator to check that movie id is part of thriller list of CTE table. For categorization
we use CASE statement.
*/
-- Get all the movies belong to Thriller genre, we use UPPER function for case insensitive checking
WITH movie_of_thriller_genre AS
(
	SELECT
		movie_id
	FROM
		genre
	WHERE
		UPPER(genre) = 'THRILLER'
)
-- Categorize the movie that belongs to Thriller genre, according to their avg_ rating
SELECT 
	title,
    avg_rating,
    CASE
         WHEN avg_rating > 8 THEN 'Superhit movies'
         WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
         WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
         ELSE 'Flop movies'
	END AS avg_rating_category
	FROM   
		movie AS m
		INNER JOIN 
			ratings AS r
				ON r.movie_id = m.id
	WHERE m.id in (
					SELECT 
						movie_id
					FROM
						movie_of_thriller_genre
				);




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

/*
First we fetch all the genre of the movies along with duration, we have calculate the average duration of each 
genre. After that we calculate its running and moving average using frame. For that we use WINDOW function
*/

-- Fetch the genre and calculate the avg duration of each genre.
WITH genre_duration_summry AS
(
	SELECT 
		genre,
		ROUND(AVG(duration),2) AS avg_duration
	FROM 
		movie AS m 
		INNER JOIN 
			genre AS g 
				ON m.id = g.movie_id
	GROUP BY genre
)
-- Calculate moving average and running total by setting frame using Window function
SELECT
	*,
    SUM( avg_duration ) OVER w1 AS  running_total_duration,
    AVG( avg_duration ) OVER w2 AS moving_avg_duration
FROM
	genre_duration_summry
WINDOW w1 AS ( ORDER BY genre ROWS UNBOUNDED PRECEDING ),
w2 AS ( order by genre ROWS 6 PRECEDING); 



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
/*
To get the desired result
1. First give rank to top genre having rating > 8 and based on the total no. of movies produced in that genre.
2. Once Ranking the genre we extract top 3 genre by putting where clause on genre rank.
3. Now get the details of movies which are produced in top 3 genre, its name, year, worldwide_gross_income, we convert the amount which are in
   Indian currency to $ by dividing the amount by conversion rate of 80. Before that remove the current sysmbol
   we also handle the null value. For doing entire above task, we use case statment.
4. After fetching all the details of movie, we rank the movie as per their income, we consider the converted income value. 
   We use DENSE_RANK for that, partition on Year, becuase we need top 5 movies in each years produced in top 3 genre.
5. After collecting all these data in the final section, we fetch the data of all those movies having rank <=5.
*/
-- Ranking genres who having rating > 8, on the basis of movies produced
WITH top_genres AS
(
    SELECT
		genre,
        COUNT(m.id) AS movie_count ,
		Rank() OVER(ORDER BY COUNT(m.id) DESC) AS genre_rank
	FROM
		movie AS m
		INNER JOIN 
			genre AS g
				ON  g.movie_id = m.id
		INNER JOIN 
			ratings AS r
				ON r.movie_id = m.id
	WHERE
		avg_rating > 8
	GROUP BY   
		genre 
),
-- Fetch top 3 genre from the list
top_3_genre AS
(
	SELECT
		*
	FROM
		top_genres
	WHERE 
		genre_rank <= 3
),
-- fetch the movies details, which produced in the top 3 genre, their genre, year, worldwide_gross_income
-- For conversion of INR to $ we use 75/- = 1 $.
movies_summary_of_top_genre AS
(
	SELECT
		genre,
		year,
		title AS movie_name,
		worlwide_gross_income,
		CASE 
			WHEN  worlwide_gross_income like 'INR %' THEN 
				ROUND(REPLACE(REPLACE( worlwide_gross_income, 'INR',''),'',0) / 75, 2)  
			WHEN  worlwide_gross_income like '$ %' THEN 
				ROUND( REPLACE(REPLACE( worlwide_gross_income, '$',''),'',0)  * 1, 2)
			ELSE
				 0 
		END AS currency_type
	FROM
		movie AS m
		INNER JOIN 
			genre AS g
				ON m.id = g.movie_id
	WHERE genre IN
				  (
					SELECT 
						genre
					 FROM   
						top_3_genre
					)
),
-- Rank the movies as per the worldwise gross income
movies_with_rank_details AS
(
	SELECT 
		genre,
		year,
		movie_name,
		worlwide_gross_income,
		currency_type,
		DENSE_RANK() OVER(partition BY year ORDER BY currency_type  DESC ) AS movie_rank
	FROM
		movies_summary_of_top_genre
)
-- Fetch the movies in each year having rank <= 5
SELECT 
	genre,
    year,
    movie_name,
    CONCAT( '$',currency_type) AS worlwide_gross_income,
    movie_rank
FROM
	movies_with_rank_details
WHERE 
	movie_rank <= 5;


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
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
/*
	1. First give ranking to production company on the basis of movies that had produced, with median rating >= 8
       and in multi lingual. To check the multi lingual we use Position(',' IN languages) > 0 condition.
       We also handle null values in production company column.
	2. Once give ranking to production company, as per the specified condition, we fetch the production details 
    which having rank <=2. Here we use rank to limit the desired output instead of limit for efficiency point of view. 
*/
-- Fetch the details of production, which produced movies in multi lingual 
-- and also having median rating >= 8, also give ranking to it accordingly.
WITH production_company_ranking_summary  AS 
(
	SELECT 
		production_company,
		COUNT(movie_id) AS movie_count,
        Rank()  OVER( ORDER BY COUNT(movie_id) DESC) AS prod_comp_rank
	FROM   
		movie AS m
			inner join 
				ratings AS r
					ON r.movie_id = m.id
	WHERE  
		median_rating >= 8
			AND 
				production_company IS NOT NULL
			AND 
				Position(',' IN languages) > 0
	GROUP  BY 
			production_company
)
-- Fetch production comapny having rank <=2.
SELECT 
	*
FROM 
	production_company_ranking_summary
WHERE
	prod_comp_rank <=2; 

-- Star Cinema and Twentieth Century Fox are the top two production houses 
-- that have produced the highest number of hits among multilingual movies.
-- having movie count 7 and 4 respectively.



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
/*
 1. First get the actress details, who had acted in the Drama genre movies with avg rating > 8, their moving
 count, total votes, and avg rating, we rank the actress on the basis of no. of movies that had acted upon 
 under the specified criteria. We use CTE to fectc all these details.
 2. Once all the details collected, we filter out top 3 actresses on the basis of their rank. Here we use RANK function 
    to give rank to the actresses also filtering out top 3 actresses on this basis of rank instead of
    using costly LIMIT clause.
*/

-- Fetch actress name, their total votes, movie count, avg rating, also rank they acquired on the basis
-- movies count.
WITH actress_ranking_details AS
(
   SELECT     
		n.name AS actress_name,
		SUM( total_votes ) AS total_votes,
		COUNT( r.movie_id ) AS movie_count,
		ROUND( Sum( avg_rating * total_votes )/ Sum( total_votes ), 2 ) AS actress_avg_rating,
		Rank() OVER(ORDER BY COUNT( r.movie_id ) DESC) AS actress_rank
   FROM    
		movie AS m
			INNER JOIN 
				ratings AS r
					ON m.id = r.movie_id
			INNER JOIN 
				role_mapping AS rm
					ON  m.id = rm.movie_id
			INNER JOIN 
					names AS n
						ON rm.name_id = n.id
			INNER JOIN 
					GENRE AS g
						ON g.movie_id = m.id
   WHERE
		UPPER(category) = 'ACTRESS'
			AND
				avg_rating > 8
			AND 
				UPPER(genre) = "DRAMA"
   GROUP BY
		NAME 
)
-- Filter top 3 actresses on the basis of their rank
SELECT   
		*
FROM
	actress_ranking_details 
WHERE
	actress_rank <= 3;

-- Top 3 actresses based on number of Super Hit movies are Parvathy Thiruvothu, Susan Brown 
-- and Amanda Lawrence






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
/*
	1. First we fetch directors details, their id, movie they directed, its rating, along with other details
       we fetch next release date, for that we LEAD window function.
	2. On the basis on these details, and next release date, we calculate the days difference of their next 
       next venture.
	3. Now total their, movie count, avg inter movie days, avg rating, min and max rating, total duration, along with that
       we give rank to these director on the basis of their movie count.
	4. Finally we fetch these details for the top 9 director on the basis of their rank, which we gave on the basis of their movie count.
	   So here we utilize the RANK function to extract top 9 director instead of LIMIT, which is costlier.	
*/
-- Fetch details of director, along with their next release date, using LEAD window function
WITH director_next_published_date_details AS
(
   SELECT
		d.name_id,
		name,
		d.movie_id,
		duration,
		r.avg_rating,
		total_votes,
		m.date_published,
		Lead(date_published,1) OVER(
										partition BY d.name_id 
										ORDER BY date_published,movie_id 
									) AS next_published_date
   FROM       
		director_mapping AS d
			INNER JOIN 
					names AS n
						ON n.id = d.name_id
			INNER JOIN 
					movie AS m
				ON m.id = d.movie_id
			INNER JOIN 
					ratings AS r
				ON r.movie_id = m.id 
), 
-- On the basis next release date, calculate days difference between their two releases. We use
-- Datediff function of MySql.	
top_director_details AS
(
   SELECT *,
		  DATEDIFF( next_published_date, date_published ) AS date_difference
   FROM   
	director_next_published_date_details 
),
-- Now along with calculating the total movie count, avg inter movies days, we give rank to directors
-- on the basis of their no. of movies directed. Which helps to fetch top 9 directors from the list, 
-- without using LIMIT
top_directors_ranking AS
(
	SELECT   
		name_id AS director_id,
		name AS director_name,
		COUNT( movie_id )  AS number_of_movies,
		ROUND( Avg( date_difference ), 2) AS avg_inter_movie_days,
		ROUND( Avg( avg_rating ), 2) AS avg_rating,
		SUM( total_votes ) AS total_votes,
		MIN( avg_rating ) AS min_rating,
		Max( avg_rating ) AS max_rating,
		SUM( duration ) AS total_duration,
        Rank() OVER(ORDER BY COUNT( movie_id ) DESC) AS director_rank
	FROM
		top_director_details
	GROUP BY 
		director_id
)
-- Finally details of top 9 directors.
SELECT
	director_id,
    director_name,
    number_of_movies,
    avg_inter_movie_days,
    avg_rating,
    total_votes,
    min_rating,
    max_rating,
    total_duration
FROM
	top_directors_ranking
WHERE
	director_rank <= 9;





