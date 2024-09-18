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



## Requirements

