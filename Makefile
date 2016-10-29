TARGET          := dwmguard
OBJDIR          := objs
SRC             != (ls *.c || true)
OBJFILES        := $(SRC:.c=.o)
OBJ             := $(SRC:.c=$(OBJDIR)/%.o)
BUILD_HOST      := build_host.h
CC              ?= cc

INCLUDES        :=
LIBS            :=

CFLAGS          := -Wall $(INCLUDES)
LFLAGS          := $(LIBS)

INSTALL         := install
INSTALL_ARGS    := -o root -g wheel -m 755
INSTALL_DIR     := /usr/local/bin/

.if $(CC) == cc || $(CC) == clang || $(CC) == gcc
    CFLAGS += -std=c99 -pedantic
.endif

REVCNT != (git rev-list --count master 2>/dev/null || true)
.if empty(REVCNT)
    VERSION = devel
.else
    REVHASH != (git log -1 --format="%h" 2>/dev/null || true)
    VERSION = "$(REVCNT).$(REVHASH)"
.endif

.if make(release)
    CFLAGS += -Os
    LFLAGS +=
.else # debug
    CFLAGS += -g -ggdb -DDEBUG
    LFLAGS += -g
.endif

all: debug

debug: build

release: clean build

build: $(TARGET)

$(BUILD_HOST):
	@echo "#define BUILD_HOST \"`hostname`\""      > $(BUILD_HOST)
	@echo "#define BUILD_OS \"`uname`\""          >> $(BUILD_HOST)
	@echo "#define BUILD_PLATFORM \"`uname -m`\"" >> $(BUILD_HOST)
	@echo "#define BUILD_KERNEL \"`uname -r`\""   >> $(BUILD_HOST)
	@echo "#define BUILD_VERSION \"$(VERSION)\""  >> $(BUILD_HOST)

$(TARGET): $(OBJDIR) $(BUILD_HOST) $(OBJFILES)
	$(CC) $(LFLAGS) -o $@ $(OBJ)

.c.o :
	$(CC) $(CFLAGS) -o $(OBJDIR)/$@ -c $<

install: release
	$(INSTALL) $(INSTALL_ARGS) $(TARGET) $(INSTALL_DIR)
	@echo "DONE"

$(OBJDIR):
	@mkdir -p $@

clean:
	-rm -f *.core $(BUILD_HOST)
	-rm -f *.o $(TARGET)
	-rm -rf ./$(OBJDIR)
	-rm -rf ./obj

.PHONY : all debug release build install clean
