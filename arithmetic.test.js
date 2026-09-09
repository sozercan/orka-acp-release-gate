const test = require('node:test');
const assert = require('node:assert/strict');
const { add, subtract, divide } = require('./arithmetic');

test('addition', () => assert.equal(add(2, 3), 5));
test('subtraction', () => assert.equal(subtract(5, 3), 2));

test('divide - positive inputs', () => assert.equal(divide(10, 2), 5));
test('divide - one negative input', () => assert.equal(divide(-10, 2), -5));
test('divide - zero divisor throws RangeError', () => {
  assert.throws(() => divide(10, 0), RangeError);
});
