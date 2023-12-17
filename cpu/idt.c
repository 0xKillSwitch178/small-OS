#include "idt.h"
#include "../kernel/utils.h"

void set_idt_gate(int gate_index, u32 handler){
    idt[gate_index].lower_bytes_handler_function = lower_16_bits(handler);
    idt[gate_index].GDT_selector = KERNEL_CS;
    idt[gate_index].unused = 0;
    idt[gate_index].attributes = 0x8E;
    idt[gate_index].upper_bytes_handler_function = upper_16_bits(handler);
}


void set_idt(){
    idt_register.size =  IDT_ENTRIES * sizeof(idt_gate_t) - 1; //maybe wrong
    idt_register.base_address = (u32) &idt;

    __asm__ __volatile__("lidtl (%0)" : : "r" (&idt_register));
}