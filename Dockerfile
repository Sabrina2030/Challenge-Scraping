# Usar una imagen base ligera de Python
FROM python:3.9-slim

# Establecer el directorio de trabajo dentro del contenedor
WORKDIR /app

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    curl \
    xvfb \
    gnupg2 \
    libnss3 \
    libgconf-2-4 \
    libxi6 \
    libgconf-2-4 \
    fonts-liberation \
    libappindicator3-1 \
    xdg-utils \
    firefox-esr \
    && rm -rf /var/lib/apt/lists/*

# Instalar Geckodriver
RUN GECKODRIVER_VERSION=0.30.0 \
    && wget https://github.com/mozilla/geckodriver/releases/download/v$GECKODRIVER_VERSION/geckodriver-v$GECKODRIVER_VERSION-linux64.tar.gz \
    && tar -xzf geckodriver-v$GECKODRIVER_VERSION-linux64.tar.gz \
    && mv geckodriver /usr/local/bin/ \
    && rm geckodriver-v$GECKODRIVER_VERSION-linux64.tar.gz

# Copiar el código del proyecto al contenedor
COPY . /app

# credenciales en local
COPY ./config/your-credential.json /app/config/your-credential.json

# Instalar las dependencias desde el archivo requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Definir la variable de entorno para Google Cloud (local)
ENV GOOGLE_APPLICATION_CREDENTIALS="/app/config/your-credential.json"

# Establecer la ruta de Geckodriver y Firefox
ENV PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"

# Establecer opciones para que Firefox funcione sin interfaz gráfica
ENV DISPLAY=:99

# Definir la variable de entorno para Flask
ENV FLASK_APP=scraper.scraper

# Ejecutar Flask en todas las interfaces
CMD ["flask", "run", "--host=0.0.0.0", "--port=8080"]