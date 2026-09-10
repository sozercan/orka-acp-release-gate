const test = require('node:test');
const assert = require('node:assert/strict');
const { add, subtract, negate } = require('./arithmetic');
test('addition', () => assert.equal(add(2, 3), 5));
test('subtraction', () => assert.equal(subtract(5, 2), 3));
test('negate positive number', () => assert.equal(negate(5), -5));
test('negate negative number', () => assert.equal(negate(-3), 3));
test('negate zero', () => assert.equal(negate(0), -0));
