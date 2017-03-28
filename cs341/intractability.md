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

# Certificates
- A **certificate**:  for a yes-instance $I$ is some exxtra information $C$ which makes it easy to verify that $I$ is a yes-instance
- Suppose $Ver$ is a **certificate validation algorithm**. Then it is an algorithm that verifies certificates for yes-instances. Then $Ver(I,C)$ outputs "yes" if $I$ is a yes-instance and $C$ is a valid certificate for $I$. If the output is "no", then either $I$ is a no-instance, or $I$ is a yes-instance and $C$ is an invalid certificate.
- A certificate verification algorithm $Ver$ is a **polynomial time** certificate verification algorithm if the complexity of $Ver$ is $O(n^k), k \in \mathbb{N}, n = Size(I)$

## NP
- Certificate verification algorithm: Solves a decision problem $\Pi$ provided:
  - for every yes-instance $I$, there must exist a $C$ such that $Ver(I,C)$ outputs "yes"
  - For every no instance $I$ and every certificate $C$, $Ver(I,C)$ outputs "no"
- NP denotes the set of all decision problems that have polynomial time certificate verification algorithms solving them.

### P is in NP
Let $A$ be a polynomial-time algorithm to solve $\Pi \in P$. Define a certificate verification algorithm $Ver$ for $\Pi$:

```
Ver(I,C):
  run A(I) (ignore C)
```

### Polynomial-time Reductions
For a decision problem $\Pi$, let $I(\Pi)$ denote the set of all instances of $\Pi$. Let $I_{yes}\Pi$ and $I_{no}\Pi$ be all the yes- and no-instances.

Let $\Pi_1, \Pi_2$ be decision problems. Transformation from $\Pi_1$ to $\Pi_2$ exists if there exists a function $f : I(\Pi_1) \rightarrow I(\Pi_2)$ such that:
- $f(I)$ is computable in polynomial time
- if $I \in I_{yes}(\Pi_1)$, then $f(I) \in I_{yes}(\Pi_2)$
- if $I \in I_{no}(\Pi_1)$, then $f(I) \in I_{no}(\Pi_2)$ (basically always prove this with contrapositive so that you are dealing with yes-instances)

Properties
- If $\Pi_1 \le_P \Pi_2$ and $\Pi_2 \in P$, then $\Pi_1 \in P$
- If $\Pi_1 \le_P \Pi_2$ and $\Pi_2 \le_P \Pi_3$, then $\Pi_1 \le_P \Pi_3$

## NP-Completeness
NPC denotes the set of all decision problems $\Pi$ that satisfy:
- $\Pi \in NP$
- For all $\Pi' \in NP, \Pi' \le_P \Pi$

If $P \cup NPC \ne \emptyset$, then $P = NP$.

### 3-CNF-SAT to Clique
Let $I$ be the instance of 3-CNF-SAT consisting of $n$ variables, $x_1, ..., x_n$ and $m$ clauses $C_1, ..., C_n$. Let $C_i = {z_1^i, z_2^i, z_3^i}$, $1 \le i \le m$.

