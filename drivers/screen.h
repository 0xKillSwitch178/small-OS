#define VGA_VIDEO_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80
#define TEXT_COLOUR 0x0f
#define RED_ON_WHITE 0xf4
#define REG_SCREEN_CTRL 0x3d4
#define REG_SCREEN_DATA 0x3d5

void clear_screen();
void print_at_position(char *msg, int col, int row);
void print(char *msg);