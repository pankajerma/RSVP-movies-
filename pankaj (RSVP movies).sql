USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/
show tables;
select count(id),count(*) from movie;
/*. 7997*/
-- Segment 1:
select count(movie_id)as rows_,count(*)from genre;
-- 14662



-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
select count(*)
from director_mapping;
-- there are total of 3,867rows
select count(*)
from genre;
-- there are total of 14662 rows
select count(*)
from movie;
-- there are  7,997 rows
select count(*)
from names;
-- there are total of 25,735 rows
select count(*)
from ratings;
-- there are total of 7997 rows
select count(*)
from role_mapping;
-- there are total of 3,867 rows



-- Q2. Which columns in the movie table have null values?
-- Type your code below:
select count(id) - count(id) as id, count(id)- count(title) as title, count(id) - count(year) as year_,
count(id)- count(date_published) date_published, count(id)- count(duration) as duration,
count(id)- count(country) as country, count(id)- count(worlwide_gross_income) as worlwide_gross_income,
count(id)-count(languages) as languages, count(id)- count(production_company) as production_company
from movie;
# id, title, year_, date_published, duration, country, worlwide_gross_income, languages, production_company
# 0, 0, 0, 0, 0, 20, 3724, 194, 528


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)
select year,count(*) released
from movie
group by year
order by year;
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
select month(date_published) month_num, count(id) number_of_movies
from movie
group by month(date_published)
order by 2 desc;
# month_num, number_of_movies
# month_num, number_of_movies
-- 3, 824
-- 9, 809
-- 1, 804
-- 10, 801
-- 4, 680
-- 8, 678
-- 2, 640
-- 11, 625
-- 5, 625
-- 6, 580
-- 7, 493
-- 12, 438

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
select count(id) as released
from movie
where (country like '%USA%' or country like '%India%') and year = 2019;
-- 1059


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:


select distinct genre
from genre
order by 1;
# genre
-- Action
-- Adventure
-- Comedy
-- Crime
-- Drama
-- Family
-- Fantasy
-- Horror
-- Mystery
-- Others
-- Romance
-- Sci-Fi
-- Thriller


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
select genre,count(*) as movies_produced
from genre 
group by genre
order by 2 desc;
-- 'Drama','4285'
-- 'Comedy','2412'
-- 'Thriller','1484'
-- 'Action','1289'
-- 'Horror','1208'
-- 'Romance','906'
-- 'Crime','813'
-- 'Adventure','591'
-- 'Mystery','555'
-- 'Sci-Fi','375'
-- 'Fantasy','342'
-- 'Family','302'
-- 'Others','100'


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
WITH one_genre AS (
	SELECT movie_id,
		COUNT(genre) AS genres
	FROM genre
	GROUP BY movie_id
	HAVING genres = 1)

SELECT COUNT(movie_id) AS Single_Genre
FROM one_genre;
-- 3289

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)
select a.genre, round(avg(m.duration), 2) avg_duration
from genre a
inner join movie m on a.movie_id = m.id
group by a.genre
order by 1 desc, 2 desc;

# genre, avg_duration
-- Action, 112.8829
-- Romance, 109.5342
-- Crime, 107.0517
-- Drama, 106.7746
-- Fantasy, 105.1404
-- Comedy, 102.6227
-- Adventure, 101.8714
-- Mystery, 101.8000
-- Thriller, 101.5761
-- Family, 100.9669
-- Others, 100.1600
-- Sci-Fi, 97.9413
-- Horror, 92.7243

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)

select genre, count(*) movie_count, rank() over (order by count(*) desc) genre_rank
from genre
group by genre;

-- # genre, movie_count, genre_rank
-- Drama, 4285, 1
-- Comedy, 2412, 2
-- Thriller, 1484, 3
-- Action, 1289, 4
-- Horror, 1208, 5
-- Romance, 906, 6
-- Crime, 813, 7
-- Adventure, 591, 8
-- Mystery, 555, 9
-- Sci-Fi, 375, 10
-- Fantasy, 342, 11
-- Family, 302, 12
-- Others, 100, 13
/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


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
select * from ratings
limit 10;

select min(avg_rating) min_avg_rating, max(avg_rating) max_avg_rating , min(total_votes) min_total_votes , 
       max(total_votes) max_total_votes , min(median_rating) min_median_rating , max(median_rating) max_median_rating
