# cmake file for Your Project Name Here

set(PICO_BOARD "your_project_name_here")

# Taken from https://github.com/micropython/micropython/blob/master/ports/rp2/boards/WEACTSTUDIO/mpconfigboard.cmake
# (thanks to user @matt_trentini from the Micropython discord )
list(APPEND PICO_BOARD_HEADER_DIRS ${MICROPY_BOARD_DIR})