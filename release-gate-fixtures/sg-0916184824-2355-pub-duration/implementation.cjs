'use strict';

const MULTIPLIERS = Object.freeze({
  ms: 1n,
  s: 1000n,
  m: 60000n,
  h: 3600000n,
});

function parseDuration(input) {
  if (typeof input !== 'string') {
    throw new TypeError('Duration must be a string');
  }

  const match = /^(0|[1-9][0-9]*)(ms|s|m|h)$/.exec(input);
  // JavaScript's $ can match before a final newline; require the whole string.
  if (!match || match[0] !== input) {
    throw new SyntaxError('Invalid duration syntax');
  }

  const milliseconds = BigInt(match[1]) * MULTIPLIERS[match[2]];
  if (milliseconds > BigInt(Number.MAX_SAFE_INTEGER)) {
    throw new RangeError('Duration exceeds the safe integer range');
  }
  return Number(milliseconds);
}

module.exports = { parseDuration };
