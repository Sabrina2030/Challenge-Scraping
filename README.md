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

### 3. Set the Credentials Path
In the `Dockerfile`, you will find a placeholder `your-credentials.json`. You must replace this with the actual name of your Google Cloud service account credentials file.

### 4. Docker Setup and Run
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

4.3 Once up you can try this command:
```bash
curl http://127.0.0.1:8080
```

### 5. Deployment
The project includes a deploy.sh script to automate the deployment process to Google Cloud Run.

5.1. You must replace `your-credentials.json` with the actual name of your Google Cloud service account credentials file.

5.2. Run the Deployment Script:

```bash
bash bash-scripts/deploy.sh
```

This script will:

- Build the Docker image
- Push the image to Google Container Registry
- Deploy the service to Google Cloud Run


## Scripts Overview

### scraper.py
- This script uses Selenium to scrape news data from the Yogonet website.
- Scrapes fields: Title, Kicker, Image, Link.
- Saves the data into a structured format for post-processing.

### post_process.py
- Performs additional processing on the scraped data using Pandas.
- Key metrics include:
    - Word count in the title
    - Character count in the title
    - List of capitalized words in the title.

### bigquery_integration.py
- Handles the insertion of processed data into Google BigQuery.
- Connects using Google service account credentials.

#### Important:
Make sure to replace the placeholder "your_project.your_dataset.your_table" with your actual project, dataset, and table names in BigQuery. Here's how:

- your_project: Replace this with your Google Cloud Project ID.
- your_dataset: Replace this with the name of the dataset in BigQuery where you want to store the data.
- your_table: Replace this with the name of the table inside the dataset where the data will be inserted.

For example, if your project is my-gcp-project, your dataset is news_data, and your table is scraped_articles, the table_id would look like this:

```py
table_id = "my-gcp-project.news_data.scraped_articles"
```

### deploy.sh
Automates Docker build, image push to Google Container Registry, and deployment to Google Cloud Run.


## Additional Information
- Docker Image: The project is fully Dockerized for easy deployment. Ensure that Docker is properly installed and configured on your system.
- Service Credentials: Ensure the correct setup of your Google Cloud credentials to allow BigQuery integration.
- A .dockerignore is added to ignore what we do not want to be uploaded to the docker image and a .gitignore that ignores GCP credentials