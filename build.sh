#!/usr/bin/env bash
#
# build.sh
#
# Autores: Beltrán García Fernando, Vargas Luna José Ángel, Zárate Menes Quetzalli
# Fecha: 2026.11.12
# Licencia: MIT
#
# Compila de forma automatizada la distro de la consola retro para la
# Raspberry Pi 3B+: instala dependencias, descarga Buildroot, verifica su
# integridad, aplica la configuración del proyecto y genera la imagen para
# balenaEtcher.
#
# Uso: ./build.sh        variante de producción
#      ./build.sh dev    variante de desarrollo

set -euo pipefail

BR_VER=2025.02.19
BR_SHA256=e5e58bff1da91f022f60cefdfe280140c08023cd0aeec1e5f6f9da0ea866d69c
RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$RAIZ"

if [ "${1:-}" = "dev" ]; then
	DEFCONFIG=consola_dev_defconfig
	SALIDA=output
else
	DEFCONFIG=consola_retro_defconfig
	SALIDA=output-prod
fi

# Dependencias del equipo anfitrión (Debian, Ubuntu, Linux Mint)
if command -v apt-get >/dev/null 2>&1; then
	sudo apt-get update
	sudo apt-get install -y build-essential debianutils sed make binutils diffutils \
		bash patch gzip bzip2 perl tar cpio unzip rsync file bc findutils wget git \
		python3 libncurses-dev libssl-dev bison flex gawk
fi

# Descarga y verificación de Buildroot
mkdir -p dl
if [ ! -d "buildroot-$BR_VER" ]; then
	wget -nc -P dl "https://buildroot.org/downloads/buildroot-$BR_VER.tar.xz"
	echo "$BR_SHA256  dl/buildroot-$BR_VER.tar.xz" | sha256sum -c -
	tar xf "dl/buildroot-$BR_VER.tar.xz"
fi

# Configuración y compilación fuera del árbol de Buildroot
export BR2_DL_DIR="$RAIZ/dl"
make -C "buildroot-$BR_VER" BR2_EXTERNAL="$RAIZ/br2-external" O="$RAIZ/$SALIDA" "$DEFCONFIG"
make -C "buildroot-$BR_VER" BR2_EXTERNAL="$RAIZ/br2-external" O="$RAIZ/$SALIDA"

echo "Imagen generada: $RAIZ/$SALIDA/images/sdcard.img"
