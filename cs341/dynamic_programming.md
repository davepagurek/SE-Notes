# Dynamic Programming
1. Examine the structure of an optimal solution to a problem instance $I$, and determine if an optimal solution for $I$ can be expressed in terms of optimal solutions to certain subproblems of $I$.
2. Define a set of subproblems $S(I)$ of the instance $I$, the solution of which enables the optimal solution of $I$ to be computed. $I$ will be the last or largest instance in the set $S(I)$.
3. Derive a recurrence relation on the optimal solutions to the instances in $S(I)$. This recurrence relation should be completely specified in terms of optimal solutions to (smaller) instances in $S(I)$ and/or base cases.
4. Compute the optimal solutions to all the instances in $S(I)$. Compute these solutions using the recurrence relation in a bottom-up fashion, filling in a table of values containing these optimal solutions. Whenever a particular table entry is filled in using the recurrence relation, the optimal solutions of relevant subproblems can be looked up in the table (they have been computed already). The final table entry is the solution to $I$.

## 0-1 Knapsack
Profits $P$ and weights $W$ and a capacity $M$ exist. An $n$-tuple $X$ exists where $\sum_{i=1}^n w_i x_i \le M$. We require that $x_i \in \{0, 1\}, 1 \le i \le n$.

Consider $x_n$. Two cases exist:

- $x_n = 0$: We don't include $x_i$, so the optimal solution for $I$ is the optimal solution for the items $1, ..., n-1$ (capacity is $M$)
- $x_n = 1$: We do include $x_i$, so the optimal solution for $I$ includes $x_i$ plus the optimal solution for items $1, ..., n-1$ (capacity is $M-1$ this time)


Subproblems $S(I)$: Let $P(i, m)$ be the optimal solution to the subproblem consisting of:
- The first $i$ items ($i=1, 2, ..., 2)$
- the capacity $m$, $0 \le m \le M$

In total, we get $n(M+1)$ subproblems

Recurrence relation:
$$P(i, m) = \begin{cases}
\max\left\{P(i-1, m), P(i-1, m-w_i)+p_i\right\}, &m \ge w_i, i \ge 2\\
P(i-1, m), &m \lt w_i, i \ge 2\\
\end{cases}$$

Base cases:
$$P(1, m) = \begin{cases}
p_1, &m \ge w_1\\
0, &m \lt w_1\\
\end{cases}$$

- Fill in table of values
- Fill in each row from left to right
- solution = $P(n, M)$

<img src="img/knapsack-dp-algo.png" />

### Runtime
Assuming unit cost operations: $\Theta(1)$ time additions and subtractions
- DP: $\Theta(Mn)$
- Recursive: $\Theta(2^n)$

But **neither is polynomial complexity**:
$$\begin{align*}
I &= (p_1, ..., p_n, w_1, ..., w_n, M)\\
size(I) &= \sum_{i=1}^n \log_2 p_i + \sum_{i=1}^n \log_2 w_i + \log_2 M\\
size(I) &\ge n\\
\end{align*}$$

$M$ is exponentially large compared to $\log_2 M$. Therefore we cannot express the problem in polynomial time with an $M$ in it when it is exponentially large compared to the problem instance.

### Traceback
The first step only fills in the table. If we want to know what is actually in the knapsack, we have to trace back through the table to see what items we added.

<img src="img/knapsack-dp-soln.png" />

## Coin changing
A list of coin denominations $D$ exists, and a positive target sum $T$. Find an $n$-tuple of non-negative integers sich that $T=\sum_{i=1}{n} a_i d_i$ such that the number of coins $n$ is minimized.

Let $N(i, t)$ denote the optimal solution to the subproblem consisting of the first $i$ coin denominations $d_1, ..., d_i$ and target sum $t$. Let $A(i, t)$ denote the number of coins of denomination $d_i$ used in the optimal solution to this subproblem.

### Algorithm
For a given target sum $T$, consider coins of denomination $d_n$. Let $a_n$ be the number of coins. Then $0 \le a_n \le \left\lfloor\frac{T}{d_n}\right\rfloor$.

If we use $a_n$ coins of denomination $d_n$, then the optimal solution for $I$ is $a_n$ plus the optimal solution using the first $n-1$ coin denominations, for the targt sum $T-a_n d_n$.

We then have the subproblems $N(i, t), i=1,...,n, 0 \le t \le T$. There will be $n(T+1)$ subproblems.

We get the recurrence relation:
$$N(i, t) = \min\left\{j+N(i-1, t-jd_i), 0 \le j \le \left\lfloor\frac{t}{d_i}\right\rfloor\right\}$$

If $i=1$, we get the base case $N(1, t) = t$.
