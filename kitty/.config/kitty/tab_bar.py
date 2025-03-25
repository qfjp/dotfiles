from typing import Any

#          


class SupSub:

    def __init__(self, data: dict[str, Any], is_subscript: bool = False):
        self.__data = data
        self.__is_subscript = is_subscript

    def __getattr__(self, name: str) -> str:
        name = str(self.__data.get(name, name))
        table = super_sub_maps()[int(self.__is_subscript)]
        return name.translate(table)


def draw_attributed_string(title: str, screen: "Screen") -> None:
    if "\x1b" in title:
        for x in sgr_sanitizer_pat(for_splitting=True).split(title):
            if x.startswith("\x1b") and x.endswith("m"):
                screen.apply_sgr(x[2:-1])
            else:
                screen.draw(x)
    else:
        screen.draw(title)


def draw_title(
    draw_data: "DrawData",
    screen: "Screen",
    tab: "TabBarData",
    index: int,
    max_title_length: int = 0,
) -> None:
    data = {
        "index": index,
        "layout_name": tab.layout_name,
        "num_windows": tab.num_windows,
        "num_window_groups": tab.num_window_groups,
        "title": tab.title,
    }
    if draw_data.max_tab_title_length > 0:
        max_title_length = min(max_title_length,
                               draw_data.max_tab_title_length)
    eval_locals = {
        "index":
        index,
        "layout_name":
        tab.layout_name,
        "num_windows":
        tab.num_windows,
        "num_window_groups":
        tab.num_window_groups,
        "title":
        tab.title,
        "fmt":
        "Formatter",
        "sup":
        SupSub(data),
        "sub":
        SupSub(data, True),
        "bell_symbol":
        draw_data.bell_on_tab if tab.needs_attention else "",
        "activity_symbol": (draw_data.tab_activity_symbol
                            if tab.has_activity_since_last_focus else ""),
        "max_title_length":
        max_title_length,
        "keyboard_mode":
        None,  # boss.mappings.current_keyboard_mode_name,
    }
    template = draw_data.title_template
    if tab.is_active and draw_data.active_title_template is not None:
        template = draw_data.active_title_template
    prefix = ""
    if eval_locals["bell_symbol"] and not template_has_field(
            template, "bell_symbol"):
        prefix = "{bell_symbol}"
    if eval_locals["activity_symbol"] and not template_has_field(
            template, "activity_symbol"):
        prefix += "{activity_symbol}"
    if prefix:
        template = "{fmt.fg.red}" + prefix + "{fmt.fg.tab}" + template
    try:
        title = eval(compile_template(template),
                     {"__builtins__": safe_builtins}, eval_locals)
    except Exception as e:
        title = tab.title
    before_draw = screen.cursor.x
    draw_attributed_string(title, screen)
    if draw_data.max_tab_title_length > 0:
        x_limit = before_draw + draw_data.max_tab_title_length
        if screen.cursor.x > x_limit:
            screen.cursor.x = x_limit - 1
            screen.draw("…")


def as_rgb(x: int) -> int:
    return (x << 8) | 2


powerline_symbols: dict[str, tuple[str, str]] = {
    "slanted": ("", "╱"),
    "round": ("", ""),
}


def draw_tab(
    draw_data: "DrawData",
    screen: "Screen",
    tab: "TabBarData",
    before: int,
    max_tab_length: int,
    index: int,
    is_last: bool,
    extra_data: "ExtraData",
) -> int:
    tab_bg = screen.cursor.bg
    tab_fg = screen.cursor.fg
    default_bg = as_rgb(int(draw_data.default_bg))
    if extra_data.next_tab:
        next_tab_bg = as_rgb(draw_data.tab_bg(extra_data.next_tab))
        needs_soft_separator = next_tab_bg == tab_bg
    else:
        next_tab_bg = default_bg
        needs_soft_separator = False

    separator_symbol, soft_separator_symbol = powerline_symbols["round"]

    # separator_symbol, soft_separator_symbol = powerline_symbols.get(
    #    draw_data.powerline_style, ("", "")
    # )
    min_title_length = 1 + 2
    start_draw = 2

    if screen.cursor.x == 0:
        screen.cursor.bg = tab_bg
        screen.draw(" ")
        start_draw = 1

    screen.cursor.bg = tab_bg
    if min_title_length >= max_tab_length:
        screen.draw("…")
    else:
        draw_title(draw_data, screen, tab, index, max_tab_length)
        extra = screen.cursor.x + start_draw - before - max_tab_length
        if extra > 0 and extra + 1 < screen.cursor.x:
            screen.cursor.x -= extra + 1
            screen.draw("…")

    if not needs_soft_separator:
        screen.draw(" ")
        screen.cursor.fg = tab_bg
        screen.cursor.bg = next_tab_bg
        screen.draw(separator_symbol)
    else:
        prev_fg = screen.cursor.fg
        if tab_bg == tab_fg:
            screen.cursor.fg = default_bg
        elif tab_bg != default_bg:
            c1 = draw_data.inactive_bg.contrast(draw_data.default_bg)
            c2 = draw_data.inactive_bg.contrast(draw_data.inactive_fg)
            if c1 < c2:
                screen.cursor.fg = default_bg
        screen.draw(f" {soft_separator_symbol}")
        screen.cursor.fg = prev_fg

    end = screen.cursor.x
    if end < screen.columns:
        screen.draw(" ")
    return end
