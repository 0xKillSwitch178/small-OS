C_SOURCES = $(wildcard kernel/*.c drivers/*.c cpu/*.c stdlib/*.c) 
HEADERS = $(wildcard kernel/*.h drivers/*.h cpu/*.h stdlib/*.h)

# Nice syntax for file extension replacement
OBJ = ${C_SOURCES:.c=.o cpu/interrupt.o}

CC = /usr/bin/gcc
GDB = /usr/bin/gdb
NASM = /usr/bin/nasm
# -g: Use debugging symbols in gcc
CFLAGS = -g -ffreestanding -Wall -Wextra -fno-exceptions -m32

# First rule is run by default
os-image.bin: boot/boot_sector_main.bin kernel.bin
	cat $^ > os-image.bin

# '--oformat binary' deletes all symbols as a collateral, so we don't need
# to 'strip' them manually on this case
kernel.bin: boot/kernel_entry.o ${OBJ}
	ld -m elf_i386 -o $@ -Ttext 0x1000 boot/kernel_entry.o ${OBJ} --oformat binary

# Used for debugging purposes
kernel.elf: boot/kernel_entry.o ${OBJ}
	ld -m elf_i386 -o $@ -Ttext 0x1000 boot/kernel_entry.o ${OBJ}

run: os-image.bin
	qemu-system-i386 -fda os-image.bin

# Open the connection to qemu and load our kernel-object file with symbols
debug: os-image.bin kernel.elf
	qemu-system-i386 -s -fda os-image.bin &
	${GDB} -ex "target remote localhost:1234" -ex "symbol-file kernel.elf"

# Generic rules for wildcards
# To make an object, always compile from its .c
%.o: %.c ${HEADERS}
	${CC} ${CFLAGS} -ffreestanding -c $< -o $@

%.o: %.asm
	${NASM} $< -f elf -o $@

%.bin: %.asm
	${NASM} $< -f bin -o $@

clean:
	rm -rf *.bin *.dis *.o os-image.bin *.elf
	rm -rf kernel/*.o boot/*.bin drivers/*.o boot/*.o cpu/*.o stdlib/*.o
