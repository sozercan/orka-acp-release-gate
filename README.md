# Orka example validation fixture

A small arithmetic module for live workflow validation. Run `node --test`.
No third-party packages or network access are required for the tests.

## API

### add(a, b)
Adds two numbers and returns the sum.

### subtract(a, b)
Subtracts b from a and returns the difference.

### divide(a, b)
Divides a by b and returns the quotient. Throws a RangeError if b is zero.
