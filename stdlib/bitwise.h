#define lower_16_bits(address) (u16)((address) & 0xFFFF)
#define upper_16_bits(address) (u16)(((address) >> 16) & 0xFFFF)