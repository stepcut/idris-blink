ARDUINO_PACKAGE_DIR := $(HOME)/.arduino15/packages
ADRUINO_DIR=/usr/share/arduino

IDRIS_SUPPORT_SRC_PATH=rts

IDRIS_MAIN=Blink.idr

# Choose the board you have
include aux-makefiles/board-uno.mk
#include aux-makefiles/board-mega2560.mk
#include aux-makefiles/board-due.mk

include aux-makefiles/Idris2.mk
