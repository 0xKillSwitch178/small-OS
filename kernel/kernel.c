#include "../drivers/screen.h"// Include the header file that likely defines functions for I/O port operations

void main() {
    clear_screen();
    print_at_position("X", 1, 6);
    print_at_position("this text spans multiple lines", 75, 10);
    print_at_position("there is a line\n break", 0 , 20);
    print_at_position("what happens when we run out of space", 45, 24);
}
