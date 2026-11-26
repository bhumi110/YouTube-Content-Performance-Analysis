--Which categories have the highest number of trending appearances?
select category_name, count(video_id) as trending_appearances from dbo.youtube_trending group by category_name order by trending_appearances desc;

--Which categories have the highest average views?
select category_name, Avg(cast(view_count as bigint)) as avg_view_count from dbo.youtube_trending group by category_name order by avg_view_count desc;

--What is the most popular category in each country?
select country, Max(category_name) as popular_category, count(video_id) as total_videos from dbo.youtube_trending group by country order by total_videos desc;