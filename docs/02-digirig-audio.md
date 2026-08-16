


# 02. Identificación, Calibración de Audio y PTT (DigiRig Lite + Alinco DR-735)

Este documento detalla el procedimiento para identificar la interfaz **DigiRig Lite** en Debian 12, ajustar los niveles de audio en ALSA para evitar distorsión en AFSK (1200 baudios) y validar el control de PTT con el transceptor **Alinco DR-735**.

---

## 1. IDENTIFICACIÓN DEL HARDWARE EN DEBIAN (COMPUTADORA C)

Al conectar la DigiRig Lite mediante un puerto USB a la MacBook Air, el kernel de Linux debe detectar el chip de audio integrado (C-Media CM108/CM108AH).

### 1.1. Verificación en el Bus USB

Ejecuta el siguiente comando para confirmar que el sistema reconoce la interfaz físicamente:

```bash
lsusb
```

* **Resultado esperado:** Una línea en la salida similar a la siguiente:
  ```text
  Bus 001 Device 00X: ID 0d8c:013c C-Media Electronics, Inc. CM108 Audio Controller
  ```

### 1.2. Mapeo de Dispositivos de Audio en ALSA

Determina los índices numéricos de la tarjeta (`card`) y del dispositivo (`device`) asignados por el sistema:

```bash
# Tarjetas de reproducción / salida de audio (TX)
aplay -l

# Tarjetas de captura / entrada de audio (RX)
arecord -l
```

* **Resultado esperado:** Identifica la entrada correspondiente a la tarjeta USB:
  ```text
  card 1: Headset [USB Audio Device], device 0: USB Audio [USB Audio]
  ```
  *(Anota el número de `card`, habitualmente `1` o `2`, ya que se utilizará en la configuración de Direwolf).*

---

## 2. CALIBRACIÓN DE NIVELES DE AUDIO (`alsamixer`)

Para garantizar una decodificación óptima y evitar saturar el receptor o transmisor, los niveles de audio deben ajustarse sin recortes (*clipping*).

### 2.1. Ajuste de Niveles

1. **Abre la herramienta interactiva de ALSA** especificando el número de tu tarjeta USB (reemplaza `1` si tu tarjeta tiene otro número):
   ```bash
   alsamixer -c 1
   ```

2. **Nivel de Entrada / Recepción (Capture - RX):**
   * Presiona `F4` para ir a la pestaña de **Captura**.
   * Ajusta la ganancia inicial entre **40% y 60%**. Un nivel de audio demasiado alto saturará el módem software de Direwolf.

3. **Nivel de Salida / Transmisión (Playback - TX):**
   * Presiona `F3` para ir a la pestaña de **Reproducción**.
   * Establece el nivel de volumen inicial en **50%**.

### 2.2. Persistencia del Ajuste

Guarda la configuración para que los niveles de audio se mantengan tras reiniciar el sistema:

```bash
sudo alsactl store
```

---

## 3. CONFIGURACIÓN DEL PTT (PUSH-TO-TALK)

La DigiRig Lite utiliza las líneas de control del chip C-Media (GPIO) o una línea serial RTS/DTR para activar el PTT en la Alinco DR-735.

* **Método Directo (CM108 GPIO / RTS):** Direwolf controla directamente los pines del chip de audio USB sin depender de un puerto `/dev/ttyUSB`.
* **Método Serie (UART):** Si se utiliza la interfaz serial de la DigiRig, el dispositivo se registrará como `/dev/ttyUSB0` o `/dev/ttyACM0`.

### 3.1. Verificación de Permisos

Confirma que tu usuario pertenece al grupo `dialout` para poder controlar puertos de comunicación y líneas de PTT:

```bash
groups | grep dialout
```

---

## 4. MATRIZ DE PRUEBAS Y VALIDACIÓN DE DIAGNÓSTICO

Ejecuta estas pruebas en la **Computadora C** para validar que la interfaz de audio y control funciona correctamente antes de levantar Direwolf:

| Prueba | Comando en Terminal | Criterio de Aceptación / Resultado |
| :--- | :--- | :--- |
| **Detección USB** | `lsusb \| grep -i "audio"` | Muestra la línea del controlador C-Media |
| **Acceso a ALSA** | `alsamixer -c 1` | Despliega la interfaz gráfica de controles sin errores |
| **Prueba de Graba RX** | `arecord -D hw:1,0 -f S16_LE -r 48000 -c 1 /tmp/test.wav` | Genera un archivo `.wav` que reproduce el audio del canal del radio |
| **Permisos de Usuario** | `ls -l /dev/snd/*` | El usuario activo tiene permisos de lectura y escritura (`rw`) |
