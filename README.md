# Orka example validation fixture

A small arithmetic module for live workflow validation. Run `node --test`.

## Helpers

- `square(n)`: returns `n * n`.

Example:

```js
const { square } = require('./arithmetic');

square(4); // 16
```

No third-party packages or network access are required for the tests.
