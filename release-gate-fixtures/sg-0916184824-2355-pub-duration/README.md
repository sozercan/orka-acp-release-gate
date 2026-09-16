# Duration parser coding fixture

Implement `parseDuration(input)` in `implementation.cjs` to satisfy this contract.
Only `implementation.cjs` may be modified. Keep the named CommonJS export
`module.exports = { parseDuration }`. Do not change the tests or this README.

## Contract

- Accept a primitive string consisting of an unsigned decimal integer followed
  immediately by exactly one of these lowercase units:

  | Unit | Milliseconds per unit |
  | --- | ---: |
  | `ms` | 1 |
  | `s` | 1000 |
  | `m` | 60000 |
  | `h` | 3600000 |

- The integer is `0` or starts with a digit from `1` to `9`. No leading zeros,
  signs, fractions, exponents, whitespace, omitted units, or trailing text.
- Return the exact duration in milliseconds as a primitive JavaScript `number`,
  not a string or `bigint`. Zero is valid for every unit.
- Throw `TypeError` for non-string inputs; do not coerce them.
- Throw `SyntaxError` for strings outside the grammar above.
- Throw `RangeError` if a syntactically valid duration would exceed
  `Number.MAX_SAFE_INTEGER` milliseconds. Do not round or clamp it.
- Keep the function synchronous and free of side effects. Use only built-in
  JavaScript/Node facilities; no dependencies, tools, files, or network access
  from the implementation.

## Run the tests

From this directory, with Node.js 18 or newer:

```sh
node --test test.cjs
```

No installation or build step is required. Make the smallest implementation-only
change needed to satisfy the contract and run the unchanged test suite.
