#!/bin/bash -e

# Verificar si el archivo .env existe
if [ ! -f .env ]; then
  echo "❌ Error: No se encontró el archivo .env en la raíz del proyecto."
  exit 1
fi

echo "🚀 Iniciando el análisis estático con SonarScanner..."

# Leer valores del archivo .env de forma segura
TOKEN=$(grep '^SONAR_TOKEN=' .env | cut -d= -f2)
HOST_URL=$(grep '^SONAR_HOST_URL=' .env | cut -d= -f2)

# Ejecutar el contenedor inyectando las variables requeridas por SonarScanner
docker run --rm \
  --network="host" \
  -v "$(pwd):/usr/src" \
  -v "$(pwd)/.sonar:/usr/src/.sonar" \
  sonarsource/sonar-scanner-cli \
  -Dsonar.host.url="$HOST_URL" \
  -Dsonar.token="$TOKEN"

echo "✅ Proceso finalizado. Revisa los resultados en http://localhost:9000"

