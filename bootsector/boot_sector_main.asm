; Bootloader

[org 0x7c00]         ; Offset the instructions to the correct memory location of the bootloader
KERNEL_OFFSET equ 0x1000 ; The offset where we will load our kernel.

    mov [BOOT_DRIVE], dl
    ; Set up the stack pointer away from 0x7c00
    mov bp, 0x9000
    mov sp, bp

    ; Print a message indicating the bootloader has started in 16-bit Real Mode
    mov bx, MSG_REAL_MODE
    call print_string
    call print_nl

    call load_kernel

    ; Switch to 32-bit Protected Mode
    call switch_to_pm

    jmp $ ; Infinite loop to halt execution (optional, as bootloader will not reach this point)

; Include external functions
%include "bootsector/boot_sector_print.asm"
%include "bootsector/boot_sect_disk_load.asm"
%include "bootsector/gdt.asm"
%include "bootsector/32bit_print.asm"
%include "bootsector/switch_pm.asm"

[bits 16]
load_kernel:
    mov bx, MSG_LOAD_KERNEL
    call print_string
    call print_nl
    mov bx, KERNEL_OFFSET
    mov dh, 15       ; Load the first 15 sectors excluding the boot sector just in case
    mov dl, [BOOT_DRIVE]
    call disk_load

    ret

[bits 32]
BEGIN_PM:
    ; Print a message indicating successful landing in 32-bit Protected Mode
    mov ebx, MSG_PROT_MODE
    call print_string_pm

    call KERNEL_OFFSET

    jmp $ ; Infinite loop to halt execution (optional, as bootloader will not reach this point)

; Global variables
BOOT_DRIVE db 0
MSG_REAL_MODE db " Started in 16 - bit Real Mode ", 0
MSG_PROT_MODE db " Successfully landed in 32 - bit Protected Mode ", 0
MSG_LOAD_KERNEL db " Loading kernel into memory. ", 0

; Padding with zeros to reach the boot sector size (510 bytes)
times 510-($-$$) db 0

; Boot signature (magic number) to indicate a valid boot sector
dw 0xaa55