Define $f(I) = (G,k), G=(V,E)$, where:
- $V = \{v_j^i: 1 \le i \le m, 1 \le j \le 3\}
- $v_j^i v_{j'}^{i'} \in E$ iff $i \ne i' \land z^i_j \ne \bar{z_{j'}^{i'}}$

e.g.
$C_1 = \{x_1, \bar{x_2}, \bar{x_3}\}$
$C_2 = \{\bar{x_1}, x_2, x_3\}$
$C_3 = \{x_1, x_2, \bar{x_3}\}$
We use this to create a clique by taking the non-edges (complementing the graph). There is a triangle on each level. Connect two vertices if the corresponding literals are negations of each other.

#### Yes mapping to yes
$x_1 = T, x_2 = T, x_3 = F$. Choose a true literal from each clause, and take the corresponding vertices in the graph. There are $m$ different levels, so no two of these literals are negatives of each other. This means that there are no edges in the complementary graph, which forms a clique in the real graph. Therefore yes in 3-CNF-SAT maps to yes in Clique.

In the reverse direction, suppose $f(I)$ is a yes instance. We will prove that $I$ is a yes instance.
- A clique of size $m$ implies there is one vertex on each level
- Assign the corresponding literals to be true
- The truth assignment is consistent: A clique in the graph means the vertices are connected. If the vertices are connected, then they are not negations of each other, so we will not be assigning a variable and also its negation to be true.
- There is now a literal in each clause.

### Vertex cover to Subset sum
Subset sum: Given a list of sizes $S=[s_1, ..., s_n]$ and a target sum $T$, does there exist a subset of these sizes $J \subseteq \{1,...,n\} \mid \sum_{i \in J} s_i = T$?

Suppose $I = (G,k)$ where $G=(V,E), |V|=n, |E|=m$ and $1 \le k \le n$. Suppose $V=\{v_1,...,v_n\}$ and $E=\{e_0,...,e_{m-1}$. For $1 \le i \le n, 0 \le j \le m-1$, let:
$$c_{ij}=\begin{cases}
1, &e_j \text{ is incident with } v_i\\
0, &\text{otherwise}
\end{cases}$$

Define $n+m$ sizes and a target sum $W$ as follows:
$$\begin{align*}
a_i &= 10^m + \sum_{j=10}^{m-1}{c_{ij} 10^j}, &1 \le i \le n\\
b_j &= 10^j, &0 \le j \le m-1\\
W &= k \cdot 10^m + \sum_{j=0}^{m-1}{2\cdot 10^j}
\end{align*}$$
Then define $f(I)=(a_1, ..., a_n, b_0, ..., b_{m-1}, W)$.

e.g.
Start with a vertex cover and $k=2$.
<img src="img/cover.png" />

We then can make the subset sum:
```
W = k  2  2  2  2  2
       e4 e3 e2 e1 e0
v1: 1  0  0  0  1  1 = a1
v2: 1  1  0  1  1  0 = a2
v3: 1  0  1  1  0  1 = a3
v4: 1  0  1  0  0  0 = a4
v5: 1  1  0  0  0  0 = a5
                   1 = b0
                1  0 = b1
             1  0  0 = b2
          1  0  0  0 = b3
       1  0  0  0  0 = b4


W  = 2 2 2 2 2 2
a2 = 1 1 0 1 1 0
a3 = 1 0 1 1 0 1
   + ___________
     2 1 1 2 1 1 (a2 + a3)
b0 =           1 (choose these b values)
b1 =         1 0
b3 =     1 0 0 0
b4 =   1 0 0 0 0
   + ___________
     2 2 2 2 2 2
```

In general, we have $k$ vertices in a vertex cover.
1. Choose corresponding $a_i$ values. The sum of these is $k$ followed by some sequence of 1s and 2s.
  - 1 means the vertex is incident with one vertex in the cover
  - 2 means the vertex is incident with 2 vertices in the cover
  - etc
2. Choose appropriate $b_j$ values to bring the sum to $k222...2 = W$

#### Yes mapping to yes
Suppose we have a subset of the $a_i$s and $b_j$s whose sum is $k222...2$. We need to show that $G$ has a vertex cover of size $k$. Because each $a_i$ starts with a 1, exactly $k$ of the $a_i$s must have been chosen in order to get a $k$ in the first column. Then, consider the corresponding vertices in the graph.
- Suppose the vertices don't make a cover. That means there exists some edge $e_j$ that is not incident with any of these vertices. So, the sum of those chosen $a_i$s will have a zero in it: $k( ... 0 ... )$
- Even if we include every $b_j$, we can't change this 0 to a 2, since we can only increase it by 1.
- This is a contradiction, so it must be precisely a vertex cover.

### Subset sum to 0-1 Knapsack
The instance of subset sum is represented with sizes $s_1, ..., s_n$ and target size $T$. In 0-1 Knapsack, use the sizes as **both** the item weights and profits, and $T$ as **both** the knapsack capacity and target profit.

We now know that $\sum x_i s_i \le T$ for the weights, and $\sum x_i s_i \ge T$ for the profits.

#### Yes mapping to yes
Suppose $sum_{i \in J} s_i = T$.

Define $X_i = 1$ if $i \in J$ and $X_i = 0$ otherwise.

Then, $\sum x_i s_i = T$, so $\sum x_i s_i \le T$ for the weights, and $\sum x_i s_i \ge T$ for the profits.

In the other direction:

$\sum x_i s_i \le T$ for the weights, and $\sum x_i s_i \ge T$ for the profits. So, $\sum x_i s_i = T$.

Define $J = \{i : x_i = 1\}$. Then, $\sum_{i \in J} s_i = T$.

### Hamiltonian Cycle to TSP-Dec
A Hamiltonian cycle instance has a graph $G$ with $n$ vertices. For TSP-Dec, use the complete graph on the same $n$ vertices (Every pair is now joined by an edge.) Then, define:
$$w(uv) = \begin{cases}
1, & uv \in E\\
2, & uv \notin E
\end{cases}$$

Our target path length $T$ will be defined as $n$.

<img src="img/ham.png" />
