#!/bin/bash

# Script de instalación automática de n8n con Docker Compose
# Basado en la guía de TechMonalux: https://github.com/TechMonalux/n8n
# 
# Este script automatiza el proceso de instalación de n8n en Ubuntu
# utilizando Docker y Docker Compose

set -e  # Detener el script si hay algún error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para mostrar mensajes con colores
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}    INSTALACIÓN DE N8N${NC}"
    echo -e "${BLUE}     con Docker Compose${NC}"
    echo -e "${BLUE}================================${NC}"
    echo ""
}

# Función para verificar si el usuario es root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        print_error "No ejecutes este script como root. Usa un usuario normal con permisos sudo."
        exit 1
    fi
}

# Función para verificar requisitos
check_requirements() {
    print_message "Verificando requisitos del sistema..."
    
    # Verificar Ubuntu
    if ! command -v lsb_release &> /dev/null || [[ $(lsb_release -si) != "Ubuntu" ]]; then
        print_warning "Este script está diseñado para Ubuntu. Puede que no funcione en otros sistemas."
    fi
    
    # Verificar memoria RAM (al menos 2GB)
    total_mem=$(free -g | awk '/^Mem:/{print $2}')
    if [ $total_mem -lt 2 ]; then
        print_warning "Se recomienda al menos 2GB de RAM. Tienes ${total_mem}GB."
    fi
    
    # Verificar espacio en disco (al menos 10GB libres)
    free_space=$(df -BG / | awk 'NR==2{print $4}' | sed 's/G//')
    if [ $free_space -lt 10 ]; then
        print_warning "Se recomienda al menos 10GB libres. Tienes ${free_space}GB."
    fi
}

# Función para actualizar el sistema
update_system() {
    print_message "Actualizando el sistema..."
    sudo apt update && sudo apt upgrade -y
    print_message "Sistema actualizado correctamente."
}

# Función para instalar herramientas básicas
install_basic_tools() {
    print_message "Instalando herramientas básicas..."
    sudo apt install -y nano curl wget software-properties-common apt-transport-https ca-certificates
    print_message "Herramientas básicas instaladas."
}

# Función para instalar Docker
install_docker() {
    print_message "Instalando Docker..."
    
    # Verificar si Docker ya está instalado
    if command -v docker &> /dev/null; then
        print_warning "Docker ya está instalado."
        return 0
    fi
    
    # Agregar clave GPG oficial de Docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    
    # Agregar repositorio de Docker
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    
    # Actualizar paquetes
    sudo apt update
    
    # Verificar política de Docker CE
    apt-cache policy docker-ce
    
    # Instalar Docker CE
    sudo apt install -y docker-ce
    
    # Verificar instalación
    sudo systemctl status docker --no-pager
    
    # Agregar usuario al grupo docker
    sudo usermod -aG docker $USER
    
    print_message "Docker instalado correctamente."
    print_warning "Necesitarás cerrar sesión y volver a iniciar para que los permisos de docker surtan efecto."
}

# Función para crear estructura de directorios
create_directories() {
    print_message "Creando directorios para el proyecto..."
    
    mkdir -p ~/docker/n8n
    cd ~/docker/n8n
    
    print_message "Directorios creados: ~/docker/n8n"
}

# Función para crear archivo docker-compose.yml
create_docker_compose() {
    print_message "Creando archivo docker-compose.yml..."
    
    # Solicitar IP del servidor
    echo -n "Ingresa la IP de tu servidor (o presiona Enter para usar 0.0.0.0): "
    read server_ip
    server_ip=${server_ip:-"0.0.0.0"}
    
    # Solicitar puerto
    echo -n "Ingresa el puerto para n8n (presiona Enter para usar 5678): "
    read port
    port=${port:-"5678"}
    
    # Crear archivo docker-compose.yml
    cat > docker-compose.yml << EOF
# Archivo proporcionado por TechMonalux
# https://github.com/TechMonalux/n8n

services:
  n8n:
    image: n8nio/n8n:latest
    container_name: n8n
    restart: unless-stopped
    ports:
      - "${port}:5678"
    environment:
      - N8N_HOST=0.0.0.0
      - N8N_PORT=5678
      - N8N_PROTOCOL=http
      - WEBHOOK_URL=http://${server_ip}:${port}
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
    
    print_message "Archivo docker-compose.yml creado con IP: $server_ip y Puerto: $port"
}

