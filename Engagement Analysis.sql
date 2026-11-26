--What is the like rate for each video?
SELECT 
    title,
    country,
    view_count,
    likes,
    ROUND((CAST(likes AS FLOAT) / NULLIF(view_count, 0)) * 100, 2) AS like_rate
FROM dbo.youtube_trending
ORDER BY like_rate DESC;


--What is the comment rate?
SELECT 
    title,
    country,
    view_count,
    likes,
    ROUND((CAST(comment_count AS FLOAT) / NULLIF(view_count, 0)) * 100, 2) AS comment_rate
FROM dbo.youtube_trending
ORDER BY comment_rate DESC;

--Which videos have high views but low engagement?
SELECT 
    title,
    country,
    view_count,
    likes,
    ROUND((CAST(comment_count + likes AS FLOAT) / NULLIF(view_count, 0)) * 100, 2) AS engagement_rate
FROM dbo.youtube_trending
ORDER BY engagement_rate DESC;

--Which categories generate higher engagement?
select category_name, max(engagement_rate) from dbo.youtube_trending group by category_name;



