--select count(*) from dbo.youtube_trending;

--select * from dbo.youtube_trending;

--select country, max(publishedAt) as max_publish_date,min(publishedAt) as min_publish_date, max(trending_date) as max_trending_date, min(trending_date) as min_trending_date from dbo.youtube_trending group by country;

--How many trending records does each country have?
SELECT country, COUNT(*) AS total_records
FROM youtube_trending
GROUP BY country;

--How many unique videos are present in each country?
select country, count(distinct video_id) as unique_records from dbo.youtube_trending group by country;

--What is the average view count by country?
select country, Avg(cast(view_count as bigint)) as avg_view_count from dbo.youtube_trending group by country;

--Which country has the highest average likes per video?
select country, avg(cast(likes as bigint)) as avg_likes from dbo.youtube_trending group by country order by avg_likes desc;

--What is the average comment count by country?
select country, avg(cast(comment_count as bigint)) as avg_comment_count from dbo.youtube_trending group by country order by avg_comment_count desc;

--Which country has the highest average engagement rate?

