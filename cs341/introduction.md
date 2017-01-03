# Introduction

## Analysis of algorithms
### Efficiency
Given an algorithm $A$, we want to know how efficient it is. This includes:

- asymptotic complexity
- number of computations done
- average-case complexity
- lower bound on the complexity of *any* algorithm to solve the problem
- NP-completeness
- undecidability

### Design

Strategies:

- divide-and-conquer
- greeedy
- dynamic programming
- depth- and breadth-first search
- local search
- linear programming

### e.g. Maximum problem
Given an array $A$ of $n$ integers, find the maximum element in $A$.

```
FindMaximum(A = [ A[0], ..., A[n-1] ]) {
  max = A[0]
  for i in 1..(n-1) {
    if A[i] > max
      max = A[i]
  }
  return max
}
```

#### Correctness
Loop invariant: $max = \max(A[0..i])$

Prove the claim by induction:

- Base case $i=2$ is obvious
- Assume it is true for $i=j, 2 \leq j \leq n-1$, and probe the claim is true for $i=j+1$
- When $j=n$ we are done and correctness is proven

#### Analysis
It will always require $n-1$ comparisons, so the algorithm is $\Theta(n)$. This is the lower bound for any algorithm solving Maximum:

- assume $n$ elements are distinct
- construct a graph on $n$ vertices
  - create an edge $i,j$ if $A[i$ is compared to $A[j]$ at some point during the execution of the algorithm
- if there are less than $n-1$ comparisons, then there are less than $n-1$ edges
  - If a graph has fewer than $n-1$ edges, the graph is not connected
  - the graph therefore is not connected
  - this  means the components of the graph are never compared. If there are, for example, two components $C_1$ and $C_2$, the algorithm can't determine which one contains the maximum
  - This is a contradiction, so the number of comparisons must be at least $n-1$

### e.g. Max-min
Given an array $A$ of $n$ integers, find the maximum and minimul element in $A$.

```
FindMaximum(A = [ A[0], ..., A[n-1] ]) {
  max = A[0]
  min = A[0]
  for i in 1..(n-1) {
    if A[i] > max
      max = A[i]
    if A[i] < min
    	min = A[i]
  }
  return (max, min)
}
```

The **complexity** is optimal, but there may be algorithms that require less **comparisons**:

- Suppose $n$ is even and we consider elements **two at a time**.
- Initially, compare first two elements to initialize a max and min
- For each new pair, compare the larger with the max and the smaller with the min
- This algorithm requires a total of $\frac{3n}{2}-2$ comparisons


### e.g. 3SUM problem
Given an array $A$ of $n$ distinct integers, do there exist three elements in $A$ that sum to 0?

```
Trivial3SUM(A) {
  for i = 0..(n-3) {
    for j = (i+1)..(n-2) {
      for k = (j+1)..(n-1) {
        if A[i] + A[j] + A[k] == 0 {
          return (i, j, k)
        }
      }
    }
  }
  return nil
}
```

Alternative 1:

- Pre-sort the array
- Instead of 3 nested loops, try with 2
- Binary search for an $A[k]$ which equals $-A[i] - A[j]$
- Now we have $O(n\log{n} + n^2 \log{n}) = O(n^2 \log{n})$

Alternative 2:

- Also pre-sort the array
- Simultaneously scan from both ends of $A$ looking for $A[j]+A[k]=-A[i]$

```
Trivial3SUM(A) {
  sort(A)
  for i = 0..(n-3) {
    var j = i+1
    var k = n-1
    while j < k {
      var sum = A[i] + A[j] + A[k]
      if S < 0 {
        j = j+1
      } else if S > 0 {
        k = k-1
      } else { // found the triple
        return (i, j, k)
      }
    }
  }
  return nil
}
```

Complexity is $O(n^2)$.

Best-known algorithm has complexity $O(n^2 \frac{\log{\log{n}}}{\log{n}}^2)$