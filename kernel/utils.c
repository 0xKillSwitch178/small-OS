#include "utils.h"

/**
 * Copy memory from source to destination.
 *
 * @param src Pointer to the source memory.
 * @param dest Pointer to the destination memory.
 * @param length_bytes Number of bytes to copy.
 */
void memory_copy(char *src, char *dest, int length_bytes) {
    for (msize_t i = 0; i < length_bytes; i++) {
        *(dest + i) = *(src + i);
    }
}

/**
 * Reverse the characters in a string.
 *
 * @param str The string to be reversed.
 */
void reverse_string(char str[]) {
    int start = 0;
    int end = 0;

    // Find the end of the string
    while (str[end] != '\0') {
        end++;
    }
    end--;

    // Swap characters to reverse the string
    while (start < end) {
        char temp = str[start];
        str[start] = str[end];
        str[end] = temp;
        start++;
        end--;
    }
}

/**
 * Convert an integer to its ASCII representation.
 *
 * This function takes an integer and converts it to its ASCII representation
 * as a null-terminated string.
 *
 * @param num The integer to be converted.
 * @param str The character array to store the ASCII representation.
 */
void int_to_ascii(int num, char str[]) {
    int i, sign;

    // Handle the sign of the number
    if ((sign = num) < 0) {
        num = -num;
    }

    i = 0;

    // Convert each digit to ASCII and store in the string
    do {
        str[i++] = num % 10 + '0';
    } while ((num /= 10) > 0);

    // Add a minus sign if the original number was negative
    if (sign < 0) {
        str[i++] = '-';
    }

    // Null-terminate the string
    str[i] = '\0';

    // Reverse the string to get the correct order of digits
    reverse_string(str);
}