from ratings;

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
select title ,avg_rating , rank() over( order by avg_rating desc ) movie_rank
from ratings a
join movie b on a.movie_id=b.id
order by 3;
-- It's ok if RANK() or DENSE_RANK() is used too
# title							avg_rating	movie_rank
-- Kirket							10.0	1
-- Love in Kilnerry					10.0	1
-- Gini Helida Kathe				9.8		3
-- Runam							9.7		4
-- Fan								9.6		5
-- Android Kunjappan Version 5.25	9.6		5
-- Yeh Suhaagraat Impossible		9.5		7
-- Safe								9.5		7
-- The Brighton Miracle				9.5		7
-- Shibu							9.4		10


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
select median_rating , count(movie_id) movie_count

from ratings 
group by median_rating 
order by 2 desc ; 



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

select m.production_company , count(m.id) as movie_count , 
       rank() over(order by count(m.id) desc) prod_company_rank
from ratings r
inner join movie m on r.movie_id=m.id
where r.avg_rating > 8
group by m.production_company
limit 5;

# production_company 		movie_count 	prod_company_rank
-- Dream Warrior Pictures 	 3 					2
-- National Theatre Live 	 3					2
-- Lietuvos Kinostudija		 2					4
-- Swadharm Entertainment	 2					4


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
select genre , count(m.id) as movie_count
from movie m 
join ratings r on m.id=r.movie_id
join genre g on m.id=g.movie_id
where total_votes > 1000 AND month(date_published)= 3 AND m.year=2017
and m.country like '%USA%'
group by genre
order by 2 desc;

# genre	movie_count
-- Drama	24
-- Comedy	9
-- Action	8
-- Thriller	8
-- Sci-Fi	7
-- Crime	6
-- Horror	6
-- Mystery	4
-- Romance	4
-- Fantasy	3
-- Adventure	3
-- Family	1

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
select title , avg_rating , genre

from movie m 
join ratings r on m.id=r.movie_id
join genre g on m.id=g.movie_id
where avg_rating > 8
and m.title like 'The%'
order by 2 desc ;

# title	avg_rating	genre
-- The Brighton Miracle	9.5	Drama
-- The Colour of Darkness	9.1	Drama
-- The Blue Elephant 2	8.8	Drama
-- The Blue Elephant 2	8.8	Horror
-- The Blue Elephant 2	8.8	Mystery
-- The Irishman	8.7	Crime
-- The Irishman	8.7	Drama
-- The Mystery of Godliness: The Sequel	8.5	Drama
-- The Gambinos	8.4	Crime
-- The Gambinos	8.4	Drama
-- Theeran Adhigaaram Ondru	8.3	Action
-- Theeran Adhigaaram Ondru	8.3	Crime
-- Theeran Adhigaaram Ondru	8.3	Thriller
-- The King and I	8.2	Drama
-- The King and I	8.2	Romance


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

select count(m.id) 
from movie m 
inner join ratings r on m.id=r.movie_id
where median_rating = 8 and date_published between '2018-04-01' and '2019-04-01' ;

-- 361

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

select country, sum(r.total_votes)

from movie m 
join ratings r on m.id=r.movie_id
where country like '%German%' or  country like '%Ital%' 
group by country ;

select sum(total_votes)
from movie m 
join ratings r on m.id=r.movie_id
where country like '%Germany%' ;
-- 2026223

select sum(total_votes)
from movie m 
join ratings r on m.id=r.movie_id
where country like '%Italy%';

-- 703024
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

select count(id)-count(id) , count(id)-count(name),
count(id)-count(height),count(id)-count(date_of_birth),count(id)-count(known_for_movies)
from names;

-- '0','0','17335','13431','15226'
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
with top_3_genres as (
select genre, count(g.movie_id) as movie_counts
			from genre as g
			join ratings as r on r.movie_id=g.movie_id
            where avg_rating>8
            group by genre
            order by movie_counts desc
            limit 3
            )
select n.name as director_name, count(g.movie_id) as movie_count
from names n
join director_mapping as d
on n.id=d.name_id
join genre as g
on d.movie_id=g.movie_id
join ratings as r
on r.movie_id=g.movie_id,
top_3_genres
where g.genre in (top_3_genres.genre)  and avg_rating> 8           
group by director_name
order by movie_count desc
;


-- James Mangold	4	
-- Anthony Russo	3	
-- Joe Russo	3


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
select n.name, count(r.movie_id), rank() over (order by count(r.movie_id) desc) actor_rank
from ratings r
join role_mapping rm on r.movie_id = rm.movie_id
join names n on rm.name_id = n.id
where median_rating >= 8
group by n.name
order by 3
limit 2;
-- 'Mammootty','8','1'
-- 'Mohanlal','5','2'
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
select m.production_company, sum(r.total_votes) total_votes, 
rank() over (order by sum(r.total_votes) desc) votes_rank
from movie m
join ratings r on m.id = r.movie_id
group by m.production_company
order by 3
limit 3;

