#!/usr/bin/python
import os
import re
import subprocess
import sys

KEY_SEQ_LENGTH = 25

CMD_COLOR = "#c4a280"
CMD_SPAN = "<span color='{}'>".format(CMD_COLOR)


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
            self.name = name.strip() + " "

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
            "<span color='#ffffff'>{}</span> <b><span color='#ffffff'>{}</span></b>".format(
                key_seq_buffered, self.name
            )
            + "<i>{}{} {}</span></i>".format(CMD_SPAN, self.dispatcher, self.params)
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
    ["rofi", "-dmenu", "-i", "-markup-rows", "-p", "Hyprland Keybinds:"],
    input="\n".join(str(x) for x in conf).encode("utf-8"),
    capture_output=True,
)

choice = cmd.stdout.decode("utf-8")
if not choice:
    sys.exit(0)
todo = re.search(CMD_SPAN + r"(.*)</span>", choice).group(1)  # type: ignore[union-attr]

if todo.split()[0] == "exec":
    print("eval", todo.split())
    subprocess.run(todo.split()[1:])
else:
    print("dispatch", todo.split())
    subprocess.run(["hyprctl", "dispatch"] + todo.split())
