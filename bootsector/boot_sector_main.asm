; Bootloader - loads and prints the content of two sectors from the first hard disk

[org 0x7c00] ; Offset the instructions to the correct memory location of the bootloader

; Set up the stack pointer away from 0x7c00
mov bp, 0x8000
mov sp, bp

; Set dl to boot from the first hard disk (0x80)
mov dl, 0x80

; Set up parameters for reading 2 sectors from the disk
mov bx, 0x9000 ; Buffer to read the sectors to
mov dh, 2 ; Number of sectors to read

; Call the disk_load function to read the sectors from the disk into memory at 0x9000
call disk_load

; Retrieve and print the content of the first sector in hexadecimal format
mov dx, [0x9000]
call print_hex
call print_nl ; Print a new line

; Retrieve and print the content of the second sector in hexadecimal format
mov dx, [0x9000 + 512] ; The second sector starts at offset 512 (512 bytes = 1 sector)
call print_hex

jmp $ ; Infinite loop to keep the bootloader running

; Include external functions
%include "boot_sector_load_disk.asm"
%include "boot_sector_print.asm"

; Padding with zeros to reach the boot sector size (510 bytes)
times 510-($-$$) db 0

; Boot signature (magic number) to indicate a valid boot sector
dw 0xaa55

; Additional data in sector 2 and sector 3 (256 words = 512 bytes each)
times 256 dw 0xcafe ; Sector 2
times 256 dw 0xbabe ; Sector 3
