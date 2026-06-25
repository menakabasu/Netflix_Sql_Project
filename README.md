# Netflix Movies and TV Shows Data Analysis using SQL

![Netflix_Logo](https://github.com/menakabasu/Netflix_Sql_Project/blob/main/logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT 
    type,
    COUNT(*)
FROM netflix
GROUP BY 1;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
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
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
select 	* from netflix 
	where
		type='Movie'
		AND 
		release_year = 2020;
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
select 
			trim(unnest(string_to_array(country,','))) as country_name,
			count(show_id) as total_content
		from netflix 
		where country is not null
		group by country_name
		order by contents desc
		limit 5;
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
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
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
SELECT * FROM NETFLIX
	WHERE 
		to_date(date_added,'Month dd,yyyy')>current_date-INTERVAL '5 years';
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
select * from NETFLIX where director Ilike '%Rajiv Chilaka%';
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
select * from netflix where type='TV Show' 
						  and
						  cast(split_part(duration,' ',1) as integer) > 5
	
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
select 
		trim(unnest(string_to_array(listed_in,','))) as genre,
		count(*) as content_count 
	from netflix 
	group by 1
	order by content_count desc;
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
select 
		extract(year from to_date(date_added,'Month DD,YYYY')) as year,
		round(
		count(*)::numeric/(select count(*) from netflix where country Ilike '%india%')::numeric *100,2) as avg_contents_per_year
	from netflix
	where country Ilike '%india%'
	group by 1
	order by avg_contents_per_year DESC
	limit 5;
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
select 
		title
		from netflix
		where listed_in  ilike '%documentaries%';
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
select * from netflix where director is null;
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
select * from netflix
	where casts ilike '%Salman Khan%'
	AND
	extract(year from to_date(date_added,'Month DD, YYYY')) > extract(year from current_date)-10;
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
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
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
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
	
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.





