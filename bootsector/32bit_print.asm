; The formula for accessing a specific character on the 80x25 grid is:
;0xb8000 + 2 * (row * 80 + col)
[bits 32] ;protected mode
VIDEO_MEMORY equ 0xb8000
COLOR_WHITE_ON_BLACK 0x0f

get_string_pm:
    pusha
    mov edx , VIDEO_MEMORY

print_string_pm:
    mov al, [ebx];ebx will contain the string
    mov ax, COLOR_WHITE_ON_BLACK

    cmp al, 0 ; check if end of string
    je print_done_pm

    mov [edx], ax ; keep track of the location in the video memory
    add ebx, 1
    add edx , 2 ; n ext video postion in memory

    jmp print_string_pm

print_done_pm:
    popa
    ret