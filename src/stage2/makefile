AS = nasm

ASM = stage2.asm

boot: $(ASM)
	$(AS) $(ASFLAGS) -f bin $^ -o $@.bin
