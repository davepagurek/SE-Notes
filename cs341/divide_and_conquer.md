# Divide and Conquer algorithms
1. **Divide**: Split the problem up into subproblems
2. **Conquer**: Solve subproblems recursively
3. **Combine**: Merge subproblem solutions into the whole problem solution

## Sloppy and Exact Recurrence Relations
Exact recurrence for mergesort:
$$T(n) = \begin{cases}
T(\lceil\frac{n}{2}\rceil) + T(\lfloor\frac{n}{2}\rfloor) + cn, &n \gt 1\\
d, &n = 1\\
\end{cases}$$

Sloppy recurrence for mergesort, removing floors and ceils:
$$T(n) = \begin{cases}
2T(\frac{n}{2}) + cn, &n \gt 1\\
d, &n = 1\\
\end{cases}$$

These are identical for when $\exists i \in \mathbb{Z} \mid n = 2^i$, and the sloppy recurrence only makes sense in this case.

**Master Theorem** provides the exact solution for $n=2^i$. The **complexity** of this can be extrapolated for all values of $n$, which will have the same growth rate.

### e.g. Max-Min Problem
- **Divide**: Split $A$ into two equal sized subarrays $A_L$ and $A_R$
- **Conquer**: Find the max and min elements of each subarray recursively, returning $max_L, min_L, max_R, min_R$
- **Combine**: Find the total max and min, as the respective max and min of the results from $A_L$ and $A_R$


Recurrence relation:
$$T(n) = 2T\left(\frac{n}{2}\right) + \Theta(1)$$

$T(n) \in Theta(n)$, according to Master Theorem, but we can count exact comparisons, obtaining the sloppy recurrence:
$$C(n) = 2C\left(\frac{n}{2}\right)+2, \quad C(2) = 1$$

When $n$ is a power of 2, the solution is $C(n)=\frac{3n}{2}-2$, so it is optimal for these values of $n$.


### e.g. Non-dominated pairs
Given two points $(x_1, y_1), (x_2, y_2)$, we say $(x_1, y_1)$ dominates $(x_2, y_2)$ if $x_1 \ge x_2 \land y_1 \ge y_2$. Given a set of points, find all the points that are not dominated by any other point in the set.

- Pre-sort the points in $S$ by $x$ coordinate.
- **Divide**: Let the first $n/2$ points be $S_1$, and the last be $S_2$.
- **Conquer**: Recursively solve the subproblem defined by the two sets $S_1$ and $S_2$.
- **Combine**: No point in $S_1$ will dominate a point in $S_2$ because of the $x$-sorting. Therefore, we can remove the points in $S_1$ that are dominated by a point in $S_2$, which can be done in $O(n)$ time.


<img src="img/nondominated.png" />


### e.g. Closest pair
Given a set of $Q$ distinct points, find two points $Q[i] = (x,y)$ and $Q[j] = (x', y')$ such that the distance $\sqrt{(x'-x)^2+(y'-y)^2)}$ is minimized.

- Presort the points by $x$ value
- We can then easily divide the points into two groups with the line $x=Q[n/2].x$
- Find the min distances from each of the two groups, take the min of those
- Find candidates from the right of the first group and the left of the second group that might be closer together than this. Sort them by Y value
- If any of those are closer together than the previous min, use that min instead


### e.g. Multiprocessor Multiplication
Given two $k$-bit integers $x$ and $Y$, find the $2k$-bit positive integer $Z$ = $XY$.

<img src="img/multiplication.png" />

