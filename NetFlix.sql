--Netflix Project
drop table if exists netflix;
CREATE TABLE netflix
(
		show_id	varchar(6),
		type varchar(10),
		title varchar(150),
		director varchar(208),
		casts	 varchar(1000),
		country	 varchar(150),
		date_added	varchar(50),
		release_year	int,
		rating	varchar(10),
		duration	varchar(15),
		listed_in	varchar(100),
		description varchar(300)
	
);
select * from netflix limit 5;
select * from netflix where  show_id='s4254';
select listed_in from netflix;
select distinct type as content_show  from netflix;
-- is Business Problems
1. Count the number of Movies vs TV Shows
select
	type,
	count(*) as total_content
from netflix
group by type
order by 1

2. Find the most common rating for movies and TV shows
select
	type,rating
from (
	select 
		type,rating,
		count(*) as common_rating,
		rank() over(partition by type order by count(*) desc ) as rank
	from netflix
	where rating is not null
	group by type,rating
	      ) as sub_rank
where rank=1;


3. List all movies released in a specific year (e.g., 2020)
	--filter year 2020 movies
	select 	* from netflix 
	where
		type='Movie'
		AND 
		release_year = 2020;
		
4. Find the top 5 countries with the most content on Netflix
		select 
			trim(unnest(string_to_array(country,','))) as country_name,
			count(show_id) as total_content
		from netflix 
		where country is not null
		group by country_name
		order by contents desc
		limit 5;
		
5. Identify the longest movie
	select type,title,duration
			from netflix 
	where type='Movie' 
	AND 
	duration is not null
	order by CAST(replace(duration,' min','') AS Integer) desc
	limit 1;
	
	select 
			type,title,duration
			from netflix 
	where type='Movie' 
	AND 
	duration is not null
	and
	cast(replace(duration,' min','')as integer)=
						(select max(cast(replace(duration,' min','') as integer) ) from netflix 
						where type='Movie' and duration is not null)
	
	
			
6. Find content added in the last 5 years
	SELECT * FROM NETFLIX
	WHERE 
		to_date(date_added,'Month dd,yyyy')>current_date-INTERVAL '5 years' ;
	

7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
	select * from NETFLIX where director Ilike '%Rajiv Chilaka%';
8. List all TV shows with more than 5 seasons
	select * from netflix where type='TV Show' 
						  and
						  cast(split_part(duration,' ',1) as integer) > 5
	

9. Count the number of content items in each genre
	select 
		trim(unnest(string_to_array(listed_in,','))) as genre,
		count(*) as content_count 
	from netflix 
	group by 1
	order by content_count desc;
			
10.	Find each year and the average numbers of content release in India on netflix. 
	return top 5 year with highest avg content release!

	select 
		extract(year from to_date(date_added,'Month DD,YYYY')) as year,
		round(
		count(*)::numeric/(select count(*) from netflix where country Ilike '%india%')::numeric *100,2) as avg_contents_per_year
	from netflix
	where country Ilike '%india%'
	group by 1
	order by avg_contents_per_year DESC
	limit 5;
	
11. List all movies that are documentaries
		select 
		title
		from netflix
		where listed_in  ilike '%documentaries%';
12. Find all content without a director
select * from netflix where director is null;
13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
	select * from netflix
	where casts ilike '%Salman Khan%'
	AND
	extract(year from to_date(date_added,'Month DD, YYYY')) > extract(year from current_date)-10;
	
14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
		select 
			trim(unnest(string_to_array(casts,','))) as actor,
			count(*) as no_of_movie_appreared_in_each_actor
		from netflix
		where country is not null 
		and
		country ilike '%india%'
		group by 1 
		order by 2 desc
		limit 10;
/*categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.*/

select 
	case 
	when description ilike '%kill%' or
		 description ilike '%violence%' 
	Then 'good Movie'
	else 'Bad Movie'
	end as category,
	count(*) as content_count
from netflix
group by 1
order by 2 desc;
	
