# env.sh
#
# Autores: Beltrán García Fernando, Vargas Luna José Ángel, Zárate Menes Quetzalli
# Fecha: 2026.11.12
# Licencia: MIT
#
# Atajos para compilar con Buildroot fuera de su árbol de código.
# Uso: source env.sh; después "br" (desarrollo) o "brp" (producción).

PROYECTO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PROYECTO
export BR_VER=2025.02.19
export BR2_DL_DIR="$PROYECTO/dl"

br()  { make -C "$PROYECTO/buildroot-$BR_VER" BR2_EXTERNAL="$PROYECTO/br2-external" O="$PROYECTO/output" "$@"; }
brp() { make -C "$PROYECTO/buildroot-$BR_VER" BR2_EXTERNAL="$PROYECTO/br2-external" O="$PROYECTO/output-prod" "$@"; }
