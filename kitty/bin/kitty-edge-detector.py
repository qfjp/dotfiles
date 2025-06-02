#!/usr/bin/python
import json
import sys
from enum import Enum
from typing import TypedDict

direction = sys.argv[2]
amount = 0
try:
    amount = int(sys.argv[3])
except IndexError:
    amount = 5

neighbor = direction
axis = "horizontal"
if direction == "up":
    neighbor = "top"
    axis = "vertical"
elif direction == "down":
    neighbor = "bottom"
    axis = "vertical"


def sign(x: float | int) -> int:
    return -1 if x < 0 else 1 if x > 0 else 0


class LayoutNode(TypedDict):
    bias: float
    horizontal: bool
    one: "LayoutNode | int"
    two: "LayoutNode | int"


class Direction(Enum):
    TOP = 1
    BOTTOM = -1
    LEFT = 1j
    RIGHT = -1j

    @classmethod
    def _missing_(cls, value):  # type: ignore[no-untyped-def, misc]
        value = value.lower()
        for member in cls:
            if member.name.lower() == value:
                return member
        return None


# kitten_out = sp.run(
#    ["kitten", "@ls", "--match-tab", "state:focused"], capture_output=True)
kitten_out = sys.argv[1]

full_layout = json.loads(kitten_out)

active_tab = full_layout[0]["tabs"][0]

group_id_dict = {
    window: id_dict["id"]
    for id_dict in active_tab["groups"]
    for window in id_dict["windows"]
}

active_window_id = 0
for window in active_tab["windows"]:
    if window["is_active"]:
        active_window_id = window["id"]

layout = active_tab["layout_state"]["pairs"]

testing_name_dict = [{x["title"]: x["id"]} for x in active_tab["windows"]]


def tree_path(
    win_id: int, layout: LayoutNode, path: list[Direction]
) -> list[Direction]:
    group_id = group_id_dict[win_id]

    one = layout["one"]
    two = layout["two"]
    orient = layout["horizontal"]

    left = Direction.LEFT if orient else Direction.TOP
    right = Direction.RIGHT if orient else Direction.BOTTOM
    if isinstance(one, int):
        if group_id == one:
            return path + [left]
        if not isinstance(two, int):
            return tree_path(win_id, two, path + [right])
    if isinstance(two, int):
        if group_id == two:
            return path + [right]
        if not isinstance(one, int):
            return tree_path(win_id, one, path + [left])
    if not isinstance(one, int) and not isinstance(two, int):
        left_path = tree_path(win_id, one, path)
        if left_path:
            return [left] + left_path
        right_path = tree_path(win_id, two, path)
        if right_path:
            return [right] + right_path
        return path
    return []


def is_edge(win_id: int, dir: Direction) -> bool:
    path = tree_path(win_id, layout, [])
    summation = sum([x.value for x in path])
    if dir.value.real != 0:
        return sign(summation.real) == sign(dir.value.real)
    if dir.value.imag != 0:
        return sign(summation.imag) == sign(dir.value.imag)
    return False


#    R    L    T    B    C    -
print(is_edge(active_window_id, Direction(neighbor)))
