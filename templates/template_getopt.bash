#!/usr/bin/env bash

# unofficial strict mode
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

printUsage() {
    # 80 cols
    #--------1---------2---------3---------4---------5---------6---------7---------8
    sed 's/^    //' <<<\
    "Usage: $(basename $0) [OPTION...] [ARG...]
    Template script to demonstrate argument parsing. Displays selected options and
    positional ARG(s).

        -a,         option a
        -bREQ       option b, required argument REQ

        -h          display this help text"
}

# Formatted status output, cos... why not?
error() {
    echo -e "\e[31mError\e[0m $1" >&2
}

warning() {
    echo -e "\e[33mWarning\e[0m $1" >&2
}

info() {
    echo -e "\e[36mInfo\e[0m $1" >&2
}

## main
# set defaults
opt_a=false
opt_b=""

parg_1=""
parg_2=""

# evaluate input
while getopts ":ab:h" opt; do
    case "$opt" in
        a)
            opt_a=true
            ;;
        b)
            opt_b=${OPTARG}
            ;;
        h)
            printUsage
            exit 0
            ;;
        :)
            error "missing argument: -$OPTARG"
            printUsage
            exit 1
            ;;
        \?)
            error "Unknown option: -$OPTARG"
            printUsage
            exit 1
            ;;
    esac
done

# main
if $opt_a; then
    echo "Option \"a\": enabled"
else
    echo "Option \"a\": disabled"
fi

if [ -n "$opt_b" ]; then
    echo "Option \"b\": \"$opt_b\""
else
    echo "Option \"b\": not supplied"
fi

echo "Optional args:"
for opt_arg in "$@"; do
    echo "    $opt_arg"
done
