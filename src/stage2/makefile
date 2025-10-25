AS = nasm

ASM = stage2.asm

all: boot.bin

boot.bin: $(ASM)
	$(AS) $(ASFLAGS) -f bin $^ -o $@
