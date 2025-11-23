# Movies Analysis (SQL)

**Author:** Ajay Borah — Data Analyst | SQL | Power Bi | Python

---

## Project Overview

This project follows a complete end-to-end analytics workflow:

1. **Explore data in Excel** (initial understanding, checking structure, spotting missing values).
2. **Perform Exploratory Data Analysis (EDA) in Python** using Pandas, NumPy, Matplotlib.
3. **Run detailed analysis in MySQL** to generate insights.
4. **Create interactive visualizations in Power BI** for final storytelling and dashboards.


This repository contains an end-to-end analysis of a large Movies dataset using **MySQL** (primary analysis) and **Python (pandas)** for data cleaning. The goal is to uncover trends about movie popularity, ratings, release patterns, language insights, and text-based themes — and to produce actionable recommendations for streaming platforms and stakeholders.

Key dataset columns:

* `title` — Movie title
* `release_date` — Release date (DATE)
* `original_language` — Language of the movie
* `popularity` — Popularity score
* `vote_average` — Average audience rating
* `vote_count` — Number of votes
* `overview` — Movie description (text)

---

## Repository Contents

* `sql/` — SQL scripts to create database, load data, and run analysis queries
* `data/` — Cleaned CSV dataset (not included in repo for size/privacy reasons)
* `notebooks/` — Optional Python notebooks used for cleaning & exploratory work
* `README.md` — This document

---

## Database Setup (MySQL)

**Note:** These SQL commands assume MySQL with `LOCAL_INFILE` enabled.

```sql
DROP DATABASE IF EXISTS Movies_db;
CREATE DATABASE Movies_db;
USE Movies_db;

CREATE TABLE movies (
  title VARCHAR(100),
  release_date DATE,
  original_language VARCHAR(100),
  popularity FLOAT,
  vote_count INT,
  vote_average FLOAT,
  overview VARCHAR(700)
);

SET GLOBAL LOCAL_INFILE=ON;

LOAD DATA LOCAL INFILE "C:/Movies/cleand_movies_dataset.csv"
INTO TABLE movies
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
```

---

## Analysis Performed (Key Questions)

The analysis answers 18 important questions across these themes:

### Popularity Analysis

* Top most-popular movies
* Yearly popularity trends
* Relationship between `vote_count` and `popularity`
* High popularity but low vote-count movies (identifying trending/new titles)

### Rating Analysis

* Highest-rated movies
* Languages with top ratings
* Characteristics of successful movies (popularity, votes, rating)

### Language Insights

* English vs non-English popularity and volume
* Highest-rated languages (by average rating)

### Release Trends

* Movies released per year
* Best months for movie success
* Popularity by release month

### Text Analysis

* Most frequent keywords in `overview`
* Themes: "love", "war", "family", "hero", etc.

### Recommendation System

* Identified titles suitable for OTT/streaming platforms:

  * high popularity
  * good ratings
  * low (or growing) vote counts — often newer trending titles

---

## Key Findings (Summary)

### Numeric Insights & Context

* **Total Movies Analyzed:** 10,000+ (after cleaning)
* **Languages Covered:** 50+ languages
* **Highest Popularity Score (Top Movie):** ~900.5
* **Average Popularity Across Dataset:** ~32.7
* **Highest Vote Average (Rating):** 9.5
* **Overall Average Rating:** 6.3
* **Year with Maximum Movie Releases:** 2025 (approx. 1,200 movies)
* **OTT-Ready Movies Identified:** 778
* **Keyword Frequency (Top Themes):**

  * "Love" → 3,200+ appearances
  * "War" → 1,150+ appearances
  * "Family" → 2,000+ appearances
  * "Hero" → 900+ appearances

These numeric insights add context to the trends observed across popularity, ratings, languages, and text analysis.

### Summary

* **Popularity Trends:** Newer movies (2023–2025) show the highest popularity. Popularity rises across years; recent releases perform the best.
* **Ratings:** Thai, Chinese, Japanese, and Korean movies show strong average ratings. English-language movies dominate total volume.
* **Release Patterns:** Most movies in the dataset were released in 2025, 2024, and 2023. Top-performing months: **June, April, September**.
* **Success Factors:** Successful movies often have high vote counts, high popularity, ratings above average, and strong thematic keywords (love, adventure, conflict).
* **OTT Recommendations:** 778 movies flagged as good streaming candidates based on the combined criteria above.

---

## How to Use This Project

1. **Clone the repository**

```bash
git clone https://github.com/yourusername/movies-analysis-sql.git
cd movies-analysis-sql
```

2. **Prepare your CSV**

* Place the cleaned CSV at the path used in the SQL `LOAD DATA LOCAL INFILE` command or update the path.
* Make sure the CSV columns match the table schema.

3. **Import SQL script**

* Open MySQL Workbench (or your preferred client) and run the SQL scripts in `sql/` to create the database, table, and load the dataset.

4. **Run analysis queries**

* Use the provided SQL queries to reproduce the analysis and insights. Queries are grouped by theme (popularity, ratings, language, release trends, text analysis).

5. **(Optional) Re-run cleaning & text analysis**

* Python notebooks in `notebooks/` include the data cleaning steps and the text-processing used for keyword extraction and theme detection.

---

## Example SQL Queries (short list)

* Top 10 most popular movies:

```sql
SELECT title, popularity
FROM movies
ORDER BY popularity DESC
LIMIT 10;
```

* Movies per year:

```sql
SELECT YEAR(release_date) AS year, COUNT(*) AS movie_count
FROM movies
GROUP BY year
ORDER BY year DESC;
```

* Average rating by language:

```sql
SELECT original_language, AVG(vote_average) AS avg_rating, COUNT(*) AS n
FROM movies
GROUP BY original_language
HAVING n > 10
ORDER BY avg_rating DESC;
```

---

## Recommendation Logic (brief)

Movies recommended for OTT were filtered by:

* `popularity` above dataset mean (or a chosen percentile)
* `vote_average` above dataset mean (or a chosen threshold)
* `vote_count` relatively low or recently rising (to surface new trending titles)

The exact SQL rules and thresholds are available in `sql/queries_recommendations.sql`.

---

## Tools & Technologies

* **MySQL** — primary analysis & SQL queries
* **Python (pandas)** — data cleaning and text processing
* **CSV** — dataset source
* **GitHub** — project hosting and version control

---

## Next Steps & Ideas

* Add time-series forecasting for popularity and release-volume by month/year.
* Build a simple dashboard (Power BI / Tableau) to visualize top trends and OTT recommendations.
* Enhance recommendation engine with collaborative signals (if user ratings or watch history are available).

---

## License

This project is provided for analysis and educational purposes. Add a license file (e.g., MIT) if you want to make it open source.

---
