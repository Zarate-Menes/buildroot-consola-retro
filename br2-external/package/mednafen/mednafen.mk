# mednafen.mk
#
# Autores: Beltrán García Fernando, Vargas Luna José Ángel, Zárate Menes Quetzalli
# Fecha: 2026.11.12
# Licencia: MIT
#
# Receta de Buildroot para compilar Mednafen 1.32.1 solo con los módulos
# de NES, SNES y Game Boy Advance.

MEDNAFEN_VERSION = 1.32.1
MEDNAFEN_SOURCE = mednafen-$(MEDNAFEN_VERSION).tar.xz
MEDNAFEN_SITE = https://mednafen.github.io/releases/files
MEDNAFEN_LICENSE = GPL-2.0+
MEDNAFEN_LICENSE_FILES = COPYING
MEDNAFEN_DEPENDENCIES = host-pkgconf sdl2 alsa-lib flac zlib
MEDNAFEN_CONF_ENV = SDL2_CONFIG="$(STAGING_DIR)/usr/bin/sdl2-config"

MEDNAFEN_CONF_OPTS = \
	--disable-nls \
	--disable-debugger \
	--disable-jack \
	--disable-apple2 --disable-gb --disable-lynx --disable-md \
	--disable-ngp --disable-pce --disable-pce-fast --disable-pcfx \
	--disable-psx --disable-sasplay --disable-sms --disable-ss \
	--disable-ssfplay --disable-vb --disable-wswan \
	--enable-nes --enable-snes --enable-snes-faust --enable-gba

$(eval $(autotools-package))
