'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const { parseDuration } = require('./implementation.cjs');

const UNITS = [
  ['ms', 1n],
  ['s', 1000n],
  ['m', 60000n],
  ['h', 3600000n],
];

function assertDuration(input, expected) {
  const actual = parseDuration(input);
  assert.equal(typeof actual, 'number', `${input}: primitive number required`);
  assert.equal(actual, expected, `${input}: incorrect milliseconds`);
  assert.equal(Number.isSafeInteger(actual), true, `${input}: safe integer required`);
}

test('zero is valid for every unit', () => {
  for (const [unit] of UNITS) assertDuration(`0${unit}`, 0);
});

test('milliseconds preserve the integer magnitude', () => {
  for (const value of [1, 17, 250, 1001]) assertDuration(`${value}ms`, value);
});

test('seconds convert to milliseconds', () => {
  assertDuration('1s', 1000);
  assertDuration('23s', 23000);
});

test('minutes convert to milliseconds', () => {
  assertDuration('1m', 60000);
  assertDuration('12m', 720000);
});

test('hours convert to milliseconds', () => {
  assertDuration('1h', 3600000);
  assertDuration('7h', 25200000);
});

test('results are primitive numbers for every unit', () => {
  for (const [unit] of UNITS) {
    assert.equal(typeof parseDuration(`1${unit}`), 'number', unit);
  }
});

test('missing parts and unsupported units are syntax errors', () => {
  for (const input of ['', '1', 'ms', 's', '1d', '1sec', '1ss', '1msx', '1s2m']) {
    assert.throws(() => parseDuration(input), SyntaxError, JSON.stringify(input));
  }
});

test('signs fractions exponents and leading zeros are syntax errors', () => {
  for (const input of ['+1s', '-1s', '-0s', '1.5s', '.5s', '1e3s', '01s', '00ms', '0x10s']) {
    assert.throws(() => parseDuration(input), SyntaxError, input);
  }
});

test('whitespace case changes and non-ASCII digits are syntax errors', () => {
  for (const input of [' 1s', '1s ', '1 s', '\t1s', '1s\n', '1s\r\n', '1s\u2028', '1S', '1MS', '１s', '1s\0']) {
    assert.throws(() => parseDuration(input), SyntaxError, JSON.stringify(input));
  }
});

test('non-string inputs are rejected without coercion', () => {
  const coercionTrap = {
    toString() { assert.fail('Must not coerce object input'); },
  };
  for (const input of [undefined, null, 1, 0, NaN, Infinity, true, 1n, Symbol('s'), ['1s'], {}, new String('1s'), coercionTrap]) {
    assert.throws(() => parseDuration(input), TypeError);
  }
});

test('largest safe magnitude for every unit is exact', () => {
  const maximum = BigInt(Number.MAX_SAFE_INTEGER);
  for (const [unit, multiplier] of UNITS) {
    const magnitude = maximum / multiplier;
    assertDuration(`${magnitude}${unit}`, Number(magnitude * multiplier));
  }
});

test('safe-integer overflow is rejected for every unit', () => {
  const maximum = BigInt(Number.MAX_SAFE_INTEGER);
  for (const [unit, multiplier] of UNITS) {
    const input = `${maximum / multiplier + 1n}${unit}`;
    assert.throws(() => parseDuration(input), RangeError, input);
    assert.throws(() => parseDuration(`${'9'.repeat(80)}${unit}`), RangeError);
  }
});
