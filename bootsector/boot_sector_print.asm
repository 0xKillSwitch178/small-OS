; Function to print a new line
print_nl:
    pusha

    mov ah, 0x0e ; Set tty mode
    mov al, 0x0a ; New line character '\n'
    int 0x10     ; BIOS interrupt to print the character
    mov al, 0x0d ; Carriage return '\r'
    int 0x10     ; BIOS interrupt to print the character

    popa
    ret

; Function to print a null-terminated string from the memory address pointed by BX
print:
    pusha

start:
    mov al, [bx] ; Load the character at BX into AL
    cmp al, 0    ; Check if the character is null (end of string)
    je done      ; If it's null, exit the loop

    mov ah, 0x0e ; Set tty mode
    int 0x10     ; BIOS interrupt to print the character

    add bx, 1    ; Move to the next character in the string
    jmp start    ; Repeat the loop

done:
    popa
    ret

; Function to print a hexadecimal number stored in DX
print_hex:
    pusha
    mov cx, 0 ; Initialize our index variable

hex_loop:
    cmp cx, 4 ; Loop 4 times (to print 4 digits in hexadecimal)
    je end

    mov ax, dx     ; Copy the value from DX into AX
    and ax, 0x000f ; Extract the lowest 4 bits (hexadecimal digit)
    add al, 0x30   ; Convert the hexadecimal digit to ASCII
    cmp al, 0x39   ; Check if the digit is greater than 9
    jle step2
    add al, 7      ; If yes, adjust the ASCII value

step2:
    mov bx, HEX_OUT + 5 ; Calculate the position in the HEX_OUT buffer for the current digit
    sub bx, cx          ; Since we print the number in reverse, we subtract the index from 5
    mov [bx], al        ; Store the ASCII digit in the HEX_OUT buffer
    ror dx, 4           ; Shift the value in DX to the right by 4 bits

    add cx, 1   ; Increment the index variable
    jmp hex_loop ; Repeat the loop

end:
    mov bx, HEX_OUT
    call print  ; Print the hexadecimal number stored in HEX_OUT

    popa
    ret

HEX_OUT:
    db '0x0000', 0 ; Reserve memory for our new string (initialized with "0x0000")
