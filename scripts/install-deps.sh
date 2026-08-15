#!/usr/bin/env bash

# Exit inmediatamente si un comando falla
set -e

echo "=== Actualizando repositorios del sistema ==="
sudo apt update

echo "=== Instalando herramientas de compilación y librerías para Direwolf ==="
sudo apt install -y \
    build-essential \
    cmake \
    git \
    libasound2-dev \
    libudev-dev \
    libhamlib-dev \
    alsa-utils \
    usbutils \
    curl

echo "=== Configurando permisos de usuario ==="
# Añade el usuario actual a los grupos audio y dialout para acceder a la Digirig Lite sin sudo
sudo usermod -aG audio,dialout "$USER"

echo "--------------------------------------------------------"
echo " ¡Dependencias instaladas con éxito!"
echo " NOTA: Para que los cambios de grupo (audio/dialout) surtan efecto,"
echo " reinicia sesión o ejecuta: 'su - $USER'"
echo "--------------------------------------------------------"