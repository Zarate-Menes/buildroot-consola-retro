# external.mk
#
# Autores: Beltrán García Fernando, Vargas Luna José Ángel, Zárate Menes Quetzalli
# Fecha: 2026.11.12
# Licencia: MIT
#
# Incluye los instructivos de los paquetes propios del árbol externo.
include $(sort $(wildcard $(BR2_EXTERNAL_CONSOLA_RETRO_PATH)/package/*/*.mk))
