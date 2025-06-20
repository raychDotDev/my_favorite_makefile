CC=clang
CFLAGS=-g -Wall -Werror -Wno-implicit-function-declaration --target=x86_64-w64-mingw32 -Iinclude #-mwindows

LDFLAGS=-Iinclude -Llib
TARGET=game

EXTENSION=.exe

BINDIR=./bin
SRCDIR=./src
OBJDIR=./obj
INCDIR=./include
LIBDIR=./lib

SRC=$(wildcard $(SRCDIR)/*.c $(SRCDIR)/**/*.c)
OBJ=$(patsubst $(SRCDIR)/%.c, $(OBJDIR)/%.o, $(SRC))

init:
	mkdir -p $(SRCDIR)
	mkdir -p $(BINDIR)
	mkdir -p $(OBJDIR)
	mkdir -p $(INCDIR)
	mkdir -p $(LIBDIR)
	touch $(SRCDIR)/main.c

all: $(TARGET)

rebuild: clean $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(OBJ) -o $(BINDIR)/$(TARGET)$(EXTENSION) $(CFLAGS) $(LDFLAGS)
	find $(LIBDIR) -name \*.dll -ecec cp {} $(BINDIR)/

$(OBJDIR)/%.o: $(SRCDIR)/%.c
	mkdir -p $(dir $@, hacks)
	$(CC) -c $< -o $@ $(CFLAGS)

clean:
	rm -f $(BINDIR)/*.* $(OBJDIR)/*.o $(OBJDIR)/**/*.o
	rm -rf $(OBJDIR)/*.* $(OBJDIR)/**/*.*

run:
	$(BINDIR)/$(TARGET)$(EXTENSION)

debug:
	lldb $(BINDIR)/$(TARGET)$(EXTENSION)
