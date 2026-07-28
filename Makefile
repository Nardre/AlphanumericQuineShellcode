CC      := gcc
CFLAGS  := -m32 -Wall -Wextra -no-pie
NASM    := nasm
LDFLAGS := -m elf_i386
LD      := ld

SRC_ASM := quine.s
OBJ_ASM := quine.o
ELF_BIN := quine
RAW_BIN := quine.bin
LOADER  := loader

.PHONY: all hex loader run clean

# "all" lance directement l'exécution
all: run

$(ELF_BIN): $(OBJ_ASM)
	$(LD) $(LDFLAGS) -o $@ $<

$(OBJ_ASM): $(SRC_ASM)
	$(NASM) -f elf32 -o $@ $<

hex: $(RAW_BIN)
	@hexdump -v -e '"\\" "x" 1/1 "%02x"' $(RAW_BIN)
	@echo ""
	@cat $(RAW_BIN)
	@echo ""
	@cat $(RAW_BIN) | ndisasm -b 32 -

$(RAW_BIN): $(SRC_ASM)
	$(NASM) -f bin -o $@ $<

loader: loader.c
	$(CC) $(CFLAGS) -o $(LOADER) $<

run: loader $(RAW_BIN)
	./$(LOADER) "$$(cat $(RAW_BIN))"

clean:
	rm -f $(OBJ_ASM) $(ELF_BIN) $(RAW_BIN) $(LOADER)
