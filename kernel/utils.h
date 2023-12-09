#define msize_t unsigned long
#define lower_16_bits(address) (u16)((address) & 0xFFFF)
#define upper_16_bits(address) (u16)(((address) >> 16) & 0xFFFF)
void memory_copy(char *src, char *dest, int length_bytes);
void int_to_ascii(int num, char str[]);