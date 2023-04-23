#!/usr/bin/env zsh

# Author: Stéphane Gimenezk
# Available: https://unix.stackexchange.com/questions/20721/testing-ls-colors-in-zsh/20742#20742
# Licensed under CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/)
#
# With minor tweak so it doesn't constantly print newlines

typeset -A names
names[no]="global default"
names[fi]="normal file"
names[di]="directory"
names[ln]="symbolic link"
names[pi]="named pipe"
names[so]="socket"
names[do]="door"
names[bd]="block device"
names[cd]="character device"
names[or]="orphan symlink"
names[mi]="missing file"
names[su]="set uid"
names[sg]="set gid"
names[tw]="sticky other writable"
names[ow]="other writable"
names[st]="sticky"
names[ex]="executable"

color_prev=""
for i in ${(s.:.)LS_COLORS}
do
    key=${i%\=*}
    color=${i#*\=}
    name=${names[(e)$key]-$key}

    if [[ $color != $color_prev ]]; then
        color_prev=$color
        printf '\n'
    fi
    printf '\e[%sm%s\e[m ' $color $name
done

