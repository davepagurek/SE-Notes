# Intractability and Decidability

## Decision Problems
- Problems where the answer is "yes" or "no"
- The size of an instance $Size(I)$ is the number of bits required to specify or encode the instance $I$

## Complexity class P
- An algorithm $A$ solves a decision problem $\Pi$ if $A$ finds the correct answer for $\Pi$ in finite time
- A **polynomial time algorithm** has the complexity $O(n^k)$ where $k$ is a positive integer and $n = Size(I)$
- Complexity class P denotes the set of alld ecision problems that have polynomial time algorithms solving them


### e.g. Cycles in graphs
**Cycle**: $G$ is an undirected graph. Does $G$ contain a cycle?
- Cycle problem $\in$ P:
  - $G$ has a cycle iff a BFS or DFS has a non-tree edge

**Hamiltonian cycle**: $G$ is an undirected graph. Does $G$ contain a cycle that passes through every vertex in $V(G)$ exactly once?
- Hamiltonian cycle problem is NP-complete: there is no polynomial time algorithms to solve this problem

**0-1 Knapsack Decision**: Given a list of profits $P$, a list of weights $W$, a capacity $M$ and a target profit $T$, is there an $n$-tuple $[x_1,x_2,...,x_n] \in \{0,1\}^n$ such that $\sum w_ix_i \le M$ and $\sum p_ix_i \ge T$?
- 0-1 Knapsack Decision is NP-complete

**Rational Knapsack Decision**: Given a list of profits $P$, a list of weights $W$, a capacity $M$ and a target profit $T$, is there an $n$-tuple $[x_1,x_2,...,x_n] \in [0,1]^n$ such that $\sum w_ix_i \le M$ and $\sum p_ix_i \ge T$?
- Rational Knapsack Decision $\in$ P 

## Polynomial-time Turing Reductions
Suppose $\Pi_1$ and $\Pi_2$ are problems (not necessarily decision problems.) A hypothetical algorithm of $A_2$ to solve $\Pi_2$ is called an **oracle** for $\Pi_2$.

Suppose $A_1$ is an algorithm that solves $\Pi_1$, assuming an existence of an oracle $A_2$ for $\Pi_2$. Then we say that $A_1$ is a **Turing reduction** from $\Pi_1$ to $\Pi_2$, denoted:
$$\Pi_1 \le^T \Pi_2$$

A turing reduction $A$ is a polynomial time Turing reduction if the running time for $A$ is polynomial under the assumption that the oracle $A_2$ has **unit cost** running time.

If there is a polynomial time Turing reduction from $\Pi_1$ to $\Pi_2$, we write:
$$\Pi_1 \le^T_P \Pi_2$$

The complecity of a reduction takes into account:
- The complexity of $A_1$
- The number of calls to the oracle $A_2$

## Travelling Salesman Problem
**TSP-Optimization**: Given a graph $G$ and edge weights $w : E \rightarrow \mathbb{Z}^+$, find a Hamiltonian cycle $H$ in $G$ such that $w(H) = \sum_{e \in H}w(e)$ is minimized

**TSP-Optimal Value**: Given a graph $G$ and edge weights $w : E \rightarrow \mathbb{Z}^+$, find the minimum $T$ such that there exists a Hamiltonian cycle $H$ in $G$ with $w(H)=T$.

**TSP-Decision**: Given a graph $G$ and edge weights $w : E \rightarrow \mathbb{Z}^+$ and a target $T$, does there exist a Hamiltonian cycle $H$ in $G$ with $w(H) \le T$?

### Trivial reductions
- TSP decision $\le^T_P$ TSP optimization
- TSP decision $\le^T_P$ TSP optimal value

### Less trivial reductions
TSP optimal value $\le^T_P$ TSP decision. This can be done using **binary search**: use the oracle to see if it's possible to reach a target halfway through the search space. Depending on the response, we can then cut the search space in half by 2.

This means we need to have upper and lower bounds computed to start with.
- If we know there are no negative value cycles, we can select 0 as the lower bound
- We can make the high value $\sum_{e \in G} w(e)$
