#!/usr/bin/env bash

# hex_comp.bash
#
# Display a hexadecimal colour representation next to the supplied colour in 256
# space. Assuming your terminal is able to display 24 bit colour.
#
# Licensed under CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/)
# https://unix.stackexchange.com/questions/269077/tput-setaf-color-table-how-to-determine-color-codes/269085#269085
#

hexcomp() {
    hex=${1#"#"}
    r=$(printf '0x%0.2s' "$hex")
    g=$(printf '0x%0.2s' ${hex#??})
    b=$(printf '0x%0.2s' ${hex#????})

    printf 'original \e[38;2;%d;%d;%dm██████\e[0m %s\n' "$r" "$g" "$b" "$1"
    printf ' compare \e[38;5;%sm██████\e[0m %s\n' "$2" "$2"
}

hexcomp "$1" "$2"
