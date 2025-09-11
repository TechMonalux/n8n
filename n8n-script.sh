#!/bin/bash

set -e  # Salir si hay algún error

echo "================================"
echo "  Instalación de n8n con Docker Compose"
echo "================================"

# 1. Actualizar el sistema
echo "[1] Actualizando sistema..."
apt update && apt upgrade -y

# 2. Instalar nano (editor de texto)
echo "[2] Instalando nano..."
apt install -y nano

# 3. Instalar Docker y Docker Compose
echo "[3] Instalando Docker y Docker Compose..."

apt install -y apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

apt update

apt-cache policy docker-ce

apt install -y docker-ce docker-compose-plugin

# Comprobar que Docker está corriendo
systemctl status docker --no-pager

# 4. Crear carpetas para Docker y proyecto n8n
echo "[4] Creando carpetas para el proyecto..."
mkdir -p /root/docker/n8n
cd /root/docker/n8n

# 5. Crear archivo docker-compose.yml
echo "[5] Creando archivo docker-compose.yml..."

cat > docker-compose.yml << EOF
# Archivo proporcionado por TechMonalux

services:
  n8n:
    image: n8nio/n8n:latest
    container_name: n8n
    restart: unless-stopped
    ports:
      - "5678:5678"
    environment:
      - N8N_HOST=0.0.0.0
      - N8N_PORT=5678
      - N8N_PROTOCOL=http
      - WEBHOOK_URL=http://0.0.0.0:5678
      - TZ=Europe/Madrid
      - NODE_ENV=production
      - N8N_SECURE_COOKIE=false
      - N8N_RUNNERS_ENABLED=false
    volumes:
      - n8n_data:/home/node/.n8n
      - ./local-files:/files

volumes:
  n8n_data:
EOF

# Crear carpeta para archivos locales
mkdir -p local-files

# 6. Ejecutar el contenedor en segundo plano
echo "[6] Levantando contenedor n8n con Docker Compose..."
docker compose up -d

echo "================================"
echo "Instalación completada. Accede a n8n en http://<IP-del-servidor>:5678"
echo "================================"
