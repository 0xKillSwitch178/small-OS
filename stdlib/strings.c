#include "strings.h"
#include "../cpu/types.h"


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


/*
Needs to upgrade them to the n version.
*/

int strlen(char str[]) {
    int i = 0;
    while (str[i] != '\0') ++i;
    return i;
}

void append(char str[], char n) {
    int len = strlen(str);
    str[len] = n;
    str[len+1] = '\0';
}

void backspace(char str[]) {
    int len = strlen(str);
    str[len-1] = '\0';
}

/* K&R 
 * Returns <0 if s1<s2, 0 if s1==s2, >0 if s1>s2 */
int strcmp(char s1[], char s2[]) {
    int i;
    for (i = 0; s1[i] == s2[i]; i++) {
        if (s1[i] == '\0') return 0;
    }
    return s1[i] - s2[i];
}


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

void hex_to_ascii(int n, char str[]) {
    append(str, '0');
    append(str, 'x');
    char zeros = 0;

    u32 tmp;
    int i;
    for (i = 28; i > 0; i -= 4) {
        tmp = (n >> i) & 0xF;
        if (tmp == 0 && zeros == 0) continue;
        zeros = 1;
        if (tmp > 0xA) append(str, tmp - 0xA + 'a');
        else append(str, tmp + '0');
    }

    tmp = n & 0xF;
    if (tmp >= 0xA) append(str, tmp - 0xA + 'a');
    else append(str, tmp + '0');
}
