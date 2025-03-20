try:
    from jedi.utils import setup_readline
except ImportError:
    # Fallback to the stdlib readline completer if it is installed
    # Taken from http://docs.python.org/2/library/rlcompleter.html
    print("Jedi is not installed, falling back to readline")
    try:
        import readline
        import rlcompleter
    except ImportError:
        print("Readline is not installed either. No tab completion is enabled.")
else:
    setup_readline()


def shift_color(col_string: str, delta: int) -> str:
    def shift(x: str) -> str:
        result = int(x, 16) + delta
        if result > 255:
            return "0xff"
        if result < 0:
            return "0x00"
        if result < 16:
            return "0x0{}".format(hex(result)[2:])
        return hex(result)

    if col_string[0:2] == "0x":
        col_string = col_string[2:]
    elif col_string[0] == "#":
        col_string = col_string[1:]
    red = col_string[0:2]
    green = col_string[2:4]
    blue = col_string[4:6]
    red_shift = shift(red)[2:]
    green_shift = shift(green)[2:]
    blue_shift = shift(blue)[2:]
    return "0x{}{}{}".format(red_shift, green_shift, blue_shift)
