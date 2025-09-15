# Netflix Movies and TV Shows Data Analysis 📺

A comprehensive SQL analysis of Netflix's content catalog using SQL Server, exploring viewing patterns, content distribution, and key insights from the streaming platform's extensive library.

## 📋 Table of Contents
- [Project Overview](#project-overview)
- [Dataset](#dataset)
- [Key Analysis Questions](#key-analysis-questions)
- [Technologies Used](#technologies-used)
- [Database Schema](#database-schema)
- [Key Insights](#key-insights)
- [SQL Queries & Analysis](#sql-queries--analysis)
- [Getting Started](#getting-started)
- [Files in Repository](#files-in-repository)
- [Future Enhancements](#future-enhancements)
- [Connect With Me](#connect-with-me)

## 🎯 Project Overview

This project analyzes Netflix's movies and TV shows dataset to uncover interesting patterns and insights about:
- Content distribution between movies and TV shows
- Rating patterns and popularity
- Geographic content distribution
- Genre analysis and trends
- Content release patterns over time
- Director and actor analytics

## 📊 Dataset

**Source**: Netflix Titles Dataset  
**Format**: CSV file with 12 columns  
**Records**: 8,807

### Dataset Columns:
| Column | Description |
|--------|-------------|
| show_id | Unique identifier for each title |
| type | Content type (Movie/TV Show) |
| title | Name of the movie/show |
| director | Director(s) of the content |
| cast | Main cast members |
| country | Country/countries of production |
| date_added | Date when added to Netflix |
| release_year | Original release year |
| rating | Content rating (PG, R, etc.) |
| duration | Length (minutes for movies, seasons for TV shows) |
| listed_in | Genres/categories |
| description | Plot summary |

## 🔍 Key Analysis Questions

This project answers 15 comprehensive questions about Netflix content:

1. **Content Distribution**: Count of Movies vs TV Shows
2. **Rating Analysis**: Most common ratings for different content types
3. **Temporal Analysis**: Content released in specific years
4. **Geographic Insights**: Countries with most Netflix content
5. **Duration Analysis**: Longest movies and TV shows with most seasons
6. **Recent Content**: Content added in recent years
7. **Director Analysis**: Content by specific directors
8. **Genre Distribution**: Content count across different genres
9. **Release Patterns**: Monthly release averages by country
10. **Documentary Analysis**: Filtering documentary content
11. **Data Quality**: Identifying missing director information
12. **Actor Analysis**: Specific actor appearances and top performers
13. **Content Categorization**: Content classification based on description keywords

## 🛠️ Technologies Used

- **Database**: Microsoft SQL Server
- **Language**: T-SQL
- **Tools**: SQL Server Management Studio (SSMS)
- **Techniques**: 
  - Window Functions (RANK, PARTITION BY)
  - Common Table Expressions (CTEs)
  - String manipulation (STRING_SPLIT, TRIM)
  - Date functions (DATEADD, YEAR, MONTH)
  - Conditional logic (CASE statements)
  - Data type conversion (TRY_CAST)

## 🗄️ Database Schema

```sql
CREATE DATABASE NetflixMoviesData;

-- Main table structure
TABLE netflix (
    show_id VARCHAR(10),
    show_type VARCHAR(10),  -- Renamed from 'type'
    title VARCHAR(200),
    director TEXT,
    casts TEXT,            -- Cast information
    country TEXT,
    date_added VARCHAR(20),
    release_year INT,
    rating VARCHAR(10),
    duration VARCHAR(15),
    listed_in TEXT,        -- Genres
    description TEXT
);
```

## 🎯 Key Insights

### Content Distribution
- **Movies vs TV Shows**: Analysis reveals the proportion of movies to TV shows in Netflix's catalog
- **Top Producing Countries**: United States leads in content production
- **Popular Ratings**: Identification of most common content ratings

### Genre Analysis
- **Most Popular Genres**: Comprehensive breakdown of content by genre
- **Documentary Content**: Specific analysis of documentary offerings

### Temporal Patterns
- **Release Trends**: Analysis of content release patterns over years
- **Recent Additions**: Focus on content added in the last 5 years

### Quality Insights
- **Longest Content**: Identification of longest movies and TV shows with most seasons
- **Content Categorization**: Classification based on content themes

## 📝 SQL Queries & Analysis

The project includes sophisticated SQL techniques:

### Advanced Features Used:
- **Window Functions**: `RANK() OVER(PARTITION BY ... ORDER BY ...)`
- **CTEs**: Multiple common table expressions for complex analysis
- **String Functions**: `STRING_SPLIT()`, `TRIM()`, `REPLACE()`
- **Date Manipulation**: `DATEADD()`, `YEAR()`, `MONTH()`
- **Pattern Matching**: `LIKE` operators for text search
- **Data Type Conversion**: `TRY_CAST()` for safe type conversion

### Example Query - Most Common Ratings:
```sql
SELECT *
FROM (
    SELECT show_type, rating, COUNT(*) AS rating_count,
    RANK() OVER(PARTITION BY show_type ORDER BY COUNT(*) DESC) AS rank_num
    FROM netflix
    GROUP BY show_type, rating
) AS t1
WHERE t1.rank_num = 1;
```

## 🚀 Getting Started

### Prerequisites
- SQL Server installed
- SQL Server Management Studio (SSMS)
- Netflix dataset CSV file

### Setup Instructions
1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/netflix-data-analysis.git
   ```

2. **Import the dataset**
   - Import the CSV file into SQL Server
   - Ensure proper data types and encoding

3. **Run the analysis**
   - Execute the `NetflixMoviesData.sql` file
   - Review results and insights

### Database Setup
```sql
-- Create database
CREATE DATABASE NetflixMoviesData;
USE NetflixMoviesData;

-- Import your CSV data here
-- Then execute the analysis queries
```

## 📁 Files in Repository

```
netflix-data-analysis/
├── NetflixMoviesData.sql      # Main SQL analysis file
├── README.md                  # Project documentation
├── netflix_titles.csv         # Dataset (if shareable)
└── results/                   # Query results and insights
    ├── content_distribution.png
    ├── top_countries.png
    └── genre_analysis.png
```

## 📈 Key Metrics Analyzed

- **Content Volume**: Total content distribution
- **Geographic Reach**: Global content distribution
- **Content Quality**: Rating distributions and patterns  
- **Temporal Trends**: Release and addition patterns
- **Genre Diversity**: Content category analysis
- **Industry Insights**: Actor and director analytics

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Netflix for providing comprehensive streaming data
- SQL Server community for excellent documentation
- Open source community for inspiration and best practices

---

*This project demonstrates advanced SQL skills including window functions, CTEs, string manipulation, and complex data analysis techniques. Perfect for showcasing database expertise and analytical thinking in a portfolio setting.*
