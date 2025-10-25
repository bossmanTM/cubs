CC = i686-elf-gcc
AS = nasm
LD = i686-elf-ld

OBJ = boot.o
ASM = boot.asm

run: boot
	qemu-system-x86_64 boot.bin

boot: $(ASM)
	$(AS) $(ASFLAGS) -f bin $^ -o $@.bin
