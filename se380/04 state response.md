# State Response
$$\begin{align}
\dot{x}&=Ax\\
x &\in \mathbb{R}^n\\
A &\in \mathbb{R}^{n \times n}\\
x(0) &= x_0 \in \mathbb{R}^n \text{ (initial condition) }\\
\end{align}$$

Recall:
1. When $n=1$ (A is scalar), the solution is $x(t)=e^{tA}x_0$
2. Taylor series expansion of $e^{At}=1 + At + \frac{(At)^2}{2!} + ...$

Motivated by 1 and 2, define the **matrix exponential**:
$$e^A := I + A + \frac{A^2}{2!} + ...$$

### e.g. 3.1.1
$$\begin{align}
A &= \begin{bmatrix}0 & 0 \\ 0 & 0\end{bmatrix}\\
\Rightarrow e^A &= I + 0 + 0 + ...\\
&= \begin{bmatrix}1 & 0 \\ 0 & 1\end{bmatrix}\\
\end{align}$$

### e.g. 3.1.2
$$\begin{align}
A &= \begin{bmatrix}1 & 0 \\ 0 & 2\end{bmatrix}\\
\text{For a diagonal matrix:}\\
A^k &= \begin{bmatrix}1^k & 0 \\ 0 & 2^k\end{bmatrix}\\
\Rightarrow e^A &= I + \begin{bmatrix}1 & 0 \\ 0 & 2\end{bmatrix} + \begin{bmatrix}1^2 & 0 \\ 0 & 2^2\end{bmatrix} + ...\\
&= \begin{bmatrix}e^1 & 0 \\ 0 & e^2\end{bmatrix}\\
\end{align}$$

### e.g. 3.1.3
$$
A = \begin{bmatrix}0 & 1 & 0 \\ 0 & 0 & 1 \\ 0 & 0 & 0\end{bmatrix}\\
$$
Check that $A^3=0$ (i.e. $A$ is nilpotent).
$$
e^A = I + A + \frac{A^2}{2} = \begin{bmatrix}1 & 1 & \frac{1}{2} \\ 0 & 1 & 1 \\ 0 & 0 & 1\end{bmatrix}\\
$$

Replace $A$ with $tA$ to get a function of time:
$$e^{At} = I + tA + \frac{t^2A^2}{2!} + ...$$

**Theorem:** The unique solution to $\dot{x}=Ax, \quad x(0)=x_0$ is $x(t)=e^{tA}x_0$.

## Using Laplace
Take the Laplace transform of $\dot{x}=Ax$ without assuming $x(0)=0$:
$$\begin{align}
sX(s) - x(0) &= AX(s)\\
X(s) &= (sI-A)^{-1} x(0)\\
\end{align}$$

**Conclusion**: $e^{At}$ and $(sI-A)^{-1}$ are Laplace transform pairs.

### e.g.
$$\begin{align}
A &= \begin{bmatrix}0&1&0\\0&0&1\\0&0&0\end{bmatrix}\\
sI-A &= \begin{bmatrix}s&-1&0\\0&s&-1\\0&0&s\end{bmatrix}\\
(sI-A)^{-1} &= \frac{\text{adj}(sI-A)}{\det(sI-A)}\\
&= \frac{1}{s^3} \begin{bmatrix}s^2&s&1\\0&s^2&s\\0&0&s^2\end{bmatrix}\\
e^{tA} &= \mathcal{L}^{-1} \left\{ (sI-A)^{-1} \right\}\\
&= \begin{bmatrix}1&t&\frac{t^2}{2}\\0&1&t\\0&0&1\end{bmatrix}, \quad t \ge 0\\
\end{align}$$

## Total Response
The solution of $\dot{x}=Ax+Bu$, $y=Cx+Du$, $x(0)=x_0$ is:
$$x(t) = \underbrace{e^{At}x_0}_\text{initial state response} + \underbrace{\int_0^t e^{A(t-\tau)} Bu(\tau)d\tau}_\text{forced response}$$
$$Y(t)=Cx(t)+Du(t)$$

In SISO (single-input-single-output) special case where $x(0)=0$, we get the familiar result:
$$\begin{align}
y(t)&=(g * u)(t) = \int_0^t g(t-\tau)u(\tau)d\tau\\
g(t)&=Ce^{At}B 1(t) + D\delta(t)
\end{align}$$
Where $1(t)$ is the unit step function and $\delta(t)$ is the unit impulse.

## Stability of state-space models
The system $\dot{x}=Ax$ is **asymptotically stable** if $x(t) \rightarrow 0$ for any initial condition.

$e^{At} \rightarrow 0$ if and only if all the eigenvalues of $A$ have a negative real part.

### e.g. 3.4.2
$$\begin{align}
M\ddot{q}&=u-Kq \quad \text{(mass-spring)}\\
x &= \begin{bmatrix}x_1\\x_2\end{bmatrix} := \begin{bmatrix}q\\\dot{q}\end{bmatrix}\\
\dot{x} &= \begin{bmatrix}0&1\\\frac{-k}{M}&0\end{bmatrix}x + \begin{bmatrix}0\\\frac{1}{M}\end{bmatrix}u\\
\\
\text{Using } M=1, k=4:\\
e^{At} &= \begin{bmatrix}\cos 2t&\frac{1}{2}\sin 2t\\-2\sin 2t & \cos 2t\end{bmatrix}\\
\end{align}$$

Since $e^{At}$ does not approach 0 as $t$ grows large, the system is not asymptotically stable.

Let's double-check this using the eigenvalues. Solve for $s$ such that $\det(sI-A)=0$.
$$\begin{align}
A &= \begin{bmatrix}0 & 1 \\ -4 & 0 \end{bmatrix}\\
\det \begin{bmatrix}s & -1 \\ 4 & s\end{bmatrix} &= 0\\
s^2 + 4 &= 0\\
s &= \pm 2j
\end{align}$$
The system is therefore not asymptotically stable since it has at least one eigenvalue (in this case, it has two) with a non-negative real part.

If we introduce friction:
$$\begin{align}
\ddot{q} &= u-4q-\dot{q}
\end{align}$$

Check that it is asymptotically stable (it should be)

## Bounded input, bounded output stability
$$
Y(s)=G(s)U(s) \quad \text{or} \quad y(t)=(g*u)(t), g(t)=\mathcal{L}^{-1}\left\{G(s)\right\}\\
$$

A signal $u(t)$ is **bounded** if there exists a constant $b$ such that, for all $t \ge 0$, $|u(t)| \le b$.

For example, $\sin t$ is bounded by $b=1$.

If $u$ is bounded, $||u||_\infty$ denotes teh **least upper bound**. For example, for $\sin t$, then $|u(t)| \le 10$ and $u$ is bounded.
