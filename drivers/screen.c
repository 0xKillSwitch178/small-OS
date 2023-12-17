#include "screen.h"
#include "ports.h"
#include "../kernel/utils.h"

/* Declaration of private functions */
int get_cursor_offset();
void set_cursor_offset(int offset);
int print_char(char ch, int col, int row, int attr);
int get_offset(int col, int row);
int get_offset_row(int offset);
int get_offset_col(int offset);
int handle_scrolling(int offset);

/**********************************************************
 * Public Kernel API functions                            *
 **********************************************************/

/**
 * Print a message at the specified position on the screen
 * If col or row is negative, use the current cursor position
 * @param msg Message to be printed
 * @param col Column position (0-based)
 * @param row Row position (0-based)
 */
void print_at_position(char *msg, int col, int row) {
    int offset;
    if (col >= 0 && row >= 0)
        offset = get_offset(col, row);
    else {
        offset = get_cursor_offset();
        row = get_offset_row(offset);
        col = get_offset_col(offset);
    }

    int i = 0;
    while (msg[i] != 0) {
        offset = print_char(msg[i++], col, row, TEXT_COLOUR);
        row = get_offset_row(offset);
        col = get_offset_col(offset);
    }
}

/**
 * Print a message starting from the current cursor position
 * @param msg Message to be printed
 */
void print(char *msg) {
    print_at_position(msg, -1, -1);
}

/**********************************************************
 * Private kernel functions                               *
 **********************************************************/

/**
 * Get the current cursor offset
 * @return Current cursor offset (position in video memory)
 */
int get_cursor_offset() {
    // Output a byte (14) to I/O port 0x3d
    io_port_byte_out(REG_SCREEN_CTRL, 14);

    // Read a byte from I/O port 0x3d5, then shift it left by 8 bits
    int position = io_port_byte_in(REG_SCREEN_DATA);
    position = position << 8;

    // Output a byte (15) to I/O port 0x3d4, then add the result of reading another byte from I/O port 0x3d5
    io_port_byte_out(REG_SCREEN_CTRL, 15);
    position += io_port_byte_in(REG_SCREEN_DATA);

    // Calculate the offset value from the 'position' variable, each unit represents two bytes
    int offset = position * 2;
    return offset;
}

/**
 * Clear the entire screen by filling it with spaces and setting the cursor to (0, 0)
 */
void clear_screen() {
    int screen_size = MAX_COLS * MAX_ROWS;
    char *video_address = (char *)VGA_VIDEO_ADDRESS;

    for (int i = 0; i < screen_size; i++) {
        video_address[i * 2] = ' ';
        video_address[i * 2 + 1] = TEXT_COLOUR;
    }

    set_cursor_offset(get_offset(0, 0));
}

/**
 * Set the cursor offset to the specified position
 * @param offset Offset to set (position in video memory)
 */
void set_cursor_offset(int offset) {
    offset /= 2;
    io_port_byte_out(REG_SCREEN_CTRL, 14);
    io_port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset >> 8));
    io_port_byte_out(REG_SCREEN_CTRL, 15);
    io_port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset & 0xff));
}

/**
 * Print a character at the specified position on the screen
 * If col or row is negative, use the current cursor position
 * @param ch Character to be printed
 * @param col Column position (0-based)
 * @param row Row position (0-based)
 * @param attr Character attribute (e.g., color)
 * @return Offset of the next character
 */
int print_char(char ch, int col, int row, int attr) {
    unsigned char *video_address = (unsigned char *)VGA_VIDEO_ADDRESS;
    if (!attr)
        attr = TEXT_COLOUR;

    if (col >= MAX_COLS || row >= MAX_ROWS) {
        video_address[2 * (MAX_COLS) * (MAX_ROWS) - 2] = 'E';
        video_address[2 * (MAX_COLS) * (MAX_ROWS) - 1] = RED_ON_WHITE;
        return get_offset(col, row);
    }

    int offset;
    if (col >= 0 && row >= 0)
        offset = get_offset(col, row);
    else
        offset = get_cursor_offset();

    if (ch == '\n') {
        row = get_offset_row(offset);
        offset = get_offset(0, row + 1);
    } else {
        video_address[offset] = ch;
        video_address[offset + 1] = attr;
        offset += 2;
    }
    if (offset >= MAX_ROWS * MAX_COLS * 2) {
        offset = handle_scrolling(offset);
    }

    set_cursor_offset(offset);

    return offset;
}

/**
 * Get the linear memory offset for the specified (col, row) coordinate
 * @param col Column position (0-based)
 * @param row Row position (0-based)
 * @return Offset (position in video memory) for the given coordinate
 */
int get_offset(int col, int row) {
    return 2 * (row * MAX_COLS + col);
}

/**
 * Get the row index for the specified offset
 * @param offset Offset (position in video memory)
 * @return Row index (0-based) corresponding to the given offset
 */
int get_offset_row(int offset) {
    return offset / (2 * MAX_COLS);
}

/**
 * Get the column index for the specified offset
 * @param offset Offset (position in video memory)
 * @return Column index (0-based) corresponding to the given offset
 */
int get_offset_col(int offset) {
    return (offset - (get_offset_row(offset) * 2 * MAX_COLS)) / 2;
}

/**
 * Handle scrolling if the cursor exceeds the screen boundaries
 * @param offset Current cursor offset
 * @return New cursor offset after scrolling
 */
int handle_scrolling(int offset) {
    for (msize_t i = 0; i < MAX_ROWS; i++) {
        memory_copy(get_offset(0, i) + VGA_VIDEO_ADDRESS,
                    get_offset(0, i - 1) + VGA_VIDEO_ADDRESS,
                    MAX_COLS * 2);
    }

    char *last_line = get_offset(0, MAX_ROWS - 1) + VGA_VIDEO_ADDRESS;
    for (msize_t i = 0; i < MAX_COLS * 2; i++) {
        last_line[i] = 0;
    }
    offset -= 2 * MAX_COLS;
    return offset;
}
