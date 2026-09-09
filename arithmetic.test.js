const test = require('node:test');
const assert = require('node:assert/strict');
const { add, subtract } = require('./arithmetic');
test('addition', () => assert.equal(add(2, 3), 5));
test('subtraction', () => assert.equal(subtract(5, 2), 3));
