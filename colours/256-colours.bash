#!/usr/bin/env bash

# This program is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What The Fuck You Want
# To Public License, Version 2, as published by Sam Hocevar. See
# http://sam.zoy.org/wtfpl/COPYING for more details.

for colour in {0..15}; do
    # Display the colour
    printf "\e[48;5;%sm %3s \e[0m\e[38;5;%sm %3s \e[0m" $colour $colour $colour $colour
    # Display 8 colours per lines
    if [ $(((colour + 1) % 8)) == 0 ]; then
        echo
    fi
done
echo
for colour in {16..255}; do
    # Display the colour
    printf "\e[48;5;%sm %3s \e[0m\e[38;5;%sm %3s \e[0m" $colour $colour $colour $colour
    # Display 6 colours per lines
    if [ $((($colour + 1) % 6)) == 4 ]; then
        echo
    fi
done
echo

exit 0
