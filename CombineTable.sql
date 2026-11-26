SELECT 'CA' AS country, * INTO dbo.youtube_trending_data FROM dbo.CA_youtube_trending_data
UNION ALL
SELECT 'GB' AS country, * FROM dbo.GB_youtube_trending_data
UNION ALL
SELECT 'IN' AS country, * FROM dbo.IN_youtube_trending_data
UNION ALL
SELECT 'JP' AS country, * FROM dbo.JP_youtube_trending_data
UNION ALL
SELECT 'US' AS country, * FROM dbo.US_youtube_trending_data;


SELECT *
FROM youtube_categories;

SELECT
    yt.video_id,
    yt.title,
    yt.country,
    yc.category_name,
    yt.view_count
FROM youtube_trending_data yt
JOIN youtube_categories yc
    ON yt.categoryId = yc.categoryId;


ALTER TABLE dbo.youtube_trending_data
ADD category_name VARCHAR(100);

UPDATE yt
SET yt.category_name = yc.category_name
FROM dbo.youtube_trending_data AS yt
INNER JOIN dbo.youtube_categories AS yc
    ON yt.categoryId = yc.categoryId;

SELECT
    video_id,
    title,
    categoryId,
    category_name,
    country
FROM dbo.youtube_trending_data;


ALTER TABLE dbo.youtube_trending_data
ADD 
    like_rate AS ROUND((CAST(likes AS FLOAT) / NULLIF(view_count, 0)) * 100, 2),
    comment_rate AS ROUND((CAST(comment_count AS FLOAT) / NULLIF(view_count, 0)) * 100, 2),
    engagement_rate AS ROUND((CAST(CAST(comment_count AS BIGINT) + CAST(likes AS BIGINT) AS FLOAT) / NULLIF(view_count, 0)) * 100, 2);



select title, country,view_count, likes,like_rate from dbo.youtube_trending_data order by like_rate desc;


select * from dbo.youtube_trending_data;