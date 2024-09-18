# Challenge-Scraping


## Overview

This project performs web scraping from a news portal, processes the scraped data, and uploads it to Google BigQuery. The project is designed to run within a Docker container and can be deployed on Google Cloud Run. 

### Objectives:
- Scrape data from [Yogonet International News Portal](https://www.yogonet.com/international/)
- Process the data (word count, character count, etc.)
- Insert the processed data into a BigQuery table
- Automate deployment using a Bash script


## Project Structure
```bash
CHALLENGE_DATA/
├── bash-scripts/
│   └── deploy.sh           # Script to automate Docker build and Cloud Run deployment
├── bigquery/
│   └── bigquery_integration.py  # BigQuery data insertion logic
├── config/
│   └── challenge-435921-1d9158e1ebff.json  # Google Cloud credentials for BigQuery
├── scraper/
│   ├── scraper.py          # Main scraping logic using Selenium
│   ├── post_process.py     # Post-processing logic for data using Pandas
├── .dockerignore           # Docker ignore file
├── Dockerfile              # Docker image definition
├── requirements.txt        # Python dependencies
```

## Requirements

Before running the project, ensure that you have the following tools installed:

- Python 3.8 or above
- Docker
- Google Cloud SDK
- Google Cloud Project with BigQuery enabled
- Service account JSON credentials with the proper BigQuery permissions

## Setup Instructions

### 1. Create a Google Cloud Project and BigQuery Dataset
1. Set up a Google Cloud project and enable BigQuery.
2. Create a BigQuery dataset and table to store the scraped data.

### 2. Configure Google Cloud credentials
Ensure that the service account credentials file is properly configured with BigQuery permissions and placed in the config/ folder.

### 3. Docker Setup and Run
4.1. Build the Docker Image
You can build the Docker image using the following command:

```bash
docker build -t scraping-news-image .
```

4.2. Run the Docker Image Locally
You can test the Docker container locally before deploying it to Cloud Run:


```bash
docker run -p 8080:8080 scraping-news-image
```
