# YouTube Global Market Intelligence & Content Performance Analysis

A SQL Server + Power BI project exploring historical YouTube Trending data across **India, the United States, Great Britain, Japan, and Canada**.

The project investigates what content trends, how category preferences vary by market, how often videos cross borders, and whether views translate into audience engagement.

> **Dataset note:** This is historical trending-list data, not a live view of YouTube or a representative measure of the entire YouTube audience. A trending appearance is a record of a video appearing in a country's trending list on a particular date.

> Link: https://www.kaggle.com/datasets/rsrishav/youtube-trending-video-dataset

---

## Dashboard

The report is organized into three analytical pages:

### 1. Global Content Intelligence
A high-level view of trending volume, unique videos, channels, category coverage, country share, activity over time, and category distribution across markets.

### 2. Regional Market Insights
Compares recorded views and engagement across countries, identifies video outliers, ranks channels by trending appearances, and provides a detailed video-level table.

### 3. Content Strategy Insights
Explores global versus local content, category engagement, market quality, category mix over time, and monthly growth.



---

## Business Questions

- Which content categories account for the largest share of trending appearances?
- Do countries have similar category preferences, or does each market have its own content mix?
- How many videos trend in more than one country?
- Which categories have higher recorded engagement?
- Which channels appear most frequently in trending lists?
- Does higher view count correspond to higher engagement?
- How does trending activity and category mix change over time?

---

## Data & Technology Stack

| Tool | Use |
|---|---|
| **SQL Server** | Dataset consolidation, category mapping, calculated metrics, and analytical queries |
| **Python** | Converting YouTube category JSON reference files into CSV |
| **Power BI** | Interactive report, KPI cards, slicers, charts, and video-level analysis |
| **DAX** | Power BI measures and calculated columns |

### Data sources and fields

The project combines country-level historical YouTube Trending datasets. The main fields used include:

`video_id`, `title`, `publishedAt`, `channelId`, `channelTitle`, `categoryId`, `trending_date`, `view_count`, `likes`, `comment_count`, and `country`.

Category reference JSON files map numeric `categoryId` values to readable category names.

---

## Data Preparation & Analysis Process

1. **Combined country datasets**  
   Consolidated the five country datasets into one SQL Server table and added a `country` code so each record retained its market identity.

2. **Converted category metadata**  
   Used Python to convert the country-specific JSON category reference files into a CSV lookup table.

3. **Mapped category names**  
   Imported the lookup CSV into SQL Server and joined it to the main trending table, making category names available for analysis and visualization.

4. **Created engagement metrics**  
   Calculated like rate, comment rate, and engagement rate using recorded views, likes, and comments.

5. **Performed SQL analysis**  
   Analysed trending appearances, unique videos, category performance, country-level market patterns, channel appearances, cross-market reach, and time-based trends.

6. **Built the Power BI report**  
   Connected Power BI to the prepared SQL Server data and created interactive visuals with country, category, and date filters.

---

## SQL Workflow

### 1. Combine country datasets

Use `UNION ALL` to preserve all trending records. Include the country code as a column.

```sql
SELECT 'CA' AS country, * INTO dbo.youtube_trending_data FROM dbo.CA_youtube_trending_data
UNION ALL
SELECT 'GB' AS country, * FROM dbo.GB_youtube_trending_data
UNION ALL
SELECT 'IN' AS country, * FROM dbo.IN_youtube_trending_data
UNION ALL
SELECT 'JP' AS country, * FROM dbo.JP_youtube_trending_data
UNION ALL
SELECT 'US' AS country, * FROM dbo.US_youtube_trending_data;
```

**Why `UNION ALL`?** Each row represents a trending record. Repeated appearances across dates and countries are meaningful, so the consolidation should not silently remove them.


After importing the Python-generated category CSV into this table, add a category name column to the main table:

```sql
ALTER TABLE dbo.youtube_trending_data ADD category_name VARCHAR(100);
```

Populate the category names:

```sql
UPDATE yt
SET yt.category_name = yc.category_name
FROM dbo.youtube_trending_data AS yt
INNER JOIN dbo.youtube_categories AS yc
    ON yt.categoryId = yc.categoryId;
```

### 3. Calculate engagement rates

```sql
ALTER TABLE dbo.youtube_trending_data
ADD 
    like_rate AS ROUND((CAST(likes AS FLOAT) / NULLIF(view_count, 0)) * 100, 2),
    comment_rate AS ROUND((CAST(comment_count AS FLOAT) / NULLIF(view_count, 0)) * 100, 2),
    engagement_rate AS ROUND((CAST(CAST(comment_count AS BIGINT) + CAST(likes AS BIGINT) AS FLOAT) / NULLIF(view_count, 0)) * 100, 2);
```

`NULLIF(view_count, 0)` prevents division by zero. These formulas use likes and comments as recorded in the dataset; dislikes are not included in the engagement rate.

---

## Important Formulas & Metrics

