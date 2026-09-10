const test = require('node:test');
const assert = require('node:assert/strict');
const { add, subtract, square } = require('./arithmetic');
test('addition', () => assert.equal(add(2, 3), 5));
test('subtraction', () => assert.equal(subtract(5, 2), 3));
test('square positive input', () => assert.equal(square(5), 25));
test('square negative input', () => assert.equal(square(-3), 9));
test('square zero input', () => assert.equal(square(0), 0));
