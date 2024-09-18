from google.cloud import bigquery

def insert_data_into_bigquery(df):
    # Inicializar el cliente de BigQuery
    client = bigquery.Client()

    # Definir la tabla destino
    table_id = "your_project.your_dataset.your_table"

    # Cargar el DataFrame a BigQuery
    job = client.load_table_from_dataframe(df, table_id)

    # Esperar a que la carga se complete
    job.result()

    print(f"Datos cargados en BigQuery en la tabla {table_id}.")
