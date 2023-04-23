#!/usr/bin/env bash
#
# based off a pattern seen here
# https://github.com/Phantas0s/.dotfiles
# https://github.com/Phantas0s/.dotfiles/blob/master/bash/scripts/colorblocks.sh
#

d=$'\e[0m'
# top
printf '\n'
for line in {0..2}; do
    for ii in {0..7}; do
        printf ' %b██████%b██%b' "\e[3${ii}m" "\e[9${ii}m" "$d"
    done
    printf '\n'
done

# bottom bar
for ii in {0..7}; do
    printf ' %b██████%b██%b' "$d" "\e[37m" "$d"
done
printf '\n\n'

