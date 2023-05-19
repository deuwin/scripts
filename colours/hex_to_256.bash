#!/usr/bin/env bash

# hex_to_256.bash
#
# Converts a hexadecimal colour representation to the closest colour in the 256
# colour space. The displayed output of each representation os displayed next to
# each other, assuming your terminal is able to display 24 bit colour.
#
# Licensed under CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/)
# https://unix.stackexchange.com/questions/269077/tput-setaf-color-table-how-to-determine-color-codes/269085#269085
#

fromhex() {
    hex=${1#"#"}
    r=$(printf '0x%0.2s' "$hex")
    g=$(printf '0x%0.2s' ${hex#??})
    b=$(printf '0x%0.2s' ${hex#????})

    code=$(printf '%03d' "$(( (r<75?0:(r-35)/40)*6*6 +
                              (g<75?0:(g-35)/40)*6   +
                              (b<75?0:(b-35)/40)     + 16 ))")

    printf 'original \e[48;2;%d;%d;%dm      \e[0m %s\n' "$r" "$g" "$b" "$1"
    printf ' closest \e[48;5;%sm      \e[0m %s\n' "$code" "$code"
}

fromhex "$1"
