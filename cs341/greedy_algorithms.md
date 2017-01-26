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

Sort by start time of the intervals
