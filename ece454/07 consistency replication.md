# Consistency and Replication

Distribution:
1. Partitioning
2. Replication

## Replication
Why?
- increase throughput
  - e.g. Memcache, having multiple copies allows more things being served at once
- Lower latency
  - Adds more hardware to the problem
- Greater fault tolerance

### Examples
1. GFS and HDFS
  - Data storage and movement
2. Map-reduce
  - Math (speculative execution)
3. MySQL server
  - Data (shared mutable state)
  - Very hard

### Storage system behaviour
#### Sequential Consistency

This example is consistent:

Process|time| | | | |
-------|----|-|-|-|-|
P1|w(x)a| | | |
P2| |w(x)b| | |
P3| | |r(x)b| |r(x)a
P4| | | |r(x)b|r(x)a

If two writes occur in two different processes, they do not necessarily fall in temporal order. This only applies to writes in the same process.

There must be a sequential ordering of the events for it to be sequentially consistent.

This example is **not**:

Process|time| | | | | |
-------|----|-|-|-|-|-|
P1|w(x)a| | | | |
P2| |w(x)b| | | |
P3| | |r(x)b| |r(x)a|
P4| | | |r(x)a| |r(x)b

#### Causal consistency
Process|time| | | | | |
-------|----|-|-|-|-|-
P1|w(x)a|     |     |w(x)c|     |
P2|     |r(x)a|w(x)b|     |     |
P3|     |r(x)a|     |     |r(x)c|r(x)b
P4|     |r(x)a|     |     |r(x)b|r(x)c

Has relationships "follows" and "reads from", both examples of a causal precedence.
