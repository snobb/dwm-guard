TARGET = dwmguard
SRC = $(wildcard *.c)
OBJ = $(SRC:.c=.o)
CC = clang
CFLAGS = -Wall
INSTALL = install
INSTALL_ARGS = -o root -g root -m 755
INSTALL_DIR = /usr/local/bin/

ifeq ($(CC), $(filter $(CC), cc clang gcc))
	CFLAGS += -std=c99 -pedantic
endif

all: debug

debug: CFLAGS += -g -DDEBUG
debug: LFLAGS += -g
debug: build

release: CFLAGS += -Os
release: LFLAGS += -s
release: clean build

build: build_host.h $(TARGET)

build_host.h:
	@echo "#define BUILD_HOST \"`hostname`\""      > build_host.h
	@echo "#define BUILD_OS \"`uname`\""          >> build_host.h
	@echo "#define BUILD_PLATFORM \"`uname -m`\"" >> build_host.h
	@echo "#define BUILD_KERNEL \"`uname -r`\""   >> build_host.h
	@echo "#define BUILD_VERSION \"$(VERSION)\""  >> build_host.h

$(TARGET): build_host.h $(OBJ)
	$(CC) $(LFLAGS) -o $@ $(OBJ)

%.o : %.c
	$(CC) $(CFLAGS) -o $@ -c $?

install: release
	$(INSTALL) $(INSTALL_ARGS) $(TARGET) $(INSTALL_DIR)
	@echo "DONE"

clean:
	-rm -f *.core
	-rm -f build_host.h
	-rm -f *.o $(TARGET)

.PHONY : all debug release build install clean
