# Graph processing

## Pregel
- each worker responsible for a **vertex partition**
- Model of computation is vertex-centric
- For each vertex, it comes with this state:
  - a problem-specific value (e.g. the PageRank value of the vertex)
  - a list of messages sent to the vertex
  - a list of outgoing edges
  - a binary active/inactive state
- Uses **Bulk Synchronous Parallel (BSP)** model
  - Computation organized into synchronous rounds/iterations, called **supersteps**
  - workers compute asynchronously during superstep, then communicate between
- Master delegates vertices to workers using a partitioner (usually a hash function)

### e.g. Max
```
3 -> 6
6 -> 3
2 -> 6
2 -> 1
1 -> 2
6 -> 1
```

- Each vertex stores the max it knows about as its state, starting at its own number.
- Each iteration, each vertex sends its current number to its neighbours along its edges.
- The vertex sets its label to the max of the received values and its current value.

### e.g. PageRank
```cpp
void compute(MessageIterator msgs) {
  if (superstep() >= 1) {
    double sum = 0.0;
    for (; !msgs->done(); msgs->next()) {
      sum += msgs->value();
    }
    mutableValue = 0.15 / numVertices + 0.85 * sum;
  }
  if (superstep() < 30) {
    const int64 n = getOutEdgeIterator().size();
    sendMessageToAllNeighbours(getValue() / n);
  } else {
    voteToHalt();
  }
}
```

### Single source shortest paths
```
A --1-> C
A --3-> B
C --1-> B
```

Trace:
```
SS0.
A = 0
B = infinity
C = infinity
A sends 0+3=3 to B
A sends 0+1=1 to C

SS1.
A = 0
B = 3
C = 1
A is unchanged, votes to halt
C sends 1+1=2 to B

SS2.
A = 0
B = 2
C = 1
A is unchanged, votes to halt
C is unchanged, votes to halt
B has no out neighbours, votes to halt

Done
```

## Combiners
- Similar to Hadoop
- Commutative and associative
- If two messages from the same vertex partition are going to the same destination, they can be combined into one message
  - e.g. for single source shortest path:
  ```cpp
  void combine(MessageIterator msgs) {
    float minDist = infinity;
    for (; !msgs->done(); msgs->next()) {
      minDist = min(minDist, msgs->value());
    }
    // output(source_name, value)
    output("combined_source", minDist);
  }
  ```

## Aggregators
- Act like mapreduce reducers
- Final value is broadcast by the master to all vertices in the next superstep
