CC = i686-elf-gcc
AS = nasm
LD = i686-elf-ld

OBJ = boot.o
ASM = boot.asm

all: boot.bin

run: boot
	qemu-system-x86_64 boot.bin

boot.bin: $(ASM)
	$(AS) $(ASFLAGS) -f bin $^ -o $@
