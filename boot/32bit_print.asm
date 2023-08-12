; Switch to protected mode
[bits 32]

; The memory address of the text-mode video buffer
VIDEO_MEMORY equ 0xb8000

; Color attribute for white text on a black background
COLOR_WHITE_ON_BLACK equ 0x0f

; Function to print a null-terminated string in 32-bit protected mode
print_string_pm:
    pusha                   ; Save all general-purpose registers on the stack
    mov edx, VIDEO_MEMORY   ; Set the video memory buffer address to EDX

print_string_pm_loop:
    mov al, [ebx]           ; Load a character from the memory location pointed by EBX into AL
    mov ah, COLOR_WHITE_ON_BLACK ; Set the color attribute for the character to AH

    cmp al, 0               ; Check if the character is null (end of string)
    je print_done_pm        ; If it's the end of the string, we are done

    mov [edx], ax           ; Store the character and its color attribute in the video memory
    add ebx, 1              ; Move to the next character in the string
    add edx, 2              ; Move to the next position in video memory (each character takes 2 bytes)

    jmp print_string_pm_loop ; Repeat the process for the next character in the string

print_done_pm:
    popa                    ; Restore the saved general-purpose registers
    ret                     ; Return from the function