# production_company, total_votes, votes_rank
-- Marvel Studios, 2656967, 1
-- Twentieth Century Fox, 2411163, 2
-- Warner Bros., 2396057, 3

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

with indian_actor_rank as
(
select n.name,
		sum( total_votes) as total_votes, 
		count(r.movie_id) as movie_count, 	
        round(sum(avg_rating*total_votes)/sum(total_votes),2) as actor_avg_rating
from movie as  m
join ratings as r 
on m.id=r.movie_id
join role_mapping as rm 
on m.id=rm.movie_id
join names as n
on rm.name_id=n.id
where country like 'India' and category ='actor'
group by name
)
select * , 	rank() over (order by actor_avg_rating desc,total_votes desc) as actor_rank
from indian_actor_rank
where movie_count>=5
;

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
with hindi_actress_rank as
(
select n.name,
		sum( total_votes) as total_votes, 
		count(r.movie_id) as movie_count, 	
        round(sum(avg_rating*total_votes)/sum(total_votes),2) as actress_avg_rating
from movie as  m
join ratings as r 
on m.id=r.movie_id
join role_mapping as rm 
on m.id=rm.movie_id
join names as n
on rm.name_id=n.id
where country like 'India' and category ='actress' and languages='hindi'
group by name
)
select * , 	rank() over (order by actress_avg_rating desc,total_votes desc) as actress_rank
from hindi_actress_rank
where movie_count>=3
;

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT m.title,
	r.avg_rating,
	CASE
		WHEN avg_rating > 8 THEN 'Superhit'
		WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit'
		WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch'
		ELSE 'Flop movies'
	END AS movie_type
FROM movie m INNER JOIN ratings r
	ON m.id = r.movie_id INNER JOIN genre g
		ON m.id = g.movie_id
WHERE genre = 'thriller';



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


WITH Genre AS (
	SELECT g.genre,
		ROUND(AVG(m.duration), 2) AS avg_duration
	FROM movie m INNER JOIN genre g
		ON m.id = g.movie_id
	GROUP BY genre)

SELECT *,
	SUM(avg_duration) OVER w1 AS running_total_duration,
    AVG(avg_duration) OVER w2 AS moving_avg_duration
FROM Genre
WINDOW w1 AS (ORDER BY avg_duration ROWS UNBOUNDED PRECEDING),
	   W2 AS (ORDER BY avg_duration ROWS 3 PRECEDING);
# genre, avg_duration, running_total_duration, moving_avg_duration
-- Horror, 92.72, 92.72, 92.720000
-- Sci-Fi, 97.94, 190.66, 95.330000
-- Others, 100.16, 290.82, 96.940000
-- Family, 100.97, 391.79, 97.947500
-- Thriller, 101.58, 493.37, 100.162500
-- Mystery, 101.80, 595.17, 101.127500
-- Adventure, 101.87, 697.04, 101.555000
-- Comedy, 102.62, 799.66, 101.967500
-- Fantasy, 105.14, 904.80, 102.857500
-- Drama, 106.77, 1011.57, 104.100000
-- Crime, 107.05, 1118.62, 105.395000
-- Romance, 109.53, 1228.15, 107.122500
-- Action, 112.88, 1341.03, 109.057500



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
SELECT genre,
	COUNT(movie_id) AS movie_count
FROM genre
GROUP BY genre
ORDER BY movie_count DESC
LIMIT 3;

-- The TOP 3 genre are 'Drama', 'Comedy' and 'Thriller'.

WITH Top AS (
	SELECT g.genre,
		m.year,
		m.title AS movie_name,
		m.worlwide_gross_income,
		DENSE_RANK () OVER ( PARTITION BY year ORDER BY worlwide_gross_income DESC) AS movie_rank
	FROM movie m INNER JOIN genre g
		ON m.id = g.movie_id
	WHERE genre IN ('Drama', 'Comedy', 'Thriller') AND worlwide_gross_income IS NOT NULL)

SELECT *
FROM Top
WHERE movie_rank <= 5
GROUP BY (movie_name);






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

select production_company , count(m.id) as movie_count, rank() over (order by count(id) desc) as prod_comp_rank
from movie as m
join ratings as r 
on m.id=r.movie_id
where r.median_rating>=8 and production_company is not null and position(',' in languages)>0
group by production_company 
limit 2;






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
WITH Top AS (
	SELECT n.name AS actress_name,
		r.total_votes,
		m.id,
		r.total_votes * r.avg_rating AS w_avg
	FROM names n INNER JOIN role_mapping ro
		ON n.id = ro.name_id INNER JOIN ratings r
			ON ro.movie_id = r.movie_id INNER JOIN movie m 
				ON m.id = r.movie_id INNER JOIN genre g
					ON m.id = g.movie_id
	WHERE category = 'Actress' AND  genre = 'Drama' AND avg_rating >8),

