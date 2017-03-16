# Graph Algorithms
In general, we call the number of vertices $n$ and the number of edges $m$. Edges $E$ consist of sets of two vertices $\{u,w\}, u \ne w$. The number of edges $m \le \binom{n}{2}$. A graph can be defined as vertices and edges, $G=(V,E)$.

A **Directed graph** or **digraph** has edges (called **arcs** in this case) as an ordered pair $(u,w)$ instead of a set, with the arrow going from the tail $u$ to the head $w$.

$m \le n^2$.

## Adjacency Matrices
The adjacency matrix of a graph $G$ is an $n \times n$ matrix $A=(a_{u,v})$, which is indexed by $V$, such that:
$$a_{u,v} = \begin{cases}
1, &\{u,v\} \in E\\
0, &\text{otherwise}
\end{cases}$$

There are exactly $2m$ etries in $A$ equal to 1.

If $G$ is a digraph, then:
$$a_{u,v}=\begin{cases}
1, &(u,v) \in E\\
0, &\text{otherwise}
\end{cases}$$

Storage requirement: $O(n^2)$.

### Properties
- Every element in the matrix is either 0 or 1 (are these vertices connected or not)
- In undirected graphs, the matrix is symmetric ($u$ is connected to $v$ and $v$ is connected to $u$ for an edge $uv$)
- For undirected graphs, diagonal entries are all 0 because a vertex can't be connected to itself by an edge. We allow loops in directed graphs.
- In undirected graphs, the number of 1s int he graph is equal to $2m$. In directed graphs, the number of 1s is equal to $m$.

## Adjacency Lists
The adjacency list of $G$ is $n$ linked lists. For every $u \in V$, there is a linked list named $Adj[u]$.

For every $v \in V$ such that $uv \in E$, there is a node in $Adj[u]$ labelled $v$ (for both graphs and digraphs).

In an undirected graph, every edge $uv$ corresponds to a node in two linked lists: for edge $uv, \exists v \in Adj[u]$ and $\exists u \in Adj[v]$.

In a directed graph, every edge corresponds to a node in only one adjacency list.

## Breadth-first Search
- Uses a queue
- Looks at elements in one layer of the graph at a time before going to the next layer down (visiting the children of the nodes in the previous layer), starting from vertex $s$
- A vertex is white if undiscovered
- A vertex is grey if it has been discovered, but we are still processing its adjacent vertices
- A vertex is black when all adjacent vertices have been process
- If $G$ is connected, every vertex will eventually be black
- When we explore an edge $\{u,v\}$ starting from $u$:
  - if $v$ is white, then $uv$ is a **tree edge** and $\pi[v]=u$ is the **predecessor** of $v$ in the bfs tree
  - otherwise, $uv$ is a **cross edge**
- BFS tree consists of all the tree edges
- every vertex $v \ne s$ has a unique predecessor $\pi[v]$ in the BFS tree

<img src="img/bfs.png" />

### Shortest paths
<img src="img/bfs-shortestpath.png" />

The shortest path from $s$ (the source) to some other vertex $v$:
$v, \pi[v], \pi[\pi[v]], \pi[\pi[\pi[v]]], ...$

Runtime
- We go once through every adjacency list
- The total number of nodes in all the adjacency lists = $2m$
- Complexity is therefore $\Theta(n+2m) = \Theta(n+m)$

#### Proof
##### Lemma 1
If $u$ is discovered before $v$, then $dist[u] \le dist[v]$

Suppose $u$ is discovered before $v$, but $dist[u] \gt dist[v]$. Let $dist[u]=d$, so $dist[v] \le d-1$.

With no loss of generality, choose the first pair of vertices where this happens, so let $\pi[u]=u_1, \pi[v]=v_1$. Then:
$$\begin{align*}
d=dist[u]=dist[u_1]+1 &\rightarrow dist[u_1]=d-1\\
d-1 \ge dist[v]=dist[v_1]+1 &\rightarrow dist[v_1]\le d-2 \lt dist[u_1]
\end{align*}$$

So $v_1$ was discovered before $u_1$. This implies that $Adj[v_1]$ was processed before $Adj[u_1]$. This only happens if $v$ was discovered before $u$. This is a contradiction, so therefore if $u$ is discovered before $v$, then $dist[u] \le dist[v]$.

