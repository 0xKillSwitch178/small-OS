# Define the architecture and entry point for the linker
LDFLAGS = -m elf_i386 -Ttext 0x1000

# First rule is the one executed when no parameters are fed to the Makefile
all: run

# Notice how dependencies are built as needed
kernel/kernel.bin: bootsector/kernel_entry.o kernel/kernel.o
	ld $(LDFLAGS) -o $@ $^ --oformat binary

bootsector/kernel_entry.o: bootsector/kernel_entry.asm
	nasm -f elf -o $@ $<

kernel/kernel.o: kernel/kernel.c
	gcc -m32 -ffreestanding -c $< -o $@

# Rule to disassemble the kernel - may be useful for debugging
kernel/kernel.dis: kernel/kernel.bin
	ndisasm -b 32 $< > $@

bootsector/bootsect.bin: bootsector/boot_sector_main.asm
	nasm -f bin -o $@ $<

bins/os-image.bin: bootsector/boot_sector_main.bin kernel/kernel.bin
	cat $^ > $@

run: bins/os-image.bin
	qemu-system-i386 -fda $<

clean:
	rm -f kernel/kernel.bin bootsector/kernel_entry.o kernel/kernel.o kernel/kernel.dis bootsector/boot_sector_main.bin bins/os-image.bin
