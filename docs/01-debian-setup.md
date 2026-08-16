# 01. Preparación e Instalación de Debian 12 en MacBook Air (Early 2015)

Este documento detalla el procedimiento para instalar y configurar **Debian 12 (Bookworm) LTS** en una **MacBook Air Early 2015** (4 GB RAM, procesador Intel), dejándola optimizada como nodo/servidor para la suite de radiopaquete con Direwolf.

---

## 1. ESPECIFICACIONES Y REQUISITOS PREVIOS

| Componente | Detalle / Requerimiento |
| :--- | :--- |
| **Hardware Objetivo** | MacBook Air (Early 2015), 4 GB RAM, almacenamiento flash interno |
| **Memoria USB** | Capacidad mínima de 4 GB (se formateará por completo) |
| **Imagen ISO** | Debian 12 Netinst AMD64 (incluye `non-free-firmware`) |
| **Herramienta de Flasheo** | BalenaEtcher, Raspberry Pi Imager o comando `dd` |
| **Conexión de Red de Respaldo** | Tethering por USB desde smartphone o adaptador USB-a-Ethernet |

---

## 2. DESCARGA Y CREACIÓN DEL MEDIO DE ARRANQUE

1. **Descargar la ISO Oficial con Firmware Incluido:**
   Obtén la imagen de instalación por red de 64 bits (AMD64) que incluye los controladores no libres para hardware Apple e interfaces Wi-Fi:
   `https://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/current/amd64/iso-cd/`

2. **Grabar la ISO en la Memoria USB:**
   * Abre tu herramienta de flasheo en la Computadora B.
   * Selecciona la ISO descargada y la unidad USB.
   * Ejecuta el proceso de escritura (**Flash!**).

---

## 3. PROCESO DE INSTALACIÓN EN LA MACBOOK AIR (COMPUTADORA C)

### 3.1. Arranque EFI
1. Apaga por completo la MacBook Air.
2. Inserta la memoria USB booteable.
3. Mantén presionada la tecla **Option (⌥) / Alt** e inmediatamente presiona el botón de encendido.
4. Mantén la tecla presionada hasta que aparezca el gestor de arranque de Apple.
5. Selecciona el icono amarillo marcado como **EFI Boot** o **Orange Drive** y presiona **Enter**.

### 3.2. Paso a Paso en el Instalador de Debian
1. **Modo de Instalación:** Selecciona **Graphical Install** o **Install** (consola).
2. **Idioma y Teclado:** Selecciona `Spanish / Español` y la distribución adecuada (`Español Latinoamérica` o `Español`).
3. **Detección de Red:** 
   * Si el instalador detecta el chipset Wi-Fi Broadcom BCM4360 y solicita la carga de firmware, acepta.
   * Si no detecta la red en este paso, selecciona **"No configurar la red en este momento"** y continúa (la configuraremos en el post-inicio).
4. **Nombre de Host y Dominio:**
   * Nombre de máquina: `deb-direwolf` (o el nombre de tu preferencia).
   * Dominio: Dejar en blanco.
5. **Usuarios y Contraseñas:**
   * Define la contraseña del usuario `root`.
   * Crea el usuario principal (ej. `operador`) y asigna su contraseña.
6. **Particionado de Disco:**
   * Selecciona **Guiado - usar todo el disco**.
   * Selecciona el SSD interno de la Mac.
   * Selecciona **Todos los archivos en una sola partición** (creará automáticamente la partición `/boot/efi` y la raíz `/` en `ext4`).
   * Confirma seleccionando **Sí** para escribir los cambios en el disco.
7. **Selección de Software (Tasksel):**
   * Desmarca entornos pesados (GNOME, KDE) para optimizar el uso de los 4 GB de RAM.
   * Opcional: Marca **XFCE** si requieres escritorio ligero, o déjalo desmarcado si el equipo operará como servidor sin entorno gráfico (*Headless*).
   * **Imprescindible:** Marca **SSH server** y **Utilidades estándar del sistema**.
8. **Cargador de Arranque GRUB:** Selecciona **Sí** e instálalo en la unidad principal del sistema.
9. **Finalización:** Extrae el USB y haz clic en **Continuar** para reiniciar.

---

## 4. CONFIGURACIÓN POST-INSTALACIÓN Y CONTROLADORES

Inicia sesión en la MacBook Air como `root` o accede mediante la terminal local.

### 4.1. Habilitar Permisos Sudo
```bash
su -
apt update
apt install -y sudo
usermod -aG sudo,audio,dialout TU_USUARIO
exit