##### Lemma 2
If $\{u,v\}$ is **any edge**, then $|dist[u]-dist[v]| \le 1$

Suppose $u$ is discovered before $v$ without any loss of generality. Then we are processing $Adj[u]$ when we encounter $v$ in the adjacency list. Then, we have three cases:
1. **$v$ is white.** In this case, $dist[v]=dist[u]-1$.
2. **$v$ is grey.**
3. **$v$ is black.** This can't happen, since it would mean we have already processed the adjacency list for $v$, and therefore would have encountered $u$ in the adjacency list for $v$.

For the second case, let $\pi[v]=v_1$. This tells us that $dist[v]=dist[v_1]+1$ (1). So $v$ was discovered when $Adj[v_1]$ was being processed. Therefore $v_1$ was discovered before  $u$. This tells us that $dist[v_1] \le dist[u]$ (2). Finally, $u$ was discovered before $v$ from our assumption, so Lemma 1 says that $dist[u] \le dist[v]$. (3). From (1), (2), and (3), we can say that $|dist[u]-dist[v]| \le 1$.

##### Theorem
$dist[v]$ is the length of the **shortest path** from $s$ to $v$

Let $\delta(v)$ be the lenfth of the shortest path from $s$ to $v$. We want to prove that $\delta(v) = dist[v]$. We will prove $\delta(v) \le dist[v]$ and $\delta(v) \ge dist[v]$.

Consider the path $v, \pi[v], \pi[\pi[v]], ..., s$. This is a path from $s$ to $v$ having length $dist[v]$. Therefore $\delta(v) \le dist[v]$.

We prove $\delta(v) \ge dist[v]$ by induction in $\delta(v)$.

Base case: $\delta(v) = 0 \rightarrow s=v$. We know $dist[s]=0$, so $dist[v]=\delta(v)$.

Assumption: Suppose the inequality is true for $\delta(v) \le d-1$.

Consider $v$ such that $\delta(v)=d$. Let $S, v_1, v_2, ..., v_{d-1}, v_d = v$ be the shortest path from $s$ to $v$ (length is $d$). The section from $s$ to $v_{d-1}$ is a shortest path. By induction, $d-1=\delta(v_{d-1})=dist[v_{d-1}]$.


### Bipartite graphs
A graph is **bipartite** if the vertex set can be partitioned as $V=X \cup Y$ such that all the edges have one end point in $X$ and one in $Y$. This is the case if and only if there is not an odd cycle in the graph.

We can use BFS to test if a graph is bipartite.
- If we enounter an edge $\{u,v\}$ with $dist[u]=dist[v]$, then $G$ os not bipartite, whereas
- if no such edge is found, then define $X = \{u : dist[u] \text{ is even}\}$ and $Y = \{u : dist[u] \text{ is odd}\}$, and $X,Y$ is the bipartition.

