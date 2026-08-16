# 03. Compilación de Direwolf 1.8 (Rama de Desarrollo)

Para implementar una configuración de *Crossband Digipeater* (VHF/UHF) con múltiples canales lógicos, necesitamos características que solo están disponibles en la versión **1.8** de Direwolf. Dado que los repositorios oficiales de Debian suelen tener versiones más antiguas, es necesario compilar el software desde su código fuente.

Este documento detalla los pasos a ejecutar en la **Computadora C** (Debian 12) para descargar, compilar e instalar Direwolf.

---

## 1. INSTALACIÓN DE DEPENDENCIAS DEL SISTEMA

Antes de compilar, el sistema operativo necesita herramientas de desarrollo (compiladores, CMake) y las librerías de audio y hardware (ALSA, udev) que Direwolf utilizará para comunicarse con la DigiRig Lite.

Ejecuta el siguiente comando para actualizar e instalar todo lo necesario:

```bash
sudo apt update
sudo apt install -y git gcc g++ make cmake libasound2-dev libudev-dev
```

* **`git`**: Para descargar el código fuente.
* **`gcc` / `g++` / `make` / `cmake`**: Herramientas de compilación.
* **`libasound2-dev`**: Librerías de desarrollo de ALSA (para el audio).
* **`libudev-dev`**: Librerías para interactuar con los puertos USB y PTT.

---

## 2. DESCARGA DEL CÓDIGO FUENTE (CLONACIÓN)

1. Ve al directorio de tu usuario (o donde prefieras guardar el código fuente):
   ```bash
   cd ~
   ```
2. Clona el repositorio oficial de Direwolf desde GitHub:
   ```bash
   git clone [https://github.com/wb2osz/direwolf.git](https://github.com/wb2osz/direwolf.git)
   ```
3. Ingresa al directorio descargado y cambia a la rama de desarrollo (`dev`), que contiene la versión 1.8:
   ```bash
   cd direwolf
   git checkout dev
   ```

---

## 3. PROCESO DE COMPILACIÓN

Direwolf utiliza `cmake` para preparar el entorno de construcción.

1. Crea un directorio de construcción y entra en él:
   ```bash
   mkdir build && cd build
   ```
2. Genera los archivos de compilación adaptados a tu sistema:
   ```bash
   cmake ..
   ```
3. Compila el código fuente. El parámetro `-j$(nproc)` le dice al sistema que use todos los núcleos del procesador de la MacBook Air para terminar más rápido:
   ```bash
   make -j$(nproc)
   ```

---

## 4. INSTALACIÓN EN EL SISTEMA

Una vez que la compilación termine sin errores, instala los binarios y los archivos de configuración base en el sistema operativo:

1. Instala la aplicación (requiere permisos de administrador):
   ```bash
   sudo make install
   ```
2. Instala los archivos de configuración predeterminados en tu directorio de usuario:
   ```bash
   make install-conf
   ```

---

## 5. MATRIZ DE PRUEBAS Y VALIDACIÓN

Ejecuta estas pruebas en la terminal de la **Computadora C** para asegurar que el software quedó instalado y funcional.

| Prueba | Comando en Terminal | Criterio de Aceptación / Resultado |
| :--- | :--- | :--- |
| **Validación de Versión** | `direwolf -v` | Debe mostrar `Dire Wolf version 1.8` (o superior) junto con las opciones compiladas (ALSA, udev). |
| **Ruta del Ejecutable** | `which direwolf` | Debe regresar `/usr/local/bin/direwolf` o `/usr/bin/direwolf`. |
| **Presencia de Configuración** | `ls -l ~/direwolf.conf` | El archivo de configuración base debe existir en tu directorio (*Home*). |