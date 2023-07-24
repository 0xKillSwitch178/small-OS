; Function to read sectors from the disk into the memory buffer pointed by ES:BX
disk_load:
    pusha

    ; AH = 02 - BIOS disk read function
    ; AL = number of sectors to read (1-128 dec.)
    ; CH = track/cylinder number (0-1023 dec., see below)
    ; CL = sector number (1-17 dec.)
    ; DH = head number (0-15 dec.)
    ; DL = drive number (0=A:, 1=2nd floppy, 80h=drive 0, 81h=drive 1)
    ; ES:BX = pointer to buffer

    ; Save DX to avoid losing its value in the process
    push dx

    mov ah, 0x02 ; BIOS disk read function
    mov al, dh   ; Number of sectors to read
    mov cl, 0x02 ; Sector number (start from 2)
    mov dh, 0x00 ; Head number (start from 0)

    int 0x13     ; BIOS interrupt for disk read

    jc disk_error ; If carry flag (CF) is set, an error occurred

    pop dx       ; Restore the original value of DX
    cmp al, dh   ; Check if the number of sectors read matches the requested count
    jne sectors_error

    popa
    ret

disk_error:
    ; Print "Disk read error" message
    mov bx, DISK_ERROR
    call print
    call print_nl

    ; Print the error code in hexadecimal
    mov dh, ah ; Move the error code to DH for printing
    call print_hex
    jmp disk_loop ; Jump to the infinite loop (disk_loop)

sectors_error:
    ; Print "Incorrect number of sectors read" message
    mov bx, SECTORS_ERROR
    call print

disk_loop:
    jmp $ ; Infinite loop to keep the program running

DISK_ERROR:      db "Disk read error", 0
SECTORS_ERROR:   db "Incorrect number of sectors read", 0
