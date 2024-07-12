// Board and hardware specific configuration
#define MICROPY_HW_BOARD_NAME "Your Project Name Here"
#define MICROPY_HW_FLASH_STORAGE_BYTES (PICO_FLASH_SIZE_BYTES - (1 * 1024 * 1024))

// USB Serial REPL
#define MICROPY_HW_USB_CDC (1)
