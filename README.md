# CS 241e
## Foundations of Sequential Programs Enriched

Prof. Ondrej Lhotak


# 1. Introduction
## Bits
- Have no assigned meaning by themselves

### Conventions
There are infinitely many integers, but only 2<sup>32</sup> can be represented on a 32-bit system, so arithmetic is done on the finite ring of equivalence classes mod 2^32.

### Numeric Interpretation
- As an unsigned integer, there are 2<sup>32-1</sup> integers in a 32-bit int
- In Two's Complement signed integers, the first bit is the sign bit
  - Addition, multiplication, and subtraction are the same as om  integers
  - Division and magnitude comparison need separate operations for unsigned and Two's Complement numbers

## Our Computer
The computer we're using happens to have state equivalent to {0, 1}<sup>2<sup>26</sup> + 32 * 34</sup>

```
+------------------------------------------------+        Memory
|                                                |          32
|                            Registers           |    +------------+
|   +-----------------+          32              |    |            |
|   |   Control Unit  |   +---------------+      |    |            |
|   |                 |   | 0 1 0 ...     |  34  |    |            |
|   +-----------------+   | 1             |      | -> |            |
|   |       ALU       |   | 0             |      |    |            |
|   |                 |   |               |      |    |            |
|   +-----------------+   +---------------+      |    |            |
|                                                |    +------------+
+------------------------------------------------+




```

The CPU implements a function `step`:
```
step: state -> state
step(s) = 1100

Initial state s0 -> s1 -> ... -> s3
              ^
              Program data
```