Actress AS (
	SELECT *,
		SUM(w_avg) OVER w1 AS rating,
		SUM(total_votes) OVER w2 AS votes
	FROM Top
	WINDOW w1 AS (PARTITION BY actress_name),
		w2 AS (PARTITION BY actress_name)),

Rating AS (
	SELECT actress_name,
		votes AS total_votes,
		COUNT(id) AS movie_count,
		ROUND(rating/votes, 2) AS actress_avg_rating
	FROM Actress
	GROUP BY actress_name)

SELECT *,
	DENSE_RANK () OVER (ORDER BY movie_count DESC) AS actress_rank
FROM Rating;
-- LIMIT 3;


-- OR with just avg_rating

With Top AS (
	SELECT n.name AS actress_name,
		SUM(total_votes) AS total_votes,
		COUNT(m.id) AS movie_count,
		r.avg_rating
	FROM names n INNER JOIN role_mapping ro
		ON n.id = ro.name_id INNER JOIN ratings r
			ON ro.movie_id = r.movie_id INNER JOIN movie m 
				ON m.id = r.movie_id INNER JOIN genre g
					ON m.id = g.movie_id
	WHERE category = 'Actress' AND  genre = 'Drama' AND avg_rating > 8
	GROUP BY actress_name)

SELECT *,
	DENSE_RANK () OVER ( ORDER BY movie_count DESC) AS actress_rank
FROM Top
LIMIT 3;


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
select name,
count(movie_id) as movies
from director_mapping d inner join names n
on n.id = d.name_id
group by name
order by movies desc
limit 9;
-- Top 9 directors are 'A.L. Vijay', 'Andrew Jones', 'Chris Stokes', 'Justin Price', 'Jesse V. Johnson', 'Steven Soderbergh', 'Sion Sono', 'Özgür Bakar', 'Sam Liu


with a as(
SELECT name,
	date_published
from movie m inner join director_mapping d
on m.id = d.movie_id inner join names n
on n.id = d.name_id
where name in ('A.L. Vijay', 'Andrew Jones', 'Chris Stokes', 'Justin Price', 'Jesse V. Johnson', 
				'Steven Soderbergh', 'Sion Sono', 'Özgür Bakar', 'Sam Liu')),
-- ORDER BY name, date_published),

b as(
select *,
	lead (date_published, 1) over (partition by name
									order by date_published) as next_movie
from a)

SELECT *,
datediff(next_movie, date_published) as days
from b;



SELECT n.Name,
	COUNT(d.movie_id) AS Movie_Count
FROM names n INNER JOIN director_mapping d
	ON n.id = d.name_id
GROUP BY Name
ORDER BY Movie_Count DESC
LIMIT 9;
 /* Top 9 directors are 'A.L. Vijay', 'Andrew Jones', 'Chris Stokes', 'Justin Price', 
 'Jesse V. Johnson', 'Steven Soderbergh', 'Sion Sono', 'Özgür Bakar', 'Sam Liu' */
 
 -- Fetching the other required details.
 WITH Top AS (
	 SELECT d.name_id AS director_id,
		n.name AS director_name,
		m.id,
		m.date_published,
		r.avg_rating,
		r.total_votes,
		m.duration,
		LEAD (date_published, 1) OVER w1 AS next_movie,
		MIN(avg_rating) OVER w2 AS min_rating,
		MAX(avg_rating) OVER w3 AS max_rating
	FROM names n INNER JOIN director_mapping d
		ON n.id = d.name_id INNER JOIN movie m
			ON m.id = d.movie_id INNER JOIN ratings r
				ON m.id = r.movie_id
	WHERE name IN ('A.L. Vijay', 'Andrew Jones', 'Chris Stokes', 'Justin Price', 'Jesse V. Johnson',
					'Steven Soderbergh', 'Sion Sono', 'Özgür Bakar', 'Sam Liu')
	WINDOW w1 AS ( PARTITION BY name
				   ORDER BY  date_published),
			w2 AS (PARTITION BY name),
			w3 AS (PARTITION BY name)),

Nine AS (
	SELECT *,
		DATEDIFF(next_movie, date_published) AS Days
	FROM Top),

Directors AS (
	SELECT *,
		ROUND(AVG((Days)) OVER (PARTITION BY director_name
						ORDER BY date_published)) AS avg_inter_movie_days
	FROM Nine)

SELECT director_id,
	director_name,
    COUNT(id) AS number_of_movies,
    avg_inter_movie_days,
    avg_rating,
    SUM(total_votes) AS total_votes,
    min_rating,
    max_rating,
    SUM(duration) AS total_duration
FROM Directors
GROUP BY director_name;