| Metric | Formula / definition |
|---|---|
| Trending Appearances | Count of rows in the trending dataset |
| Unique Trending Videos | Distinct count of `video_id` |
| Like Rate (%) | `likes / view_count × 100` |
| Comment Rate (%) | `comment_count / view_count × 100` |
| Engagement Rate (%) | `(likes + comment_count) / view_count × 100` |
| Category Share (%) | Category trending appearances / total trending appearances × 100 |
| Countries per Video | Distinct countries in which a `video_id` appears |
| Global Videos (%) | Unique videos appearing in 2 or more countries / all unique videos × 100 |
| Top 10 Channel Share (%) | Top 10 channel appearances / all trending appearances × 100 |
| Month-over-Month Growth (%) | `(current month appearances − previous month appearances) / previous month appearances × 100` |


### Power BI measure examples

```DAX
Trending Appearances = 
COUNTROWS(YouTubeTrendingData)
```

```DAX
Unique Video Apperances = DISTINCTCOUNT(YouTubeTrendingData[video_id])
```

```DAX
Total Channels = DISTINCTCOUNT(YouTubeTrendingData[channel_id])
```

```DAX
Global Videos % = 
DIVIDE ( [Videos in Multiple Countries], DISTINCTCOUNT ( YouTubeTrendingData[video_id] ) )
```

```DAX
Countries_per_Video = 
CALCULATE(
    DISTINCTCOUNT(YouTubeTrendingData[country]),
    ALLEXCEPT(
        YouTubeTrendingData,
        YouTubeTrendingData[video_id]
    )
)
```

---

## Key Insights

### Dataset scale
- **1,326,375 trending appearances**
- **189,180 unique videos**
- **20,290 channels**
- **5 countries**
- **15 categories**
- Historical coverage shown in the report: **August 2020 – April 2024**

### Category performance
- **Entertainment** is the largest category, accounting for **26.8%** of trending appearances.
- **Gaming (15.5%)** and **Music (13.7%)** follow Entertainment in appearance share.
- **Comedy (7.19%)** and **Music (7.09%)** have the highest average engagement rates.
- Music combines strong engagement with the highest average recorded views (**4.5M**), making it a standout category for both reach and interaction.
- **News & Politics (1.75%)** and **Sports (2.38%)** have the lowest engagement rates in the analysis.
- Sports has substantial trending volume, but its audience appears to interact less relative to recorded views.

### Country and market differences
- India has the highest number of unique trending videos (**78.8K**, compared with approximately **47K** in the US).
- India's trending list shows the fastest churn in the analysis and is strongly Entertainment-oriented (**39%** of its trending appearances).
- Sports accounts for only **2.9%** of India's trending appearances, compared with **18%** in Great Britain.
- Japan's recorded engagement rate is lower (**3.3%**, versus approximately **5.3–5.7%** in other markets). However, around **7%** of Japan's records have ratings disabled / zero likes, so this difference may be partly caused by data availability and should not be interpreted as a definitive audience behaviour gap.

### Global reach
- Only **21.76%** of unique videos trend in more than one country; approximately **78%** appear in only one market.
- Just **0.17%** of videos trend in all five countries.
- Videos that trend across all five markets include prominent K-pop acts such as BTS and BLACKPINK.

### Channel landscape
- The top 10 channels account for approximately **2.28%** of trending appearances.
- This indicates that trending appearances are distributed across a large number of channels rather than being dominated by a small group.
- Frequent channel names include The United Stand, Vijay Television, NBA, and MrBeast.

### Timing and engagement
- The typical video trends approximately **3 days after publication**.
- View count and engagement show very little relationship in the analysis (rank correlation approximately **0.06**): high reach does not necessarily mean high interaction.
- One extreme record, **“Discord Loot Boxes are here”**, has approximately **1.4B recorded views**. It should be investigated as a possible promotional or data anomaly and tested separately because it can distort average-view metrics.

---

## Analytical Caveats

- A trending appearance is not a unique video. A video may appear on multiple dates and in multiple countries.
- `view_count`, likes, and comments are recorded snapshots and may be repeated across trending dates. Do not sum repeated snapshots and describe them as unique total views.
- Average metrics can be influenced by outliers. Consider median values or a sensitivity check with and without extreme records.
- Zero likes may reflect disabled ratings or missing data; it should not automatically be interpreted as zero audience engagement.
- The dataset represents videos selected for trending, not all YouTube videos or all viewers.
- The analysis is descriptive. It identifies patterns and associations; it does not establish that a category, country, or channel caused a video to trend.

---

## Project Outcome

This project demonstrates an end-to-end analytics workflow:

**Raw multi-country data → Python metadata preparation → SQL Server data integration and metric creation → SQL analysis → Power BI interactive reporting**

It combines data cleaning and integration, SQL querying, metric design, market comparison, exploratory analysis, and dashboard storytelling to turn historical trending records into content and market insights.
