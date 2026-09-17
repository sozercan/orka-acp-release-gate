#!/bin/sh
LC_ALL=C
export LC_ALL
# Integer conversion without arithmetic on unbounded caller input.
invalid() { printf '%s\n' 'invalid duration' >&2; exit 2; }
out_of_range() { printf '%s\n' 'duration out of range' >&2; exit 3; }

[ "$#" -eq 1 ] || invalid
case "$1" in
    *ms) amount=${1%ms}; multiplier=1 ;;
    *s) amount=${1%s}; multiplier=1000 ;;
    *m) amount=${1%m}; multiplier=60000 ;;
    *h) amount=${1%h}; multiplier=3600000 ;;
    *) invalid ;;
esac
case "$amount" in
    ''|*[!0-9]*) invalid ;;
    0) ;;
    0*) invalid ;;
esac

case "$multiplier" in
    1) limit=2147483647 ;;
    1000) limit=2147483 ;;
    60000) limit=35791 ;;
    3600000) limit=596 ;;
esac

# Compare as decimal strings to avoid any overflow during validation.
case "$amount" in
    *)
        if [ "${#amount}" -lt "${#limit}" ]; then
            :
        elif [ "${#amount}" -gt "${#limit}" ]; then
            out_of_range
        elif [ "$amount" -gt "$limit" ]; then
            out_of_range
        fi
        ;;
esac
printf '%s\n' "$((amount * multiplier))"
