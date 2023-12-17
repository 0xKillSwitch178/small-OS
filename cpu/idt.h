#ifndef IDT_H
#define IDT_H

#define KERNEL_CS 0x08
#define IDT_ENTRIES 256

#include "types.h"

/*
The IDT strcture is as followes:
offset     size       name                          description
0	    2 bytes	    Offset (low)	    Low 2 bytes of interrupt handler offset
2	    2 bytes	    Selector	        A code segment selector in the GDT
4	    1 byte	    Zero	            Zero - unused
5	    1 byte	    Type/attributes	    Type and attributes of the descriptor
6	    2 bytes	    Offset (high)	    High 2 bytes of interrupt handler offset

The type byte has the following strcture:
Bits	    Code	                                        Description
0..3	    Gate type	                            IDT gate type (see below)
4	        Storage segment	                        Must be set to 0 for interrupt gates.
5..6	    Descriptor privilege level	            Gate call protection. This defines the minimum privilege level the calling code must have. This way, user code may not be able to call some interrupts.
7	        Present	                                For unused interrupts, this is set to 0. Normally, it’s 1.

The IDT entries are called gates. It can contain Interrupt Gates, Task Gates and Trap Gates. 
    0b0101 or 0x5: Task Gate, note that in this case, the Offset value is unused and should be set to zero.
    0b0110 or 0x6: 16-bit Interrupt Gate
    0b0111 or 0x7: 16-bit Trap Gate
    0b1110 or 0xE: 32-bit Interrupt Gate
    0b1111 or 0xF: 32-bit Trap Gate 

    Task gates: used to switch privilige level.
    Interrupt Gate: used to handle hardware interrupts.
    Trap Gate: used to handle software exceptions.

The CPU will load our IDT with the lidt instruction.
In order to tell the CPU where our IDT is in memory, we need to define an IDT pointer.
Field	        Size	                                     Description
Size	        2 bytes	                    Number of bytes (not entries) in the interrupt descriptor table, NOT minus one
Offset	        4 bytes	                    Linear address of interrupt descriptor table
*/

typedef struct
{
    u16 lower_bytes_handler_function;
    u16 GDT_selector;
    u8 unused;
    u8 attributes;
    u16 upper_bytes_handler_function;
} __attribute__((packed)) idt_gate_t;


typedef struct 
{
    u16 size;
    u32 base_address;

} __attribute__((packed)) idt_register_t;

idt_gate_t idt[IDT_ENTRIES];
idt_register_t idt_register;

void set_idt_gate(int gate_index, u32 handler);
void set_idt();


#endif