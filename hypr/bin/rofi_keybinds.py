#!/usr/bin/python
import os
import re
import subprocess
import sys

MODE = "rofi"
if len(sys.argv) > 1:
    MODE = sys.argv[1]

KEY_SEQ_LENGTH = 25

PICKER_CMD = []
if MODE == "rofi":
    PICKER_CMD = ["rofi", "-dmenu", "-i", "-markup-rows", "-p", "Hyprland Keybinds:"]
elif MODE == "fzy":
    PICKER_CMD = ["fzy", "-p", "Hyprland Keybinds:"]

CMD_SPAN = ""
KEY_SEQ_BEG = ""
KEY_SEQ_END = ""
NAME_BEG = ""
NAME_END = ""
CMD_BEG = ""
CMD_END = ""
if MODE == "rofi":
    CMD_COLOR = "#c4a280"
    CMD_SPAN = "<span color='{}'>".format(CMD_COLOR)
    KEY_SEQ_BEG = "<span color='#ffffff'>"
    KEY_SEQ_END = "</span>"
    NAME_BEG = "<b><span color='#ffffff'>"
    NAME_END = "</span></b>"
    CMD_BEG = "<i>{}".format(CMD_SPAN)
    CMD_END = "</span></i>"
elif MODE == "fzy":
    KEY_SEQ_BEG = ""
    KEY_SEQ_END = "[0m"
    NAME_BEG = "[3;35m"
    NAME_END = "[0m"
    CMD_BEG = "[38m"  # "[3;33m"
    CMD_END = "[0m"


class VarStatement:
    """Hyprland config variables, e.g.
    $terminal = kitty
    """

    def __init__(self, raw: str):
        match = re.match(r"^\s*\$(.*)\s*=\s*(.*)", raw)
        name, value = (x.strip() for x in match.groups())  # type: ignore[union-attr]
        self.name = name
        self.value = value.split("#")[0].strip()

    def __repr__(self) -> str:
        return "${} = {}".format(self.name, self.value)


class BindStatement:
    """Hyprland config key bind statements."""

    def __init__(self, raw: str):
        cmd = raw
        self.name = ""
        comment_split = re.search(r"^([^#]*)#(.*)$", raw)
        if comment_split:
            cmd, name = comment_split.groups()
            self.name = name.strip()

        cmd = re.sub(r"\s*bind[lroenmtisdp]*\s*=\s*", "", cmd).strip()

        self.params = ""
        try:
            mods, self.key, self.dispatcher, self.params = (
                x.strip() for x in cmd.split(",")
            )
        except ValueError:
            mods, self.key, self.dispatcher = (x.strip() for x in cmd.split(","))
        self.mods = tuple(k.strip() for k in mods.split())
        self.key_seq = (
            "{} + {}".format(" + ".join(self.mods), self.key) if mods else self.key
        )

    def __repr__(self) -> str:
        """How these will appear in rofi."""
        format_str = "{:<" + str(KEY_SEQ_LENGTH) + "}"
        key_seq_buffered = format_str.format(self.key_seq)
        result = (
            KEY_SEQ_BEG
            + key_seq_buffered
            + KEY_SEQ_END
            + " "
            + NAME_BEG
            + self.name
            + NAME_END
            + " "
            + CMD_BEG
            + self.dispatcher
            + " "
            + self.params
            + CMD_END
        )
        return result


def replace_vars(string: str, var_dict: dict[str, str]) -> str:
    result = string
    for var, val in var_dict.items():
        result = re.sub(var, val, result)
    return result


def vars_to_dict(variables: list[VarStatement]) -> dict[str, str]:
    return {r"\${}\b".format(var.name): var.value for var in variables}


HYPR_CONF = "{}/hyprland.test".format(os.environ["HOME"])
HYPR_CONF = "{}/.config/hypr/hyprland.conf".format(os.environ["HOME"])

conf = []
with open(HYPR_CONF, "r") as conf_file:
    conf_lines = conf_file.readlines()

vars = [VarStatement(x) for x in conf_lines if re.match(r"^\s*\$", x)]
var_dict = vars_to_dict(vars)

conf = [
    BindStatement(replace_vars(x.strip(), var_dict))
    for x in conf_lines
    if re.match(r"^\s*bind[lroenmtisdp]*\s*=\s*", x)
]

cmd = subprocess.run(
    PICKER_CMD,
    input="\n".join(str(x) for x in conf).encode("utf-8"),
    capture_output=True,
)

choice = cmd.stdout.decode("utf-8")
if not choice:
    sys.exit(0)
todo = re.search(
    CMD_BEG.replace("[", "\\[") + r"(.*)" + CMD_END.replace("[", "\\["), choice
).group(  # type: ignore[union-attr]
    1
)

if todo.split()[0] == "exec":
    subprocess.run(todo.split()[1:])
else:
    subprocess.run(["hyprctl", "dispatch"] + todo.split())
