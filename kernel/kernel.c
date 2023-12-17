#include "../cpu/isr.h"
#include "../cpu/types.h"
#include "../drivers/screen.h"
#include "kernel.h"
#include "../stdlib/strings.h"
#include "../stdlib/mem.h"

void kernel_main() {
    isr_init();
    irq_init();

    asm("int $2");
    asm("int $3");

    print("Type something, it will go through the kernel\n"
        "Type END to halt the CPU or PAGE to request a malloc()\n> ");
}

void user_input(char *input) {
    if (strcmp(input, "END") == 0) {
        print("Stopping the CPU. Bye!\n");
        asm volatile("hlt");
    } else if (strcmp(input, "PAGE") == 0) {
        /* Lesson 22: Code to test kmalloc, the rest is unchanged */
        u32 phys_addr;
        u32 page = malloc(1000, 1, &phys_addr);
        char page_str[16] = "";
        hex_to_ascii(page, page_str);
        char phys_str[16] = "";
        hex_to_ascii(phys_addr, phys_str);
        print("Page: ");
        print(page_str);
        print(", physical address: ");
        print(phys_str);
        print("\n");
    }
    print("You said: ");
    print(input);
    print("\n> ");
}
