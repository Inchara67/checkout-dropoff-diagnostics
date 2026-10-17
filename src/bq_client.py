from google.cloud import bigquery

PROJECT_ID = "analytics-project-510814"

client = bigquery.Client(project=PROJECT_ID)


def run(sql):
    return client.query(sql).to_dataframe()
