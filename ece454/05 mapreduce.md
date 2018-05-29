# Hadoop MapReduce

1. Mapper: $x \rightarrow (x, 1)$
2. Combine
  - Uses the same lambda as the reducer to combine data before sending over the network
3. Shuffle
  - Use hash function to pick a server to send each mapped datum to
4. Sort
  - Uses mergesort
5. Reduce: $(a, b) \rightarrow a + b$
  - Associative, commutative

## Fault tolerance
- Since everything is deterministic, if a mapper fails, just give the tasks to someone else
- If a reducer fails, the reduce step can be restarted on another server from after the shuffle phase since the result is saved to disk as a checkpoint
- Slow servers (stragglers) are dealt with by speculatively giving redundant tasks to other servers
