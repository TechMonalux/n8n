# 🚀 Instalación de [Tu Proyecto] con Docker Compose

[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![Docker Compose](https://img.shields.io/badge/docker--compose-%232496ED.svg?style=for-the-badge&logo=docker&logoColor=white)](https://docs.docker.com/compose/)
[![YouTube](https://img.shields.io/badge/YouTube-%23FF0000.svg?style=for-the-badge&logo=YouTube&logoColor=white)](https://youtube.com/@tu-canal)
[![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white)](https://github.com/tu-usuario)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)](https://ubuntu.com/)

En este repositorio encontrarás la guía paso a paso para instalar **[Tu Proyecto]** en un servidor Ubuntu utilizando **Docker Compose**.

[Tu Proyecto] es una herramienta de [descripción de tu proyecto] de código abierto, ideal para quienes buscan [beneficio principal], [beneficio secundario] y potenciar proyectos personales o profesionales sin depender de plataformas externas.

## 📹 Video tutorial

En este video te enseño cómo instalar [Tu Proyecto] en Ubuntu Server utilizando Docker Compose, paso a paso y desde cero.

### [ENLACE A TU VIDEO DE YOUTUBE]

## 🛠️ Comandos usados en el tutorial

### 1. Conectarse al servidor por SSH

```bash
ssh usuario@IP-del-servidor
```

### 2. Actualizar el sistema

```bash
sudo apt update && sudo apt upgrade -y
```

### 3. Instalar editor de texto (nano)

```bash
sudo apt install nano
```

### 4. Instalar Docker y Docker Compose

```bash
# Instalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Agregar usuario al grupo docker
sudo usermod -aG docker $USER

# Cerrar sesión y volver a conectar
exit
```

### 5. Crear carpetas para Docker y el proyecto

```bash
mkdir docker
cd docker
mkdir mi-proyecto
cd mi-proyecto
```

### 6. Crear archivo de configuración

```bash
nano docker-compose.yml
```

Ejemplo de configuración:

```yaml
#Archivo proporcionado por [Tu Nombre]

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
      - WEBHOOK_URL=http://192.168.0.20:5678
      - TZ=Europe/Madrid
      - NODE_ENV=production
    volumes:
      - mi_proyecto_data:/home/node/.mi-proyecto
      - ./local-files:/files

volumes:
  mi_proyecto_data:
```

### 7. Ejecutar el contenedor en segundo plano

```bash
docker compose up -d
```

### 8. Ver contenedores en ejecución

```bash
docker ps
```

### 9. Revisar logs de un contenedor

```bash
docker logs ID-del-contenedor
```

### 10. Acceso desde navegador

```
http://IP-del-servidor:5678
```

## 📋 Estructura del proyecto

```
mi-proyecto/
├── docker-compose.yml
├── README.md
├── .env.example
├── .gitignore
├── LICENSE
├── local-files/
│   └── (archivos de ejemplo)
├── docs/
│   ├── instalacion.md
│   ├── configuracion.md
│   └── troubleshooting.md
└── examples/
    ├── docker-compose-basic.yml
    └── docker-compose-advanced.yml
```

## 📋 Requisitos del sistema

- **Sistema Operativo**: Ubuntu 20.04 LTS o superior
- **Memoria RAM**: Mínimo 2GB (recomendado 4GB)
- **Espacio en disco**: Mínimo 10GB libres
- **Acceso a internet**: Para descargar imágenes de Docker
- **Puertos**: Puerto 5678 disponible (configurable)

## ⚙️ Variables de entorno

El archivo `.env` puede incluir las siguientes variables:

```bash
# Configuración básica
HOST=0.0.0.0
PORT=5678
PROTOCOL=http

# URL del webhook
WEBHOOK_URL=http://tu-ip:5678

# Zona horaria
TZ=Europe/Madrid

# Entorno de ejecución
NODE_ENV=production

# Configuración de seguridad
SECURE_COOKIE=false
```

## 🌍 Zonas horarias válidas

Consulta la lista completa en Wikipedia: [Lista de zonas horarias](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)

Ejemplos comunes:
- `Europe/Madrid` - España
- `America/Mexico_City` - México
- `America/Argentina/Buenos_Aires` - Argentina
- `America/Bogota` - Colombia
- `UTC` - Tiempo universal coordinado

## 🎯 Lo que aprenderás con este tutorial

- Conexión al servidor por SSH desde terminal
- Actualización básica del sistema Ubuntu
- Instalación de Docker y Docker Compose
- Creación de directorios y configuración de `docker-compose.yml`
- Ejecución de contenedores con Docker Compose
- Gestión básica de contenedores (logs, estado, etc.)
- Acceso y configuración inicial de la aplicación
- Configuración de variables de entorno
- Mejores prácticas de seguridad básica

## ✔️ Beneficios de usar [Tu Proyecto] en tu propio servidor

- ✅ **Privacidad y control**: Tus datos permanecen en tu servidor
- ✅ **Independencia**: No dependes de servicios externos
- ✅ **Personalización**: Configuración completamente adaptable
- ✅ **Escalabilidad**: Puedes crecer según tus necesidades
- ✅ **Aprendizaje**: Experiencia técnica real y valiosa
- ✅ **Costo**: Evitas suscripciones mensuales costosas

## 👥 Ideal para

- Entusiastas del **self-hosting**
- Desarrolladores que buscan automatización
- Creadores de contenido técnico
- Estudiantes de DevOps e infraestructura
- Pequeñas empresas que necesitan independencia tecnológica
- Cualquier persona interesada en la **automatización inteligente**

## 🔧 Solución de problemas comunes

### Error: Puerto ya en uso
```bash
# Verificar qué proceso usa el puerto
sudo netstat -tlnp | grep :5678

# Cambiar el puerto en docker-compose.yml
ports:
  - "8080:5678"  # Usar puerto 8080 en lugar de 5678
```

### Error: Permisos de Docker
```bash
# Agregar usuario al grupo docker
sudo usermod -aG docker $USER

# Cerrar sesión y volver a conectar
exit
```

### Contenedor no inicia
```bash
# Ver logs detallados
docker logs nombre-del-contenedor

# Verificar configuración
docker compose config
```

## 🚀 Comandos útiles adicionales

```bash
# Parar todos los contenedores
docker compose down

# Actualizar imagen y reiniciar
docker compose pull
docker compose up -d

# Ver uso de recursos
docker stats

# Limpiar imágenes no utilizadas
docker image prune

# Backup de volúmenes
docker run --rm -v mi_proyecto_data:/data -v $(pwd):/backup alpine tar czf /backup/backup.tar.gz /data
```

## 👥 Contribuciones

Las contribuciones son bienvenidas. Si tienes sugerencias, mejoras o encuentras errores:

1. **Fork** el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. **Commit** tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. **Push** a la rama (`git push origin feature/AmazingFeature`)
5. Abre un **Pull Request**

### Guidelines para contribuir

- Documenta cualquier cambio en los comandos
- Prueba los comandos en un entorno limpio
- Mantén el estilo de documentación existente
- Incluye capturas de pantalla si es necesario

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

## 🔗 Enlaces útiles

- [Documentación oficial de Docker](https://docs.docker.com/)
- [Documentación oficial de Docker Compose](https://docs.docker.com/compose/)
- [Canal de YouTube](https://youtube.com/@tu-canal)
- [Docker Hub](https://hub.docker.com/)
- [Ubuntu Server Guide](https://ubuntu.com/server/docs)

## 🙏 Agradecimientos

- Comunidad de [Tu Proyecto]
- Contribuidores del repositorio
- Comunidad de Docker y contenedores
- Usuarios que reportan issues y sugieren mejoras
- [Canal/Creator original] por la inspiración

## 📊 Estadísticas del proyecto

- ⭐ Estrellas en GitHub: ![GitHub stars](https://img.shields.io/github/stars/tu-usuario/tu-repositorio)
- 🍴 Forks: ![GitHub forks](https://img.shields.io/github/forks/tu-usuario/tu-repositorio)
- 📝 Issues: ![GitHub issues](https://img.shields.io/github/issues/tu-usuario/tu-repositorio)
- 📦 Última release: ![GitHub release](https://img.shields.io/github/v/release/tu-usuario/tu-repositorio)

---

⭐ **¡Si te ha sido útil, dale una estrella al repositorio!**

📺 **¡No olvides suscribirte al canal para más tutoriales!**

🤝 **¡Comparte este repositorio con otros que puedan beneficiarse!**

---

## About

Archivos usados en el tutorial de instalación de [Tu Proyecto] con Docker Compose.

### Topics

`docker` `youtube` `tutorial` `ubuntu` `docker-compose` `nano` `ubuntu-server` `compose` `self-hosting` `automation` `[tu-proyecto]` `[tu-nombre-canal]`

### Resources

- 📖 README
- ⚖️ MIT License
- 🏷️ Releases

### Activity

- ⭐ **0** stars
- 👁️ **0** watching  
- 🍴 **0** forks
