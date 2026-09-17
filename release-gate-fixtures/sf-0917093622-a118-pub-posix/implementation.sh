#!/bin/sh
LC_ALL=C
export LC_ALL
# Integer conversion without arithmetic on unbounded caller input.
invalid() { printf '%s\n' 'invalid duration' >&2; exit 2; }
out_of_range() { printf '%s\n' 'duration out of range' >&2; exit 3; }

[ "$#" -eq 1 ] || invalid
case "$1" in
    *ms) amount=${1%ms}; multiplier=10 ;;
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

# Each comparison operand itself fits signed 32-bit arithmetic.
[ "${#amount}" -le 10 ] || out_of_range
if [ "${#amount}" -eq 10 ]; then
    first_nine=${amount%?}
    last_digit=${amount#?????????}
    [ "$first_nine" -le 214748364 ] || out_of_range
    if [ "$first_nine" -eq 214748364 ] && [ "$last_digit" -gt 7 ]; then
        out_of_range
    fi
fi
limit=$((2147483647 / multiplier))
[ "$amount" -le "$limit" ] || out_of_range
printf '%s\n' "$((amount * multiplier))"
