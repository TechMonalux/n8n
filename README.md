# 🚀 Instalación de n8n con Docker Compose
En este repositorio encontrarás la guía paso a paso para instalar **n8n** en un Ubuntu utilizando Docker Compose.

**📹 Video tutorial**
En este video te enseño cómo instalar **n8n** en Ubuntu Server utilizando Docker Compose, paso a paso y desde cero.

**1. Conectarse al servidor por SSH**

ssh usuario@IP-del-servidor

**2. Actualizar el sistema**

sudo apt update && sudo apt upgrade -y

**3. Instalar editor de texto (nano, normalmente ya viene siempre instalado por defecto en los sistemas)**

sudo apt install nano

**4. Instalar Docker y Docker Compose (lanza los siguinetes comandos por orden)**

- sudo apt update
- sudo apt install apt-transport-https ca-certificates curl software-properties-common
- curl -fsSL https://download.docker.com/linux/ubu... | sudo apt-key add -
- sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
- sudo apt update
- apt-cache policy docker-ce
- sudo apt install docker-ce
- sudo systemctl status docker

**5. Crear carpetas para Docker y el proyecto**

- mkdir docker
- cd docker
- mkdir mi-proyecto
- cd mi-proyecto

**6. Crear archivo de configuración**

nano docker-compose.yml

Ejemplo de configuración:


#Archivo proporcionado por TechMonalux

services:
  mi-proyecto:
    image: mi-proyecto:latest
    container_name: mi-proyecto
    restart: unless-stopped
    ports:
      - "5678:5678"
    environment:
      - HOST=0.0.0.0
      - PORT=5678
      - PROTOCOL=http
      - WEBHOOK_URL=http://x.x.x.x:5678
      - TZ=Europe/Madrid
      - NODE_ENV=production
    volumes:
      - mi_proyecto_data:/home/node/.mi-proyecto
      - ./local-files:/files

volumes:
  mi_proyecto_data:
  
**7. Ejecutar el contenedor en segundo plano**

docker compose up -d

**8. Ver contenedores en ejecución**

docker ps

**9. Revisar logs de un contenedor**

docker logs ID-del-contenedor

**10. Acceso desde navegador**

http://IP-del-servidor:5678
