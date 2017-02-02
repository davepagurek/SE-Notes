# Greedy Algorithms

- **Feasible solution**: for any problem input $I$, $feasible(I)$ is the set of solutions for $I$ that satisfy the constraints
- **Objective function**: A profit or cost function to measure feasible solutions
- **Optimal solution**: The feasible solution with the highest profit or minimized cost


## Method
### Partial solutions
Given a problem instance $I$, you can write a feasible solution $X$ as a tuple $[x_1, x_2, ..., x_n]$ for some $n$ where $x_i \in X \forall i$. A tuple where $i \lt n$ is a **partial solution** if no constraints are violated.

### Choice set
For a partial solution $X$, we can define a **choice set**:
$$choice(X) = \{y \in X: [x_1, ..., x_i, y]\ \text{ is a partial solution}\}$$

### Local evaluation criterion
For any $y \in X$, $g(y)$ measures the cost or profit in a partial solution

## Extension
Choose $y \in choice(X)$ such that $g(y)$ is as small or large as possible. Update $x$ to add $y$ as the $i+1$th tuple.

### Greedy algorithm
Start from an empty partial solution, and extend it until a feasible solution $X$ is constructed. This may not be optimal.

## Features
- no lookahead or backtracking
- Only one feasible solution generated


### e.g. interval selection
Let a set $A = \{A_1, ..., A_n\}$ be a set of intervals, where each $A_i$ is of the form $[s_i, f_i)$, where $s_i$ is a start time and $f_i$ is a finish time.

Find a subset $B \subseteq A$ of pairwise distinct intervals that maximizes $|B|$.

#### Possible strategies
1. Choose the earliest starting interval disjoin from previously chosen ones (local evaluation criterion is $s_i$)
2. Choose the interval of minimum duration that is disjoint from all previously chosen intervals (local evaluation criterion is $f_i - s_i$)
3. Choose the earliest finishing interval disjoint from all previously chosen intervals (local evaluation criterion is $f_i$)

**Strategy 3** is optimal, if we pre-sort the intervals. The $\Theta(n\log n)$ sort dominates the $\Theta(n)$ iteration.

e.g.
```
GreedyIntervalSelection(A) {
  A.sort(x => x.f) // by finish, so i < j => A[i].f < A[j].f
  B = [A[0]]
  for interval in A[1...A.length] {
    if interval.start >= B.last.finish {
      B.push(interval)
    }
  }
}
```

#### Inductive proof
Let $A$ be the intervals $[A_1, A_2, ..., A_n]$ such that $f_1 \le f_2 \le ... \le f_n$.
Let $B$ be the greedy solution. $B=[A_{i_1}, A_{i_2}, ..., A_{i_k}]$ where $i_1 \lt i_2 \lt ... \lt i_k$
Let $O$ by any optjmal solutjon $O = [A_{j_1}, A_{j_2}, ..., A_{j_l}]$ where $j_1 \lt j_2 \lt ... \lt j_l$

We want to prove that $k=l$ and that $f_{i_1} \le f_{j_1} \land f_{i_2} \le f_{j_2} \land ... \land f_{i_k} \le f_{j_l}$ (note that $k \le l$). In this statement, the greedy algorithm "stays ahead" for every step.

**Base case:** $f_{i_1} \le f_{j_1}$
The greedy algorithm begins by choosing the interval with the earliest finishing time possible.

**Inductive assumption:** $f_{i_{m-1}} \le f_{j_{m-1}}$

**Inductive step:** We want to prove that $f_{i_m} \le f_{j_m}$
Assume that $f_{i_m} \gt f_{j_m}$.
Then, $s_{j_m} \ge f_{j_{m-1}}$. By the inductive assumption, this must also be $\ge f_{i_{m-1}}$. $A_{j_m}$ would be selected by the greedy algorithm instead of $A_{i_m}$ because it has an earlier finishing time. This is a contradiction, so we have shown that $f_{i_m} \le f_{j_m}$.

By induction, we have proven $f_{i_1} \le f_{j_1} \land f_{i_2} \le f_{j_2} \land ... \land f_{i_k} \le f_{j_l}$ and $k \le l$.

Now, assume $k \lt l$. We know that for every step, the greedy algorithm is headead of $O$ from the previous induction. This means the $k+1$th element in $O$ is not in the greedy solution $B$. Since $f_{j_k} \gt f_{i_k}$, $s_{j_{k+1}}$ must also be $\ge f_{j_k} \ge f_{i_k}$ and would therefore have been included in the greedy solution. This is a contradiction, so $k=l$.

#### Wizardly proof
**Claim**: There is no interval in the optimal solution $O$ that lies between two consecutive values in the list of values $f_{i_0}, f_{i_1}, ..., f_{i_k}$.

Assume that one did exist. Then, its finishing value would have been smaller than the finishing value of the next item in the greedy solution, and the greedy algorithm would have selected it instead. Since it didn't, it must not exist. Therefore, every interval in the optimal solution $O$ contains a point in the set $\{f_{i_1}, ..., f_{i_k}\}$. Therefore there must be $k$ intervals in the optimal solution.

### e.g. interval colouring
Given another set $A$ of intervals, a $c$-colouring is a mapping $col: A \rightarrow \{1,...,c\}$ assigns each interval a colour such that two intervals receiving the same colour are always disjoint. Find a $c$-colouring of $A$ that minimizes $c$.

We will colour the $i+1$st interval with **any permissible colour**. If none exists, we will add a new colour. The question is, what order do we consider the intervals?

Sort by start time of the intervals in increasing order.

