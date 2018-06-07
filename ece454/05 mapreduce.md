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

## Projection
```
Mapper(key k, tuple t)
  tuple g = project(t)
  emit(g, null)

# Only for duplicate elimination
Reducer(tuple t, array n)
  emit(t, null)
```

## Inverted index

### Sample input:
```
url1 {jaguar, fast, v8}
url2 {jaguar, fast, teeth, tail}
```

### Sample output:
```
jaguar -> {url1, url2}
fast -> {url1, url2}
v8 -> {url1}
tooth -> {url2}
tail -> {url1}
```

### Sample code:
```
Mapper(docID id, doc d)
  for each term t in d:
    emit(t, id)

Reducer(term t, docIDs [id1, id2, ..., idn])
  emit(t, flattened list of docIDs)
```

## Cross-correlation

### Sample input:
```
[ketchup, mustard, relish]
[ketchup, buns]
```

### Sample output:

N = 4 (number of distinct items)

| |k|m|r|b|
|-|-|-|-|-|
|k|X|1|1|1|
|m|X|X|1|0|
|r|X|X|X|0|
|b|X|X|X|X|

```
([k, m], 1)
([k, r], 1)
([k, b], 1)
([m, r], 1)
([m, b], 0)
([r, b], 0)
```

Number of elements in output:
$$\begin{align}
|output| &= \binom{n}{2}\\
&= \frac{4!}{2!2!}\\
&= 6\\
\end{align}$$

### Pairs approach
```
# Each item is one thing in a receipt
Mapper(null, items [i1, i2, ..., ik])
  for each item i in [i1, ..., ik]:
    for each item j in [i1, ..., ik] where j > i:
      emit([i, j], 1)

Reducer(pair [i, j], counts [c1, ..., cn])
  s = sum of [c1, ..., cn]
  emit([i, j], s)
```

### Stripes approach
```
Mapper(null, items [i1, i2, ..., ik])
  for each item i in [i1, ..., ik]:
    H = new Map from item -> counter, initially zero
    for  each item j in [i1, ..., ik] where j > i:
      H{j} = H{j} + 1

    emit(i, H)
    # H is a stripe, e.g.
    #   (ketchup, {mustard: 1, relish: 1})

Reducer(item i, stripes [H1, H2, ..., Hm])
  H = new Map from item -> counter, initially zero
  H = merge_sum([H1, H2, ..., Hm])
  for each item j in keys(H):
    emit([i, j], H{j})
```

## Spark

### Ways to partition RDD
1. Arbitrary
  - When loading raw data from file(s)
2. By key
  - Occurs after a group by or reduce by key

#### Join with inputs co-partitioned

RDD 1|RDD 2
-----|-----
`url1 val1` -> executor 1|`url1 val1'` -> executor 1
`url2 val2` -> executor 1|`url2 val2'` -> executor 1
`url3 val3` -> executor 2|`url3 val3'` -> executor 2

Assuming both are partitioned by key.

`rdd1.join(rdd2)`

This is a **narrow dependency**:
- Both tables partitioned by the same key
- Local copies of things to join are on the same executor

#### Join with inputs NOT co-partitioned

RDD 1|RDD 2
-----|-----
`url1 val1` -> executor 3|`url1 val1'` -> executor 1
`url2 val2` -> executor 1|`url2 val2'` -> executor 1
`url3 val3` -> executor 2|`url3 val3'` -> executor 2

In this case, the same key is not on the same executor always, assuming arbitrary partitioning for e.g. table 1, but by key for table 2.

`rdd1.join(rdd2)`: code looks the same as before, it all depends on the state of the data

This is a **wide dependency** because a shuffle is required before joining.

`rdd1.map((x, y) => (y, x)).join(rdd2)` will almost certainly by a wide dependency since it will now be indexed by value.

### Word count
```scala
val dat = sc.textFile("sample_input")
dat
  .flatMap(_.split("\\s+")) // Tokenize
  .filter(_.length() > 4) // Get rid of small words like "a", "an", etc
  .map(x => (x, 1)) // Initial count per word is 1
  .reduceByKey(_+_) // At this point we have word counts by word
  .map(x => (x._2, x._1)) // Swap key and value
  .sortByKey(false) // false means it will be descending
  .take(15) // Get the first 15 results
```