Suppose $G$ is not bipartite (and assume it is connected). Let $s$ be any vertex.
Define $X=\{v : dist[v] \text{ is even}\}, Y=\{v: dist[v] \text{ is odd}$.
Since $G$ is not bipartite, there is an edge $uv$ where $u,v \in X$ or $u,v \in Y$. There is an edge $uv$ where $dist[u]$ and $dist[v]$ are both even or both odd. Since $|dist[u]-dist[v]| \le 1$, we have $dist[u]=dist[v]$. How do we find an odd cycle?

Given a connected graph, we can use BFS to either:
1. Find a bipartition $X,Y$ ($G$ is bipartite), or
2. Find an odd length cycle ($G$ is not bipartite)

Run BFS. IF we ever encounter $v \in Adj[u]$ where $dist[u] = dist[v]$, then we can construct an odd cycle. If this doesn't happen, then $X,Y$ will be a bipartition.

## Depth-first Search
- Uses a stack or recursion
- Looks at most deeply nested children first, then parents

<img src="img/dfs.png" />
<img src="img/dfsvisit.png" />

### Classification of edges
Given $uv$:
- **Tree edge**: $u=\pi[v]$
- **Forward edge**: not a tree edge, and $v$ is a descendant of $u$ in a tree in the dfs forest
- **Back edge**: $u$ is a descendant of $v$ in a tree in the dfs forest
- **Cross edge**, otherwise

### Properties
<img src="img/discovery_times.png" />
Note that the intervals $(d[u], f[u])$ and $(d[v], f[v])$ never overlap. Two intervals are either disjoint or nested. This is called the **parenthesis theorem.**

### Topological orderings
A directed graph $G$ is a **directed acyclic graph** (DAG) if $G$ contains no directed cycle.

A directed graph $G=(V,E)$ has a **topological ordering**, or **topological sort** if there is a linear ordering of all the vertices in $V$ such that $u \lt v$ whenever $uv \in E$.

- A DAG contains a vertex of indegree 0 (has no directed edges going into it)
- A directed graph $G$ has a topological ordering iff it is a DAG
- A directed graph $G$ is a DAG iff a DFS of G has no back edges
- If *uv* is an edge in DAG, then a DFS of $G$ has $f[v] \lt f[u]$

**Lemma.** A DAG contains a vertex of indegree 0.

Suppose there are no vertices od indegree 0. Pick any vertex $v_1$. There must always be an edge going into it, so there is an edge $v_2 v_1$ There is also an edge $v_3 v_2$. You can keep finding edges like this infinitely, and since there are not infinite points, there must therefore be a repatition. Therefore there is a directed cycle in the graph.

**Theorem.** A directed graph $D$ has a topological ordering iff it is a DAG.

Suppose $D$ has a directed cycle. Then, $v_1 \lt v_2 \lt ... \lt v_j \lt ... \lt v_!$. This is not a linear ordering.

Suppose $D$ is a DAG. Let $v_1$ be a vertex of indegree 0. This will be the first vertex in the ordering.
- Delete edges incident with $v_1$
- get a smaller DAG $D_1$ on $n-1$ vertices
- choose a vertex in $D_1$ with indegree 0
- repeat

<img src="img/topological_ordering.png" />

<img src="img/topological_ordering2.png" />

We find a topoligical sort "efficiently" ($O(m+n)$) without using DFS using Kahn's Algorithm.
Using an adjacency list representation:
1. Compute $deg(V)$ for all $v$ (indegrees)
2. For all $v$ with $deg(v)=0$, put $v$ in a queue $Q$
3. Repeat $n$ times:
  a. If $Q$ is empty, quit, because $G$ is not a DAG
  b. Let $v$ be the first vertex in $Q$. Delete it, and output $v$
  c. $\forall w \in Adj(v), deg^{-1}(w) = deg^{-1}(w)-1$. If $deg^{-1}(w)=0$, then insert $w$ into $Q$.

**Lemma.** $G$ is a DAG iff there are no back edges in a DFS.
**Proof.** A back edge implies a directed cycle. Conversely: Assume there is a directed cycle.
Let $v_1v_2, ..., v_lv_1$ be a directed cycle. Suppose $v_1$ is disconnected first. We calim $v_lv_1$ is a back edge: $d(v_l) \gt d(v_1)$, so from the chart, $v_lv_1$ is a back edge or a cross edge. But can it be a cross edge? If it was, then $v_1$ would be black when $v_lv_1$ is processed (from the chart). But $v_1$ is not black at the time, it's grey, so $v_lv_1$ is a backk edge.

Given that there are no back edges, the topological ordering is given by the vertuces in reverse order of finishing time. Why? Look at the chart: for any edge $uv$ that is not a back edge, $f[u] \gt f[v]$ ($f$ is finishing time).

### Strongly connected components
For two vertices $x$ and $y$ of digraph $G$, define $x \sim y$ as $x=y$ or $x \ne y$ and there exists directed paths from $x$ to $y$ and $y$ to $x$.

The relation $~$ is an **equivalence relation.** The strongly connected components of $G$ are the equivalence classes of vertices defined by the relation $\sim$.

The **component graph** of $G$ is a directed graph whose vertices are strongly connected components of $G$. There is an arc from $C_i$ to $C_j$ iff there is an arc in $G$ from some $v \in C_i$ to some $u \in C_j$. For a stringly connected component $C$, define $f[C]=\max\{f[v] : v \in C\}$ and $d[C]=\min\{d[v] : v \in C\}$

Useful facts:
- Component graph of $G$ is a DAG
- If there is an edge $C_iC_j$ in the component graph, then $f(C_i) \gt f(C_j)$.

#### Given a directed graph, find its strongly connected components.
First consider the **undirected** version of the problem. We can use DFS to solve the undirected problem. Each initial call to DFSVisit will "explore" a connected component. THe recursive calls to DFSVisit are the other vertices in the same component.

**Lemma.** If there is an edge $C_iC_j$ in the component graph, then $f(C_i) \gt f(C_j)$.

**Proof.**
Case 1: $d(C_i) \lt d(C_j)$
Case 2: $d(C_i) \gt d(C_j)$

For case 2, we explore everything in $C_j$ before any vertex in $C_i$ is explored. So, $f(C_i) \gt d(C_i) \gt f(G_j)$.

For case 1, let $u \in C_i$ be the first discovered vertex. All vertices in $C_i \cup C_j$ are reachable from $u$, so they are all descendants of $u$ in the DFS tree. So $f(v) \lt f(u) \forall v \in C_i \cup C_j, u \ne v$, and therefore $f(C_i) \gt f(C_j)$.

**Algorithm**

1. Perform DFS of $G$. Record the finishing times $f[v] \forall v \in G$
2. Construct digraph $H$ from $G$ by reversing the direction of all edges in $G$
3. Perform a DFS of $H$, considering vertices in **decreasing order** of the values $f[v]$ from step 1
4. The strongly connected components of $G$ are the trees in the DFS forest constructed in 3

## Minimum Spanning Trees (Prim's Algorithm)
- A **tree** is a connected graph that is acyclic.
- Removing any edge from a tree disconnects the tree
- Breaking any edge from a cycle $G$ in a graph $G$ cannot disconnect $G$
- Any tree with $n$ vertices contains $n-1$ edges
- A minimum spanning tree takes a undirected and connected graph $G(V,E)$ and arbitrary edge weights and outputs a tree $T^*$ of $V$ such that $w(T^*)$ is minimized

### Algorithm
- Start with a vertex
- At each step, add the vertex that costs the least to get to from the current set of visited vertices

### Implementation
- Keep each vertex $v$ in a priority queue $R$ using the min distance $v$ has to $L$

```
def prim(G(V,E), weights) {
  choose any s in V
  let l = {S}
  let r = V-{S}
  let minWeightEdge be a priority queue storing, for all v in R, the weight of the edge (u,v) connecting v to l
  T = {}

  for i in 1..n {
    (v, (u,v)) = minWeightEdge.extractMin()
    remove v from r
    add v to l
    add (u,v) to T
    for each (v,z) in E such that z in R {
      minWeightEdge.decrementKey(z, w[v,z])
    }
  }

  return T
}
```

A **cut** on an edge divides a graph into sections if that edge was removed.
- A graph $G(V,E)$ is not connected if $\exists$ a cut $(X,Y)$ with no crossing edges
- Given a cut $X,Y$ and a cycle $C$, if $C$ contains an edge $e$ crossing $X,Y$, then there exists $e' \ne e$ part of $C$ that is also crossing $(X,Y)$
- If $\exists$ a cut $(X,Y)$ such that only one edge $e$ is crossing $(X,Y)$, then $e$ cannot be part of a cycle

Kruskal's Algorithm is another algorithm to solve this

## Single Source Shortest Path
Looking for the path of minimum weight. **Dijkstra's Algorithm** solves this when there are no negative weight edges.
- $S$ is the set of vertices you know the shortest path to. Initially just path to the starting vertex (no edge)
- If $v \in S$, $D[v]$ is the weight of the shortest path $P_v$ from $u_0$ to $v$ and all vertices in $P_v \in S$.
- If $v \notin S$, $D[v]$ is the weight of the shortest path $P_v$ from $u_0$ to $v$ and all interior vertices in $P_v \in S$.
- At each stage, we choose $v \in V \setminus S$ so that $D[v]$ is minimized, and then we add $v$ to $S$

Bellman-Ford Algorithm (works with negative edges but not negative weight cycles)
- repeat $n-1$ times:
  - Relax each edge in the graph

## Shortest path in DAG
Since there are no directed cycles, there are no negative weight directed cycles since there are no directed cycles
1. Find a topological ordering of the directed graph $G$ ($O(m+n)$). $v_1, v_2, ..., v_n$ is the ordering.
2. We find shortest path from the source $v_1$. If we want to start at a later vertex, delete all vertices before it in the ordering.
3. For $i$ in 1 to $n$, look at the vertices in $Adj[v_1]$ and "relax" them

## All Pairs Shortest Paths
In a directed graph $G=(V,E)$, and a weight matrix $W$ where $W[i,j]$ is the weight of edge $ij$, for all pairs of vertices $u,v, \in V, u \ne v$, find a directed path $P$ from $u$ to $v$ such that:
$$w(P) = \sum_{ij \in P} W[i,j]$$

### Algorithms

#### Using Bellman-Ford
Run Bellman-Ford algorithm $n$ times, once for each source. This is $O(n^2m)$.

#### Slow Shortest Path
Let $L_m[i,j]$ to be the minimum weight of an $(i,j)$ path having at most $m$ edges. (We will look at $L_{n-1}[i,j]$ to find the answer.) $W[i,j]=0$ if $i=j$.

Initially, $L_1 = W$ (matrix of edge weights).

Let $P$ be the min-weight $(i,j)$ path with less than or equal to $m$ edges. Let $k$ be the predecessor of $j$ on $P$. Let $P'$ be the $(i,k)$-path (delete $j$ from $P$). $P'$ is a **min-weight** $(i,k)$ path having $\le m-1$ edges.

This gives us the recurrence relation:
$$L_m[i,j] = \min{L_{m-1}[i,k]+w[k,j] : 1 \le k \le n}$$

#### Slightly less slow
This is called "successive doubling"

The idea is to compute $L_1, L_2, ..., L_{2^k}$ where $2^k \ge n-1$ and each depends on the previous. There are then $\Theta(\log n)$ matrices to compute.

$$L_m[i,j] = \min{L_\frac{m}{2}[i,k]+L_\frac{m}{2}[k,j] : 1 \le k \le n}$$

#### Floyd-Warshall
Let $D_m[i,j]$ be the min weight of an $(i,j)$-path where interior vertices are in $\{1,...,m\}$. We want to compute $D_n$.

Initially, $D_0 = W$.

$$D_m[i,j] = \min{D_{m-1}[i,k], D_{m-1}[i,m], D_{m-1}[m,j]}$$

Is $D_{m-1}[i,m] + D_{m-1}[m,j]$ the minimum weight path that contains $m$ as an interior vertex? $p_1, p_2$ are simple paths (no negative weight cycles.) Are $p_1, p_2$ disjoint?
- If $p_1, p_2$ are **not disjoint**, we get a lower weight path than $D_{m-1}[i,m] + D_{m-1}[m,j]$, then there is a negative weight cycle. This is a contradiction.

e.g.
<img src="img/warshall-example.png" />

$$D_0 = \begin{bmatrix}
0 & 3 & \infty & \infty \\
\infty & 0 & 12 & 5 \\
4 & \infty & 0 & -1 \\
2 & -4 & \infty & 0
\end{bmatrix}$$

$$\begin{align*}
D_1[3,2]&=\min\{D_0[3,2], D_0[3,1] + D_1[1,2]\}\\
&= \min\{\infty, 4+3\}\\
&= 7
\end{align*}$$

$$D_1 = \begin{bmatrix}
0 & 3 & \infty & \infty \\
\infty & 0 & 12 & 5 \\
4 & [7] & 0 & -1 \\
2 & -4 & \infty & 0
\end{bmatrix}$$

$$D_2 = \begin{bmatrix}
0 & 3 & [15] & [8] \\
\infty & 0 & 12 & 5 \\
4 & 7 & 0 & -1 \\
2 & -4 & [8] & 0
\end{bmatrix}$$

$$D_3 = \begin{bmatrix}
0 & 3 & 15 & 8 \\
[16] & 0 & 12 & 5 \\
4 & -7 & 0 & -1 \\
2 & -4 & 8 & 0
\end{bmatrix}$$

$$D_4 = \begin{bmatrix}
0 & 3 & 15 & 8 \\
[7] & 0 & 12 & 5 \\
[1] & [-5] & 0 & -1 \\
2 & -4 & 8 & 0
\end{bmatrix}$$
