#include "../drivers/ports.h"  // Include the header file that likely defines functions for I/O port operations

void main() {
    // Output a byte (14) to I/O port 0x3d
    io_port_byte_out(0x3d, 14);

    // Read a byte from I/O port 0x3d5, then shift it left by 8 bits
    int position = io_port_byte_in(0x3d5);
    position = position << 8;

    // Output a byte (15) to I/O port 0x3d4, then add the result of reading another byte from I/O port 0x3d5
    io_port_byte_out(0x3d4, 15);
    position += io_port_byte_in(0x3d5);

    // Calculate an offset value from the 'position' variable, each unit represents two bytes
    int offset_from_vga = position * 2;

    // Set up a pointer to the VGA memory region (address 0xb8000), treating it as a character (byte) array
    char* vga = (char*)0xb8000;

    // Write 'X' to the VGA memory at the calculated offset (character), and set the color attribute (0x0f, white on black)
    vga[offset_from_vga] = 'X';
    vga[offset_from_vga + 1] = 0x0f;
}