# Función para crear archivo .env (opcional)
create_env_file() {
    print_message "Creando archivo de variables de entorno (.env)..."
    
    cat > .env << EOF
# Configuración básica
HOST=0.0.0.0
PORT=5678
PROTOCOL=http

# URL del webhook (cambiar por tu IP real)
WEBHOOK_URL=http://tu-ip:5678

# Zona horaria
TZ=Europe/Madrid

# Entorno de ejecución
NODE_ENV=production

# Configuración de seguridad
SECURE_COOKIE=false
EOF
    
    print_message "Archivo .env creado. Puedes editarlo según tus necesidades."
}

# Función para verificar si el puerto está disponible
check_port() {
    local port=${1:-5678}
    if netstat -tlnp 2>/dev/null | grep ":$port " > /dev/null; then
        print_error "El puerto $port ya está en uso. Por favor, elige otro puerto."
        return 1
    fi
    return 0
}

# Función para iniciar n8n
start_n8n() {
    print_message "Iniciando n8n con Docker Compose..."
    
    # Verificar que docker esté funcionando
    if ! docker ps &> /dev/null; then
        print_error "Docker no está funcionando correctamente. Verifica que el usuario esté en el grupo docker."
        print_message "Ejecuta: sudo usermod -aG docker $USER"
        print_message "Luego cierra sesión y vuelve a iniciar sesión."
        exit 1
    fi
    
    # Crear directorio para archivos locales
    mkdir -p ./local-files
    
    # Ejecutar docker compose
    docker compose up -d
    
    print_message "n8n iniciado correctamente."
    
    # Mostrar estado de los contenedores
    print_message "Estado de los contenedores:"
    docker ps
    
    # Mostrar logs iniciales
    print_message "Logs iniciales (primeras 20 líneas):"
    docker logs n8n 2>/dev/null | head -20 || true
}

# Función para mostrar información de acceso
show_access_info() {
    local server_ip=$(hostname -I | awk '{print $1}')
    local port=${1:-5678}
    
    echo ""
    print_header
    echo -e "${GREEN}✅ ¡Instalación completada exitosamente!${NC}"
    echo ""
    echo -e "${BLUE}🌐 Accede a n8n desde tu navegador:${NC}"
    echo -e "   ${YELLOW}http://${server_ip}:${port}${NC}"
    echo ""
    echo -e "${BLUE}📋 Comandos útiles:${NC}"
    echo -e "   Ver logs:          ${YELLOW}docker logs n8n${NC}"
    echo -e "   Parar n8n:         ${YELLOW}docker compose down${NC}"
    echo -e "   Reiniciar n8n:     ${YELLOW}docker compose restart${NC}"
    echo -e "   Ver contenedores:  ${YELLOW}docker ps${NC}"
    echo ""
    echo -e "${BLUE}📁 Ubicación del proyecto: ${YELLOW}~/docker/n8n${NC}"
    echo ""
    echo -e "${GREEN}🎉 ¡Disfruta automatizando con n8n!${NC}"
    echo -e "${BLUE}================================${NC}"
}

# Función principal
main() {
    print_header
    
    # Verificaciones iniciales
    check_root
    check_requirements
    
    # Instalación paso a paso
    update_system
    install_basic_tools
    install_docker
    create_directories
    create_docker_compose
    create_env_file
    
    # Verificar puerto disponible
    port=$(grep -o ':[0-9]\+:' docker-compose.yml | cut -d: -f2)
    if ! check_port $port; then
        print_error "Edita el archivo docker-compose.yml y cambia el puerto."
        exit 1
    fi
    
    # Iniciar n8n
    start_n8n
    
    # Mostrar información de acceso
    show_access_info $port
    
    # Mensaje final
    echo ""
    print_message "Si encuentras algún problema, revisa los logs con: docker logs n8n"
    print_message "Para más información, visita: https://github.com/TechMonalux/n8n"
}

# Ejecutar función principal
main "$@"