#### Proof
Let $D$ be the number of colours the algorithm uses. Suppose $[s_i, f_i)$ is the first interval to use colour $D$. That means that at this point, we have $D$ mutually overlapping intervals containing the point $s_i$. Therefore we need at least $D$ colours.

#### Complexity
- Preprocessing is a sort of $\Theta(n\logn)$
- Loop through each item is $\Theta(n)$ operations
- Finding a colour for each item is $O(nD)$ where $D$ is the number of colours used. $D \in O(n)$, so complexity is $O(n^2)$.


#### Complexity for a better algorithm
- keep track of finishing times in a min heap
- when we colour an interval, insert its finishing time into the priority queue
- check min finishing time in the priority queue, and if it is $\le s_i$, delete the min
- The colour finding is now $O(n\log D)$
- overall runtime is now $O(n\log n)$


### Knapsack problem
Profits $P$ and weights $W$ and a capacity $M$ exist. An $n$-tuple $X$ exists where $\sum_{i=1}^n w_i x_i \le M$.
- In the 0-1 Knapsack problem, we require that $x_i \in \{0, 1\}, 1 \le i \le n$.
- In the Rational Knapsack problem, we require that $x_i \in \mathbb{Q}$ and $0 \le x_i \le 1, 1 \le i \le n$.

Find a solution $X$ that maximizes $\sum_{i=1}^n p_i x_i$.

- Rational knapsack problem is easy to solve with a greedy algorithm.
- 0-1 Knapsack problem is NP-hard.


#### Strategy
- Sort by profit divided by weight
- If you can fit the whole item, add it
- otherwise, add as much of it as you can (this will be the last item)

#### Proof
Assumption: $\frac{p_1}{w_1} \gt \frac{p_2}{w_2} \gt ... \gt \frac{p_n}{w_n}$

Let the greedy solution by $X$. Let the optimal solution be $Y$. We will prove that $X=Y$ by contradiction. Assume $X \ne Y$.

Let $j$ be the first index such that $x_j \ne y_j$. We know that $x_j$ will be greater than $y_j$ because the greedy algorithm chooses the maximum value for $x_j$. Pick an index $k \gt j$ such that $y_k \gt 0$. $k$ exists because the greedy solution can't be better than the optimal solution. So, $x_j \gt y_j$ and $k_y \gt 0$ ($k \gt i$).

Idea: alter $Y$ to become a new $Y'$ with a higher profit than $Y$. Let $\delta=\min\{w_ky_k, w_j(w_j-y_j)\}$. Note that $\delta \gt 0$.

Let $y_k' = y_k - \delta/w_k$, and let $y_j'=y_j+\delta/w_j$. We now need to show that $y_j' \ge 1$ and that $k_k' \ge 0$.

$$y_j' = y_j + \frac{\delta}{w_j} \le y_j + \frac{w_j(x_j-y_j)}{w_j} = x_j \le 1$$
$$y_k' = y_k - \frac{\delta}{w_k} \ge y_k - \frac{w_ky_k}{w_k} = 0$$
$$Weight(Y') = Weight(Y) + \frac{\delta w_j}{w_j} - \frac{\delta w_k}{w_k} = Weight(Y)$$

$$\begin{align*}
Profit(Y') &= Profit(Y) + \frac{\delta p_j}{w_j} - \frac{\delta p_k}{w_k}\\
&= Profit(Y) + \delta\left(\frac{p_j}{w_j}-\frac{p_k}{w_k}\right) \\
&\gt Profit(Y)\\
\end{align*}$$
This is a contradiction.

### Coin changing
A list of coin denominations $D$ exists, and a positive target sum $T$. Find an $n$-tuple of non-negative integers sich that $T=\sum_{i=1}{n} a_i d_i$ such that the number of coins $n$ is minimized.

Strategy: Sort by size descending. Take as many as you can of the largest, then as many as you can of the next largest, etc, until you reach the target sum. **This doesn't work for all coin denominations.**

### Stable Marriage Problem
A set of men $M$ and a set of women $W$ exist. Each man has a preference ranking for each of the women, and each woman has a ranking for each of the men. Find a matching of the $n$ men with the $n$ women such that there does not exist a couple $(m_i, w_i)$ wh are not engaged to each other, but prefer each other to their existing matches. A matching with this property is called a **stable matching**.

#### Gale-Shapley Algorithm
- Men propose to women
- If a woman accepts the proposal, then the couple is engaged
- an unmatched woman must accept a proposal
- If an engaged woman receives a proposal from a man whom she prefers, she can cancel her existing engagement
- If an engaged woman receives a proposal from a man but she prefers the current match, the proposal is rejected
- Engaged women never become unengaged
- A man might make a number of proposals (up to $n$). The order is determined by the man's preference list

#### Proof of correctness
Assume there is an instability, so that $m_i$ ranks $w_l \gt w_j$ and $w_l$ ranks $m_i \gt m_k$, but $m_i$ is matched with $w_j$ and $m_k$ is matched with $w_l$.

We know $m_i$ must have proposed to $w_l$ before he proposed to $w_j$ due to the algorithm. What happened in this proposal?
1. $w_l$ rejected $m_i$
  - In this case, $w_l$ rejected the proposal only if she had an offer from someone she liked better. She would not have then accepted a proposal from $m_k$, who she likes less.
2. $w_l$ accepted the proposal, but accepted another one later.
  - In this case, it would have only happened if $w_l$ later accepts a proposal from someone she prefers more than $m_i$. She would not accept a proposal from someone she likes less, such as $m_k$.
