#include "timer.h"
#include "../drivers/screen.h"
#include "../drivers/ports.h"
#include "../stdlib/unused_params.h"
#include "isr.h"

u32 tick = 0;

static void timer_callback(registers_t registers) {
    tick++;
    UNUSED(registers);
}

void init_timer(u32 freq) {
    register_interrupt_handler(IRQ0, timer_callback);

    /* Get the PIT value: hardware clock at 1193180 Hz */
    u32 divisor = 1193180 / freq;
    u8 low  = (u8)(divisor & 0xFF);
    u8 high = (u8)( (divisor >> 8) & 0xFF);
    /* Send the command */
    io_port_byte_out(0x43, 0x36); /* Command port */
    io_port_byte_out(0x40, low);
    io_port_byte_out(0x40, high);
}