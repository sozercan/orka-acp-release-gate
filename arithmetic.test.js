const test = require('node:test');
const assert = require('node:assert/strict');
const { add, subtract, multiply } = require('./arithmetic');

test('addition', () => assert.equal(add(2, 3), 5));
test('subtraction', () => assert.equal(subtract(5, 3), 2));
test('multiply positive integers', () => assert.equal(multiply(4, 5), 20));
test('multiply with zero', () => assert.equal(multiply(7, 0), 0));
test('multiply with negative operand', () => assert.equal(multiply(3, -2), -6));
