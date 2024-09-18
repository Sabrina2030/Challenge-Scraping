from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.firefox.service import Service
from selenium.webdriver.firefox.options import Options
from scraper.post_process import process_data
from bigquery.bigquery_integration import insert_data_into_bigquery
import pandas as pd
import time
from flask import Flask


app = Flask(__name__)

@app.route("/")
def run_scraping():
    # Configurar las opciones de Firefox
    firefox_options = Options()
    firefox_options.add_argument("--headless")
    firefox_options.add_argument("--no-sandbox")
    firefox_options.add_argument("--disable-dev-shm-usage")

    # Inicializar el controlador de Firefox con Geckodriver
    service = Service(executable_path='/usr/local/bin/geckodriver')
    driver = webdriver.Firefox(service=service, options=firefox_options)

    driver.get("https://www.yogonet.com/international/")

    # Esperar hasta que los artículos sean visibles.
    try:
        articles = WebDriverWait(driver, 10).until(
            EC.presence_of_all_elements_located((By.CSS_SELECTOR, ".slot.slot_1.noticia.cargada"))
        )
    except Exception as e:
        driver.quit()
        return "No se encontraron artículos."

    news_data = []

    for article in articles:
        try:
            # Extraer el título
            title_element = article.find_element(By.CSS_SELECTOR, ".titulo.fuente_roboto_slab a")
            title = title_element.text
            link = title_element.get_attribute("href")
            
            # Extraer el kicker (si está disponible)
            try:
                kicker_element = article.find_element(By.CSS_SELECTOR, ".volanta.fuente_roboto_slab")
                kicker = kicker_element.text
            except:
                kicker = "No kicker found"

            # Extraer la imagen (si está disponible)
            try:
                image_element = article.find_element(By.CSS_SELECTOR, ".imagen img")
                image_url = image_element.get_attribute("src")
            except:
                image_url = "No image found"

           
            news_data.append({
                "title": title,
                "kicker": kicker,
                "link": link,
                "image": image_url
            })
        except Exception as e:
            print(f"Error extrayendo datos de un artículo: {e}")

    driver.quit()

    df = pd.DataFrame(news_data)

    # Post-procesar los datos 
    df_processed = process_data(df)

    # Intentar insertar los datos en BigQuery
    try:
        insert_data_into_bigquery(df_processed)
    except Exception as e:
        return f"Se produjo un error: {str(e)}"

    return "Web scraping completado e insertado en BigQuery."


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)


