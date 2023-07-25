; Bootloader

[org 0x7c00] ; Offset the instructions to the correct memory location of the bootloader

; Set up the stack pointer away from 0x7c00
    mov bp, 0x9000
    mov sp, bp

; Print a message indicating the bootloader has started in 16-bit Real Mode
    mov bx, MSG_REAL_MODE
    call print_string

; Switch to 32-bit Protected Mode
    call switch_to_pm

    jmp $ ; Infinite loop to halt execution (optional, as bootloader will not reach this point)

; Include external functions
%include "boot_sector_print.asm"
%include "gdt.asm"
%include "32bit_print.asm"
%include "switch_pm.asm"


[bits 32]

BEGIN_PM:
    ; Print a message indicating successful landing in 32-bit Protected Mode
    mov ebx, MSG_PROT_MODE
    call print_string_pm

    jmp $ ; Infinite loop to halt execution (optional, as bootloader will not reach this point)

; Global variables
MSG_REAL_MODE db "Started in 16-bit real mode", 0
MSG_PROT_MODE db "Loaded 32-bit protected mode", 0

; Padding with zeros to reach the boot sector size (510 bytes)
times 510-($-$$) db 0

; Boot signature (magic number) to indicate a valid boot sector
dw 0xaa55