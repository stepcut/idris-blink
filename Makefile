ARDUINO_PACKAGE_DIR := $(HOME)/.arduino15/packages
ADRUINO_DIR=/usr/share/arduino

# For AVR-based boards
AVR_TOOLS_DIR=/usr
AVRDUDE_CONF=/etc/avrdude.conf
ARDUINO_MAKEFILE_PATH=arduino-makefile/Arduino.mk

# For ARM SAM-based boards
#ARDUINO_MAKEFILE_PATH=arduino-makefile/Sam.mk

IDRIS_SUPPORT_SRC_PATH=rts

IDRIS_MAIN=Blink.idr

# For Arduino Uno
BOARD_TAG=uno

# For Arduino Mega 2560
#BOARD_TAG=mega
#BOARD_SUB=atmega2560

# For Arduino Due
#BOARD_TAG=arduino_due_x
#ARCHITECTURE=sam

include Idris2.mk
