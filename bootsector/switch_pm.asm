[bits 16]

switch_to_pm:
    cli             ; Disable interrupts to prevent any unexpected interrupts during the transition
    lgdt [gdt_descriptor] ; Load the Global Descriptor Table (GDT) by loading the address of the GDT descriptor
                        ; into the GDTR (Global Descriptor Table Register)

    mov eax, cr0    ; Load the value of Control Register 0 (CR0) into the EAX register
    or eax, 0x1     ; Set the first bit of CR0 (PE - Protection Enable) to 1, enabling protected mode
    mov cr0, eax    ; Store the updated value back into CR0, switching to protected mode

    jmp CODE_SEG:init_pm ; Use a far jump to jump to the code segment (CODE_SEG) in 32-bit protected mode
                        ; This far jump will flush the pipeline and continue execution in protected mode

[bits 32]       ; Now we are in 32-bit protected mode

init_pm:
    mov ax, DATA_SEG ; Load the value of the data segment descriptor (DATA_SEG) into AX
    mov ds, ax      ; Set the Data Segment (DS) register to point to the data segment defined in the GDT
    mov ss, ax      ; Set the Stack Segment (SS) register to point to the same data segment
    mov es, ax      ; Set the Extra Segment (ES) register to point to the same data segment
    mov fs, ax      ; Set the FS segment register to point to the same data segment
    mov gs, ax      ; Set the GS segment register to point to the same data segment

    mov ebp, 0x9000 ; Set up the base pointer (EBP) to 0x9000 for stack operations
    mov esp, ebp    ; Set the stack pointer (ESP) to the same value as the base pointer, initializing the stack

    call BEGIN_PM   ; Call the BEGIN_PM function to start execution in protected mode
