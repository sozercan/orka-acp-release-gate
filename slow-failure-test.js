const assert = require('node:assert/strict');
const { add, subtract } = require('./arithmetic');
setTimeout(() => {
  assert.equal(add(2, 3), 5);
  assert.equal(subtract(5, 2), 3);
  assert.fail('SLOW_FAILURE_EXPECTED: deliberate negative validation fixture');
}, 95000);
