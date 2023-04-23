#!/usr/bin/env dash

# options inspired by: https://stackoverflow.com/a/74165488
# strict mode from: http://redsymbol.net/articles/unofficial-bash-strict-mode/

# strict mode
set -eu

printUsage() {
    # 80 cols
    #--------1---------2---------3---------4---------5---------6---------7---------8
    sed 's/^    //' << usage
    Usage: $(basename "$0") [OPTION...] [ARG...]
    Template script to demonstrate argument parsing. Displays selected options and
    positional ARG(s).

        -a, --a-long            option a
        -b, --b-long REQ        option b, required argument REQ
        -c, --c-long [OPT]      option c, optional argument OPT

        -h, --help              display this help text
usage
}

# Formatted status output, cos... why not?
error() {
    echo "\e[31mError\e[0m $1" >&2
}

warning() {
    echo "\e[33mWarning\e[0m $1" >&2
}

info() {
    echo "\e[36mInfo\e[0m $1" >&2
}

## main
# declare variables
opt_a=false
opt_b=""
opt_c=""
pargs=""

# evaluate input
set +u # temporarily disable unbound error for custom error messages
while [ "$#" -ge 1 ]; do
    case "$1" in
        -a|--a-long)
            shift
            opt_a=true
            ;;
        -b|--b-long)
            shift
            if [ -z "$1" -o "${1:0:1}" = "-" ]; then
                error "missing argument: -b"
                printUsage
                exit 1
            fi
            opt_b="$1"
            shift
            ;;
        -c|--c-long)
            shift
            if [ -z "$1" -o "${1:0:1}" = "-" ]; then
                opt_c="default_c"
                continue
            fi
            opt_c="$1"
            shift
            ;;
        -h|--help)
            printUsage
            exit 0
            ;;
        *)
            pargs="$pargs$1"$'\t'
            shift
            ;;
        -*)
            error "Unknown option: $1"
            printUsage
            exit 1
            ;;
    esac
done
set -u

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

if [ -n "$opt_c" ]; then
    echo "Option \"c\": \"$opt_c\""
else
    echo "Option \"c\": not supplied"
fi

if [ -z "$pargs" ]; then
    echo "No positional arguments given"
else
    echo "positional arguments:"
    idx=0
    IFS=$'\t'
    for parg in $pargs; do
        echo "   ${idx}: [${parg}]"
        idx=$((idx + 1))
    done
fi
