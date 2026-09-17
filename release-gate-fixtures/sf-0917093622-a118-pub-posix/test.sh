#!/bin/sh
LC_ALL=C
export LC_ALL
# Immutable original tests. Invoke the converter as a separate process.
set -u
PATH=/usr/bin:/bin
export PATH
hold=0
run_id=standalone
seen_hold=0
seen_id=0
for option do
    case "$option" in
        --hold=*)
            [ "$seen_hold" -eq 0 ] || exit 2
            seen_hold=1
            hold=${option#--hold=}
            case "$hold" in 0|5|10|20) ;; *) exit 2 ;; esac
            ;;
        --run-id=*)
            [ "$seen_id" -eq 0 ] || exit 2
            seen_id=1
            run_id=${option#--run-id=}
            case "$run_id" in ''|*[!A-Za-z0-9._-]*) exit 2 ;; esac
            [ "${#run_id}" -le 80 ] || exit 2
            ;;
        *) exit 2 ;;
    esac
done
case "$0" in */*) directory=${0%/*} ;; *) directory=. ;; esac
CDPATH= cd "$directory" || exit 2
umask 077
scratch=${TMPDIR:-/tmp}/soul-posix-tests.$$
mkdir "$scratch" || exit 2
trap 'rm -f "$scratch/out" "$scratch/err" "$scratch/expected-out" "$scratch/expected-err"; rmdir "$scratch"' 0
trap 'exit 130' HUP INT TERM

# Sentinels preserve expected trailing newlines. Compare actual files byte-for-
# byte: shell variables cannot represent NUL bytes, so never normalize actual output.
assert_output() {
    expected_status=$1
    expected_out=$2
    expected_err=$3
    shift 3
    /bin/sh ./implementation.sh "$@" >"$scratch/out" 2>"$scratch/err"
    actual_status=$?
    [ "$actual_status" -eq "$expected_status" ] || return 1
    printf '.' >>"$scratch/out"
    printf '.' >>"$scratch/err"
    printf '%s' "$expected_out" >"$scratch/expected-out"
    printf '%s' "$expected_err" >"$scratch/expected-err"
    cmp -s "$scratch/out" "$scratch/expected-out" &&
        cmp -s "$scratch/err" "$scratch/expected-err"
}
ok_value() { assert_output 0 "$(printf '%s\n.' "$2")" . "$1"; }
invalid_value() { assert_output 2 . "$(printf 'invalid duration\n.')" "$@"; }
overflow_value() { assert_output 3 . "$(printf 'duration out of range\n.')" "$1"; }

zero_units() {
    for unit in ms s m h; do ok_value "0$unit" 0 || return 1; done
}
milliseconds() {
    for value in 1 17 250 1001; do ok_value "${value}ms" "$value" || return 1; done
}
seconds() { ok_value 1s 1000 && ok_value 23s 23000; }
minutes() { ok_value 1m 60000 && ok_value 12m 720000; }
hours() { ok_value 1h 3600000 && ok_value 3h 10800000; }
argument_count() { invalid_value && invalid_value 1s 2s; }
missing_parts() {
    for input in '' 1 ms s 1d 1sec 1ss 1msx 1s2m; do
        invalid_value "$input" || return 1
    done
}
invalid_numbers() {
    for input in +1s -1s -0s 1.5s .5s 1e3s 01s 00ms 0x10s; do
        invalid_value "$input" || return 1
    done
}
whitespace_and_case() {
    for input in ' 1s' '1s ' '1 s' "$(printf '\t1s')" '1S' '1MS' '１s' '1s
'; do
        invalid_value "$input" || return 1
    done
}
maximum_values() {
    ok_value 2147483647ms 2147483647 &&
        ok_value 2147483s 2147483000 &&
        ok_value 35791m 2147460000 &&
        ok_value 596h 2145600000
}
overflows() {
    for input in 2147483648ms 2147484s 35792m 597h; do
        overflow_value "$input" || return 1
    done
}
huge_values() {
    for input in 21474836470ms 999999999999999999999s 999999999999999999999m 999999999999999999999h; do
        overflow_value "$input" || return 1
    done
}

passed=0
failed=0
number=0
run_test() {
    number=$((number + 1))
    title=$1
    shift
    if "$@"; then
        passed=$((passed + 1))
        printf 'ok %s - %s\n' "$number" "$title"
    else
        failed=$((failed + 1))
        printf 'not ok %s - %s\n' "$number" "$title"
    fi
}
printf 'SOUL_TEST_BEGIN run=%s pid=%s\n' "$run_id" "$$"
run_test 'zero in every unit' zero_units
run_test 'milliseconds preserve magnitude' milliseconds
run_test 'seconds convert exactly' seconds
run_test 'minutes convert exactly' minutes
run_test 'hours convert exactly' hours
run_test 'exactly one argument required' argument_count
run_test 'missing parts and unknown units rejected' missing_parts
run_test 'invalid numeric syntax rejected' invalid_numbers
run_test 'whitespace case and non-ASCII digits rejected' whitespace_and_case
run_test 'largest in-range values accepted' maximum_values
run_test 'unit-specific overflow rejected' overflows
run_test 'huge integers rejected before arithmetic' huge_values
printf 'SOUL_TEST_RESULT run=%s pid=%s total=%s passed=%s failed=%s\n' \
    "$run_id" "$$" "$number" "$passed" "$failed"
[ "$failed" -eq 0 ] || exit 1
# This is the only sleep: observing this direct child witnesses the post-check
# path, not merely a model-supplied PID or a printed success marker.
if [ "$hold" -gt 0 ]; then
    printf 'SOUL_TEST_HOLD run=%s pid=%s seconds=%s\n' "$run_id" "$$" "$hold"
    sleep "$hold"
fi
printf 'SOUL_TEST_END run=%s pid=%s\n' "$run_id" "$$"
exit 0
