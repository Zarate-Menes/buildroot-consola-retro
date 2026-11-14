# buildroot-consola-retro

Distro de Linux de propósito específico, construida con Buildroot, que convierte
una Raspberry Pi 3 Model B+ en la base de una consola de videojuegos retro
(NES, SNES y Game Boy Advance con Mednafen). Integra solo los componentes
necesarios y arranca en pocos segundos mostrando una imagen personalizada
con música.

Proyecto final de Fundamentos de Sistemas Embebidos.

**Autores:** Beltrán García Fernando, Vargas Luna José Ángel, Zárate Menes Quetzalli

## Enlaces

- Imagen lista para balenaEtcher: sección **Releases** de este repositorio
- Video demostrativo: (pendiente)

## Contenido de la imagen

| Componente | Detalle |
|---|---|
| Placa | Raspberry Pi 3 Model B+ (exclusiva) |
| Kernel | Linux 6.6.28 (fork raspberrypi/linux), 64 bits, PREEMPT, HZ=1000 |
| Sistema base | Buildroot 2025.02.19, glibc, BusyBox init + mdev |
| Video y audio | Mesa vc4 (GBM, EGL, GLES), SDL2 sobre KMS/DRM, ALSA por HDMI |
| Emulador | Mednafen 1.32.1 (NES, SNES, GBA) |
| Entrada | Controlador xpad (gamepad Xbox 360 cableado), memoria USB FAT32 |
| Particiones | Arranque FAT 32 MB, raíz SquashFS LZ4 de solo lectura, datos ext4 256 MB |
| Arranque | Splash en framebuffer con música en bucle, sin texto ni inicio de sesión |

## Descarga

```bash
git clone https://github.com/Zarate-Menes/buildroot-consola-retro.git
cd buildroot-consola-retro
```

## Compilación

Requiere un equipo Linux x86_64 (probado en Linux Mint) con unos 30 GB libres.
La primera compilación tarda alrededor de una hora.

```bash
chmod +x build.sh
./build.sh          # variante de producción
./build.sh dev      # variante de desarrollo (opcional)
```

La imagen queda en `output-prod/images/sdcard.img` y se graba en la microSD
con balenaEtcher.

Para trabajar paso a paso:

```bash
source env.sh
brp consola_retro_defconfig
brp
```

## Estructura

```
br2-external/                      árbol externo de Buildroot (CONSOLA_RETRO)
├── configs/                       consola_retro_defconfig (producción), consola_dev_defconfig (desarrollo)
├── board/rpi3bp-consola/
│   ├── linux.fragment             cambios al kernel
│   ├── busybox_prod.fragment      servicios desactivados en producción
│   ├── config.txt                 firmware de la Raspberry Pi
│   ├── cmdline.txt                línea de comandos del kernel (desarrollo)
│   ├── cmdline_prod.txt           línea de comandos del kernel (producción)
│   ├── genimage.cfg.in            particiones de la microSD
│   ├── post-image.sh              generación de la imagen (Buildroot)
│   ├── rootfs_overlay/            scripts de arranque, splash y mantenimiento
│   └── rootfs_overlay_prod/       enlace /root/.mednafen -> /data/mednafen
└── package/mednafen/              instructivo de Mednafen
recursos/                          imagen original del splash y audio de inicio
build.sh                           compilación automatizada
env.sh                             atajos br / brp
```

Los archivos `cmdline.txt` y `cmdline_prod.txt` no llevan encabezado porque el
firmware solo lee su primera línea; `external.desc` tampoco, porque Buildroot
lee su formato fijo.

## Integración con la aplicación de la consola

- `/etc/init.d/S00splash stop` detiene la música del splash.
- Las ROMs van en `/data/roms/{nes,snes,gba}`.
- La configuración de Mednafen está en `/data/mednafen/mednafen.cfg`.

## En caso de algún error en la compilación 

### La compilación se interrumpió (apagado, suspensión, Ctrl+C)

Basta con volver a ejecutar el script. Buildroot continúa desde el último
paquete terminado y no repite lo ya compilado ni lo ya descargado.

```bash
./build.sh
```

### Un paquete quedó a medias y falla al continuar

El mensaje de error indica el paquete (por ejemplo `mesa3d` o `host-attr`).
Se borra solo ese paquete y se vuelve a ejecutar el script:

```bash
make -C buildroot-2025.02.19 O=$PWD/output-prod <paquete>-dirclean
./build.sh
```

### Error de autotools: `automake terminated by signal 11`

Síntoma: la compilación se detiene en un paquete del anfitrión con un mensaje
como:

```
autoreconf: error: .../output-prod/host/bin/automake terminated by signal 11
make[1]: *** [package/pkg-generic.mk:262: .../build/host-attr-2.5.2/.stamp_configured] Error 1
```

Causa: las herramientas de autotools que Buildroot genera para el equipo
anfitrión (automake y autoconf) quedaron dañadas, por ejemplo tras una
actualización de Perl del sistema durante la compilación. No es un error de la
configuración del proyecto.

Solución: regenerar esas herramientas y continuar.

```bash
make -C buildroot-2025.02.19 O=$PWD/output-prod host-automake-dirclean host-autoconf-dirclean host-attr-dirclean
./build.sh
```

Para la variante de desarrollo se usa `O=$PWD/output` en lugar de
`O=$PWD/output-prod`.

### Espacio en disco

La compilación completa ocupa alrededor de 30 GB entre `dl/`, `output-prod/` y
el código de Buildroot. Si falta espacio, se puede borrar la variante que no se
use (`output/` u `output-prod/`).

## Licencias y créditos

- Archivos propios de este repositorio: MIT (ver `LICENSE`).
- `post-image.sh`: proyecto Buildroot, GPL-2.0-or-later.
- Buildroot y el kernel Linux: GPL-2.0. No se incluye su código fuente; se descargan al compilar.
- Mednafen: GPL-2.0-or-later. Solo se incluye el instructivo de compilación.
- Música de arranque: «Night Shade», AdhesiveWombat (uso libre), fragmento de 30 s.
