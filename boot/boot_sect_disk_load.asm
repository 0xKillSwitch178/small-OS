disk_load:
    pusha
    ; This comment is from: https://stanislavs.org/helppc/int_13-2.html
    ; AH = 02
    ; AL = number of sectors to read (1-128 dec.)
    ; CH = track/cylinder number (0-1023 dec., see below)
    ; CL = sector number (1-17 dec.)
    ; DH = head number (0-15 dec.)
    ; DL = drive number (0=A:, 1=2nd floppy, 80h=drive 0, 81h=drive 1)
    ; ES:BX = pointer to buffer

    ; On return:
    ; AH = status (see INT 13,STATUS)
    ; AL = number of sectors read
    ; CF = 0 if successful
    ;      = 1 if error

    ; - BIOS disk reads should be retried at least three times, and the
    ;   controller should be reset upon error detection
    ; - Be sure ES:BX does not cross a 64K segment boundary, or a
    ;   DMA boundary error will occur
    ; - Many programming references list only floppy disk register values
    ; - Only the disk number is checked for validity
    ; - The parameters in CX change depending on the number of cylinders;
    ;   the track/cylinder number is a 10-bit value taken from the 2 high
    ;   order bits of CL and the 8 bits in CH (low order 8 bits of track):

    ; |F|E|D|C|B|A|9|8|7|6|5-0|  CX
    ; | | | | | | | | | |      `----- sector number
    ; | | | | | | | | `--------- high order 2 bits of track/cylinder
    ; `------------------------  low order 8 bits of track/cyl number

    push dx
    mov ah, 0x02
    mov al, dh
    mov cl, 0x02
    mov dh, 0x00

    int 0x13 ; BIOS interrupt
    jc disk_error

    pop dx
    cmp al, dh
    jne sectors_error
    popa
    ret

disk_error:
    mov bx, DISK_ERROR
    call print_string
    call print_nl
    mov dh, ah ; Error code view https://stanislavs.org/helppc/int_13-1.html for specification
    call print_hex
    jmp disk_loop

sectors_error:
    mov bx, SECTORS_ERROR
    call print_string

disk_loop:
    jmp $ 

DISK_ERROR: db "Disk read error", 0
SECTORS_ERROR: db "Incorrect number of sectors read", 0
