const test = require('node:test');
const assert = require('node:assert/strict');
const { add, subtract, square } = require('./arithmetic');

test('addition', () => assert.equal(add(2, 3), 5));
test('subtraction', () => assert.equal(subtract(5, 3), 2));
test('square positive values', () => assert.equal(square(4), 16));
test('square zero', () => assert.equal(square(0), 0));
test('square negative values', () => assert.equal(square(-3), 9));
