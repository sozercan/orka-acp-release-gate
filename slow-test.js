const assert = require('node:assert/strict');
const { add, subtract } = require('./arithmetic');
async function main() {
  await new Promise(resolve => setTimeout(resolve, 95000));
  assert.equal(add(2,3), 5);
  assert.equal(subtract(5,2), 3);
  console.log('SLOW_VALIDATION_OK');
}
main().catch(error => { console.error(error); process.exitCode = 1; });
