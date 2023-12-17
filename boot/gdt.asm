; Bootloader - GDT setup for a flat model approach
; We will use a flat model approach by defining two segments: code and data.
; These segments will overlap each other, meaning there won't be any memory protection.
; We use this approach to simplify the operation, and later, we can add other segments using a high-level language like C.
; Each descriptor in the GDT (Global Descriptor Table) is 64 bits long and contains various information about the segment:
; base address (32 bits), size of segment (20 bits), privilege level (2 bits), read/write (1 bit), and more.
; We will define the segments using 'db' (define byte) and 'dd' (define doubleword) directives.

; GDT (Global Descriptor Table) definitions
gdt_start:
    ; The null descriptor, must be used to check for errors and raise interrupts
    gdt_null:
        dd 0x0     ; Segment size (bits 0-31) (Null descriptor has a size of 0)
        dd 0x0     ; Segment base address (bits 0-31) (Null descriptor has a base address of 0)

    ; The code segment descriptor
    gdt_code:
        dw 0xffff  ; Size of the segment (bits 0-15) (Segment size is set to 0xFFFF, 65535 bytes)
        dw 0x0     ; Base address of the segment (bits 16-31) (Code segment base address is set to 0x0000)
        db 0x0     ; Base address of the segment (bits 32-39) (Code segment base address is set to 0x00)
        db 10011010b ; Type flags: Bit 0 - present, Bit 1-2 - DPL, Bit 3 - S, Bit 4 - code, Bit 5 - conforming, Bit 6 - readable, Bit 7 - accessed
        db 11001111b ; Other flags: Bit 0 - granularity, Bit 1 - default operation, Bit 2- L, Bit 3 - AVL, Bit 4 - 7 - segment limit
        db 0x0     ; Base address of the segment (Code segment base address is set to 0x00)

    ; The data segment descriptor
    gdt_data:
        dw 0xffff  ; Size of the segment (bits 0-15) (Segment size is set to 0xFFFF, 65535 bytes)
        dw 0x0     ; Base address of the segment (bits 16-31) (Data segment base address is set to 0x0000)
        db 0x0     ; Base address of the segment (bits 32-39) (Data segment base address is set to 0x00)
        db 10010010b ; Type flags: Bit 0 - present, Bit 1-2 - DPL, Bit 3 - S, Bit 4 - code, Bit 5 - conforming, Bit 6 - readable, Bit 7 - accessed
        db 11001111b ; Other flags: Bit 0 - granularity, Bit 1 - default operation, Bit 2- L, Bit 3 - AVL, Bit 4 - 7 - segment limit
        db 0x0     ; Base address of the segment (Data segment base address is set to 0x00)

gdt_end:        ; The reason for putting a label at the end of the
                ; GDT is so we can have the assembler calculate
                ; the size of the GDT for the GDT descriptor (below)

; GDT descriptor
gdt_descriptor:
    dw gdt_end - gdt_start - 1   ; Size of our GDT, always one less than the true size
    dd gdt_start                 ; Start address of our GDT

; Define some handy constants for the GDT segment descriptor offsets, which
; are what segment registers must contain when in protected mode. For example,
; when we set DS = 0x10 in PM, the CPU knows that we mean it to use the
; segment described at offset 0x10 (i.e. 16 bytes) in our GDT, which in our
; case is the DATA segment (0x00 -> NULL; 0x08 -> CODE; 0x10 -> DATA)
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
