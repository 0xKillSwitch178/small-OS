#include "../drivers/screen.h"
#include "utils.h"
#include "../cpu/isr.h"
#include "../cpu/idt.h"

void main() {
    isr_init();
    /* Test the interrupts */
    __asm__ __volatile__("int $2");
    __asm__ __volatile__("int $3");
}