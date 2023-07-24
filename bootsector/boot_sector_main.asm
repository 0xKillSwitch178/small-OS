[org 0x7c00] ; Offset the instructions to the correct memory location of the bootloader

mov bp, 0x8000 ; Set the stack away from 0x7c00
mov sp, bp

mov dl, 0x80 ; Set dl to boot from the first hard disk (0x80)

mov bx, 0x9000
mov dh, 2 ; Read 2 sectors from the disk

call disk_load

mov dx, [0x9000]  ; Retrieve the first sector 
call print_hex
call print_nl

mov dx, [0x9000 + 512] ; Retrieve the second sector
call print_hex

jmp $

%include "boot_sector_load_disk.asm"
%include "boot_sector_print.asm"

; Padding with zeros and setting the magic numbers
times 510-($-$$) db 0
dw 0xaa55

times 256 dw 0xcafe ; Sector 2
times 256 dw 0xbabe ; Sector 3
