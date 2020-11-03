IDRIS_INCLUDES += -I"$(IDRIS_SUPPORT_SRC_PATH)/refc" -I"$(IDRIS_SUPPORT_SRC_PATH)/c"
CFLAGS   += $(IDRIS_INCLUDES)
CXXFLAGS += $(IDRIS_INCLUDES)

NO_CORE_MAIN_CPP := "true"

RTS_OBJS = \
	$(OBJDIR)/support/refc/casts.o \
	$(OBJDIR)/support/refc/conCaseHelper.o \
	$(OBJDIR)/support/refc/mathFunctions.o \
	$(OBJDIR)/support/refc/memoryManagement.o \
	$(OBJDIR)/support/refc/prim.o \
	$(OBJDIR)/support/refc/runtime.o \
	$(OBJDIR)/support/refc/stringOps.o

LOCAL_C_SRCS += build/exec/$(IDRIS_MAIN:.idr=.c)
OTHER_OBJS += $(RTS_OBJS)

include $(ARDUINO_MAKEFILE_PATH)

build/exec/%.c: %.idr
	rm -f "$@"
	CC=true idris2 --codegen refc "$<" <<< ":compile $(basename $(notdir "$@")) main"
	sed -i 's/Value \*mainExprVal/init();\n   Value *mainExprVal/' "$@"
	sed -i 's|// add header(s) for library: libarduino|#include "Arduino.h"|' "$@"

# Idris2 support files
$(OBJDIR)/support/%.o: $(IDRIS_SUPPORT_SRC_PATH)/%.c $(COMMON_DEPS) | $(OBJDIR)
	@$(MKDIR) $(dir $@)
	$(CC) -MMD -c $(CPPFLAGS) $(CFLAGS) $< -o $@
