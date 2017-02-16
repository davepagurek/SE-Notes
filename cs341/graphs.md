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
