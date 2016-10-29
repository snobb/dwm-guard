TARGET          := dwmguard
OBJDIR          := obj
SRC             := $(wildcard *.c)
OBJ             := $(addprefix $(OBJDIR)/,$(notdir $(SRC:.c=.o)))
CC              ?= cc
BUILD_HOST      := build_host.h

INCLUDES        :=
LIBS            :=

CFLAGS          := -Wall $(INCLUDES)
LFLAGS          := $(LIBS)

INSTALL         := install
INSTALL_ARGS    := -o root -g root -m 755
INSTALL_DIR     := /usr/local/bin/

ifeq ($(CC), $(filter $(CC), clang gcc cc))
	CFLAGS += -std=c99 -pedantic
endif

all: debug

debug: CFLAGS += -g -DDEBUG
debug: LFLAGS += -g
debug: build

release: CFLAGS +=-Os
release: clean build
	strip $(TARGET)

build: $(OBJDIR) $(BUILD_HOST) $(TARGET)

$(BUILD_HOST):
	@echo "#define BUILD_HOST \"`hostname`\""      > $(BUILD_HOST)
	@echo "#define BUILD_OS \"`uname`\""          >> $(BUILD_HOST)
	@echo "#define BUILD_PLATFORM \"`uname -m`\"" >> $(BUILD_HOST)
	@echo "#define BUILD_KERNEL \"`uname -r`\""   >> $(BUILD_HOST)

$(TARGET): $(BUILD_HOST) $(OBJ)
	$(CC) $(LFLAGS) -o $@ $(OBJ)

$(OBJDIR)/%.o : %.c
	$(CC) $(CFLAGS) -o $@ -c $?

$(OBJDIR):
	@mkdir -p $(OBJDIR)

install: release
	$(INSTALL) $(INSTALL_ARGS) $(TARGET) $(INSTALL_DIR)
	@echo "DONE"

clean:
	-rm -f *.core
	-rm -f $(BUILD_HOST)
	-rm -f $(TARGET)
	-rm -rf ./$(OBJDIR)

.PHONY : all debug release build run clean objdir
