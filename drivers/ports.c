// Read a byte from the specified I/O port
unsigned char io_port_byte_in(unsigned short port) {
    unsigned char result;
    __asm__("in %%dx, %%al" : "=a" (result) : "d" (port));
    return result;
}

// Write a byte to the specified I/O port
void io_port_byte_out(unsigned short port, unsigned char data) {
    __asm__("out %%al, %%dx" : :"a" (data), "d" (port));
}

// Read a word (16 bits) from the specified I/O port
unsigned short io_port_word_in(unsigned short port) {
    unsigned short result;
    __asm__("in %%dx, %%ax" : "=a" (result) : "d" (port));
    return result;
}

// Write a word (16 bits) to the specified I/O port
void io_port_word_out(unsigned short port, unsigned short data) {
    __asm__("out %%ax, %%dx" : :"a" (data), "d" (port));
}
