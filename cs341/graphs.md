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

- If $u$ is discovered before $v$, then $dist[u] \le dist[v]$
- If $\{u,v\}$ is **any edge**, then $|dist[u]-dist[v]| \le 1$
- $dist[v]$ is the length of the **shortest path** from $s$ to $v$


## Depth-first Search
- Uses a stack or recursion
- Looks at most deeply nested children first, then parents
