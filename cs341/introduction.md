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

Best-known algorithm has complexity $O\left(n^2 \left(\frac{\log{\log{n}}}{\log{n}}\right)^2\right)$

## Problems

- **Instance** is the input for the problem
- **Solution** is the output for the problem
- $Size(I)$ is the number of bits required to store the instance $I$
- Integers
  1. Fixed size, e.g. use one word of memory
  2. large ints, with no bound on size

### Running time, complexity
- Running time of a program: $T_M(I)$ is running time in seconds of a program $M$ on problem instance $I$
- Worst-case running time: $T_M(n) = \max\left\{T_M(I) : Size(I) = n\right\}$
- Worst-case complexity: $T_M(n) \in \Theta(f(n))$
- Avg-case complexity: $T_M^{avg}(n) \in \Theta(f(n))$


We can determine the complexity of an algorithm **without implementing it**.

### $O$-Notation
$\exists c \gt 0, n_0 \gt 0 \mid 0 \le f(n) \le cg(n) \forall n \ge n_0 \Rightarrow F(n) \in O(g(n))$

### $\Omega$-Notation
$\exists c \gt 0, n_0 \gt 0 \mid 0 \le cg(n) \le f(n) \forall n \ge n_0 \Rightarrow F(n) \in \Omega(g(n))$

### $\Theta$-Notation
$f(n) \in O(g(n)) \land f(n) \in \Omega(g(n)) \Rightarrow F(n) \in \Theta(g(n))$

### Rules
$$f(n) \in \Omega(g(n)) \Leftrightarrow g(n) \in \Theta(f(n))$$
$$f(n) \in O(g(n)), g(n) \in O(h(n)) \Rightarrow f(n) \in O(h(n))$$

#### Maximums
$$O(f(n) + g(n)) = O(\max\{f(n), g(n)\})$$
$$\Omega(f(n) + g(n)) = \Omega(\max\{f(n), g(n)\})$$
$$\Theta(f(n) + g(n)) = \Theta(\max\{f(n), g(n)\})$$

#### Sums (for infinite only)
$$O\left(\sum_{i \in I} f(i)\right) = \sum_{i \in I} O(f(i))$$
$$\Omega\left(\sum_{i \in I} f(i)\right) = \sum_{i \in I} \Omega(f(i))$$
$$\Theta\left(\sum_{i \in I} f(i)\right) = \sum_{i \in I} \Theta(f(i))$$

#### Sequences
Arithmetic:
$$\sum_{i=0}^{n-1}(a+di) = na+\frac{dn(n-1)}{2} \in \Theta(n^2)$$

Geometric
$$\sum_{i=0}^{n-1} ar^i = \begin{cases}
a \frac{r^n-1}{r-1} \in \Theta(r^n), & \gt 1 \\
na \in \Theta(n), &r=1 \\
a\frac{1-r^n}{1-r} \in \Theta(1), &0 \lt r \lt 1
\end{cases}$$

Arithmetic-geometric
**TODO finish**
$$
\sum_{i=0}^{n-1} (a+di)r^i = \frac{a}{1-r}
$$

### From first principles
e.g. Prove from first principles that:

$$\begin{align*}
\text{Given } 
f(n) &= n^2 - 7n - 30 \\
\text{and } g(n) &= n^2 \text{,} \\
f(n) &\in O(g(n)) \\
\\
f(n) &\leq c \cdot g(n) \\
\text{Take } c&=1 \text{. Then:}\\
n^2 -7n-30 &\leq n^2 \forall n \gt 0\\
\\
\\
f(n) &= (n-10)(n+3) \\
f(n) &\ge 0 \text{ if  } n \ge 10 \\
\\
\text{Let } n_0 &= \max\{0, 10\} = 10 \\
\text{Then } 0 &\le f(n) \le g(n) \text{ if  } n \ge n_0 = 10
\end{align*}$$

e.g. Prove from first principles that:

$$\begin{align*}
\text{Given } 
f(n) &= n^2 - 7n - 30 \\
\text{and } g(n) &= n^2 \text{,} \\
f(n) &\in \Omega(g(n)) \\
\\
\text{We want } cn^2 &\le n^2-7n-30\\
\text{Any value of } c &< 1 \text{ will work }
\end{align*}$$

e.g. Prove from first principles that:
$$\begin{align*}
\text{Given } 
f(n) &= n^2 + n \\
\text{and } g(n) &= n \\
f(n) &\notin \Omega(g(n)) \\
\\
f(n) \gt cg(n) \text{ iff } n^2 + n \gt cn \\
\text{iff } n+1 \gt c, n \gt 0\\
\text{iff } n \gt c-1\\
\\
\text{Let } n &= \max\{c, n_0\} \text{ and the equality holds. }
\end{align*}$$

### Techniques
#### Limits
Suppose $f(n) > 0$ and $g(n) > 0 \quad \forall n \ge n_0$. Suppose that:
$$L=\lim_{n \rightarrow \infty} \frac{f(n)}{g(n)}$$

Then:
- $F(n) \in o(g(n))$ if $L=0$
- $F(n) \in \Theta(g(n))$ if $0 \lt L \lt \infty$
- $F(n) \in \omega(g(n))$ if $L = \infty$


e.g. using L'Hospital's Rule
$$\begin{align*}
f(n)=(\ln n)^2 \\
g(n) = n^{\frac{1}{2}} \\
\\
&\lim_{n \rightarrow \infty} \frac{(\ln n)^2}{n^{\frac{1}{2}}} \\
= &\lim_{n \rightarrow \infty} \frac{2(\ln n)\frac{1}{n}}{\frac{1}{2} n^{-\frac{1}{2}}} \\
= &\lim_{n \rightarrow \infty} \frac{4(\ln n)}{n^{\frac{1}{2}}} \\
= &\lim_{n \rightarrow \infty} \frac{4\frac{1}{n}}{\frac{1}{n} n^{-\frac{1}{2}}} \\
= &\lim_{n \rightarrow \infty} \frac{8}{n^{\frac{1}{2}}} \\
= &0
\end{align*}$$

#### General rules
- $(\ln n)^c \in o(n^\delta) \quad \forall c \gt 0, \delta \gt 0$
- $n^c \in o(d^n) \quad \forall c \gt 0, d \gt 1$

e.g.
$$
f(n) = (3+(-1)^n)n
$$

This means $f(n) = 4n$ if $n$ is even, or $2n$ if $n$ is odd

$$
g(b) = n $$

$$
\frac{f(n)}{g(n)} = \begin{cases} 4, &n \text{ is even } \\
2, & n \text{ is odd }\end{cases} \\
\lim_{n \rightarrow \infty} \frac{f(n)}{g(n)} \text{ does not exist }
$$
