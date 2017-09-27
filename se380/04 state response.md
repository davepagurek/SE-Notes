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

If $u$ is bounded, $||u||_\infty$ denotes the **least upper bound**. For example, for $\sin t$, then $|u(t)| \le 10$ and $u$ is bounded.

A linear, time-independent system is **BIBO stable** if every bounded input produces a bounded output. $||u||_\infty$ is finite $\Rightarrow ||y||_\infty$ is finite.

### e.g. 3.5.1
$G(s)=\frac{1}{s+2}$. The impulse response is $g(t)=\mathcal{L}^{-1}\{G(s)\} = e^{-2t}$. Then:

$$\begin{align}
y(t) &=(g * u)(t)\\
&= \int_0^t e^{-2\tau} u(t-\tau) d\tau\\
\forall t \ge 0:\\
|y(t)|&=\left|\int_0^t e^{-2\tau} u(t-\tau) d\tau\right|\\
&\le \int_0^t \left|e^{-2\tau} u(t-\tau) \right| d\tau\\
&\le \int_0^t e^{-2\tau} d\tau ||u||_\infty\\
&\le \int_0^\infty e^{-2\tau} d\tau ||u||_\infty\\
&= \frac{1}{2} ||u||_\infty\\
\\
||y||_\infty &\le \frac{1}{2} ||u||_\infty\\
\therefore \text{ system is BIBO stable. }
\end{align}$$

## BIBO and poles
**Theorem 3.5.4:** Assume that $G(s)$ is rational and strictly proper. Then the following are equivalent:
1. $G$ is BIBO stable.
2. the impulse response $g(t)=\mathcal{L}^{-1}\{G(s)\}$ is absolutely integrable: $\int_0^\infty |g(\tau)| d\tau \lt \infty$
3. Every pole of $G$ has a negative real part

For example, $\frac{1}{s+1}, \frac{1}{(s+3)^2}, \frac{s-1}{s^2+5s+6}$ are all BIBO stable because their poles have a negative real part.

On the other hand, take $\frac{1}{s}, \frac{1}{s-1}$. These are all BIBO unstable because they have poles which do not have a negative real part. The function $\frac{1}{s}$ is an integrator, so when you give it a constant function as an input, the output will be a ramp, which is unbounded.

**Theorem 3.5.5:** If $G(s)$ is rational and improper (the degree of the numerator is greater than the degree of the denominator), then $G$ is not BIBO stable.

## Stability of state-space models and BIBO stability
$$\begin{align}
\dot{x} &= Ax+Bu\\
y *= Cx+Du\\
\Rightarrow Y(s) &= \left(C(SI-A)^{-1}B + D\right)U(s)\\
&= \left(C\frac{\text{adj}(sI-A)}{\det(sI-A)}B + D\right)U(s)\\
\end{align}$$
This is BIBO stable if all poles in $\Re(s) \lt 0$
This is asymptotically stable if all eigenvalues of $A \in \Re(s) \lt 0$
Eigenvalues of $A$ = roots of $\det(sI-A) \supseteq$ poles of $G(s)=C(sI-A)^{-1}B+D$

### e.g. 3.5.5: mass-spring

$$\begin{align}
\dot{x} &= \begin{bmatrix}0&1\\-4&0\end{bmatrix}x + \begin{bmatrix}0\\1\end{bmatrix}u\\
y &= \begin{bmatrix}1 & 0\end{bmatrix} x
\end{align}$$

Eigenvalues of $A$ are $\pm 2j \Rightarrow$ the system is not asymptotically stable.

$$\begin{align}
\frac{Y(s)}{U(s)} &= \begin{bmatrix}1&0\end{bmatrix}\begin{bmatrix}s&1\\4&s\end{bmatrix}^{-1}\begin{bmatrix}0\\1\end{bmatrix}\\
&=\frac{1}{s^2+4}\\
&=G(s)
\end{align}$$
The system is not BIBO stable based on its poles.

In this example, $C\text{adj}(sI-A)B=1$ and $\det(sI-A)=s^2+4$ are coprime, so eigenvalues of $A$ are the poles of $G$.
