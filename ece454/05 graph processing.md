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
