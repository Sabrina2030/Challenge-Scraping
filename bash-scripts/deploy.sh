#!/bin/bash

# Detener el script si ocurre algún error
set -e

# Cambiar al directorio raíz del proyecto
cd "$(dirname "$0")/.."

# Configurar variables
PROJECT_ID="challenge-435921"
IMAGE_NAME="scraping-news-image"
REGION="us-central1"
SERVICE_NAME="scraping-news-service"
CREDENTIALS_PATH="/app/config/your-credential.json"
LOCAL_CREDENTIALS_PATH="./config/your-credential.json"

# Verificar que el archivo de credenciales exista
if [ ! -f "$LOCAL_CREDENTIALS_PATH" ]; then
    echo "El archivo de credenciales no se encuentra en $LOCAL_CREDENTIALS_PATH"
    exit 1
fi

# Cambiar permisos del archivo de credenciales para que solo el propietario tenga acceso
chmod 600 "$LOCAL_CREDENTIALS_PATH"

# Habilitar APIs necesarias
echo "Habilitando APIs de Cloud Run y Container Registry..."
gcloud services enable run.googleapis.com
gcloud services enable containerregistry.googleapis.com

# Construir la imagen Docker (el Dockerfile está en la raíz del proyecto)
echo "Construyendo la imagen Docker..."
docker build -t gcr.io/$PROJECT_ID/$IMAGE_NAME .

# Autenticar Docker con Google Cloud
echo "Autenticando Docker con Google Cloud..."
gcloud auth configure-docker

# Subir la imagen al Container Registry
echo "Subiendo la imagen al Container Registry..."
docker push gcr.io/$PROJECT_ID/$IMAGE_NAME

# Desplegar en Google Cloud Run
echo "Desplegando el servicio en Google Cloud Run..."
gcloud run deploy $SERVICE_NAME \
    --image gcr.io/$PROJECT_ID/$IMAGE_NAME \
    --platform managed \
    --region $REGION \
    --memory 1Gi \
    --set-env-vars GOOGLE_APPLICATION_CREDENTIALS="$CREDENTIALS_PATH" \
    --allow-unauthenticated

echo "Despliegue completado. Verifica el estado del servicio en Google Cloud Run."
