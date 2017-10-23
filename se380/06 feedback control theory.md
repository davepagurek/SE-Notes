# Feedback Control Theory

## 5.1 Closing the loop

### e.g. Pendulum
<img src="img/pendulum2.png" />

Design a controller to keep the pendulum in upright position.

$$\begin{align}
\text{Model:}\\
\dot{x_1}&=x_2\\
\dot{x_2}&= \frac{-g}{l}\sin x_1 + \frac{1}{Ml^2}u\\
y&=x_1\\
\\
\text{Equilibrium config } (\bar{x}, \bar{u}) \text{ at which } y=\pi \text{ is: }\\
(\bar{x}, \bar{u}) &= \left(\begin{bmatrix}\pi\\0\end{bmatrix}, 0\right)\\
\\
\text{Linearization:}\\
\dot{\partial x} &= \begin{bmatrix}0&1\\\frac{g}{l}&0\end{bmatrix} \partial x + \begin{bmatrix}0\\\frac{1}{Ml^2}\end{bmatrix}\partial u\\
\partial x &:= x-\bar{x}\\
\partial u &:= u-\bar{u}\\
\partial y &:= y-\bar{y}\\
&= \begin{bmatrix}1 & 0\end{bmatrix}\partial x\\
\\
\text{Transfer function:}\\
U(s) &:= \mathbb{L}\{\partial u\}, Y(s) := \mathbb{L}\{\partial y\}\\
\\
\text{Poles:}\\
s &= \pm \sqrt{\frac{g}{l}}\\
\\
\frac{Y(s)}{U(s)} = \frac{1}{Ml^2} \frac{1}{s^2 - \frac{g}{l}} =: P(s)\\
\end{align}$$

<img src="img/pendulumblock.png" />

One controller that does the job is $C(s) = 100 + \frac{s+10}{s+20}$, a "lead" controller.

With this choice of controller, the TF from $R$ to $Y$ is:
$$\frac{Y(s)}{R(s)} = \frac{C(s)P(s)}{1 + C(s)P(s)} = \frac{100s+1000}{s^3 + 20s^2 + 99s + 980}$$

Closed-loop poles: $\{-17.5, -1 \pm 7.3j\}$

<img src="img/pendulumpoles.png" />

Closed-loop response is dominated by poles at $s=-1 \pm 7.3j$, making it look like an underdamped second-order system with a lot of overshoot because of the large angle from the x axis.

Input signal: From 0 to 5s, move in the counter-clockwise direction by 1 radian. After 5s, return to the upright position.

<img src="img/pendulumresponse.png" />

To implement the controller, we have the following (A/D means analogue to digital):

<img src="img/controllerimplementation.png" />

In this case, using a "bilinear transformation", we get:

$$u[k] = \frac{1}{2+20T}\left((20T-2)u[k-1]+100(2+10T)e[k]+100(10T-2)e[k-1]\right)$$

Where:
- $T$ is the sampling period
- $e[k]=r[k]-y[k]$

## Stability of feedback systems

<img src="img/stabilitysystem.png" />

Systems
- $C(s)$: controller
- $P(s)$: plant

Signals
- $r(t)$: reference
- $u(t)$: plant input
- $d(t)$: disturbance
- $y(t)$: output
- $e(t)$: tracking error


What does it mean for this system to be stable?

### Internal stability

Assume $P$ and $C$ are rational; $P$ is strictly proper; $C$ is proper.

Set $r(t)=d(t)=0$. Bring in state-space models for $C$ and $P$.

<img src="img/controllerinternalstability.png" />

$$\begin{align}
\dot{x_c} &= A_cx_c+B_ce\\
u &= C_cx_c+D_ce\\
\\
\dot{x_p} &= A_p x_p + B_pu\\
y &= C_px_p\\
\end{align}$$

We get:
$$\underbrace{\begin{bmatrix}\dot{x_p}\\\dot{x_c}\end{bmatrix}}_{x_{cl}} = \underbrace{\begin{bmatrix}A_p-B_pD_cC_p&B_pC_c\\-B_cC_p&A_c\end{bmatrix}}_{A_{cl}}\begin{bmatrix}X_p\\x_c\end{bmatrix}$$

The closed-loop system is **internally stable** if $\dot{x_{cl}}=A_{cl}x_{cl}$ is asymptotically stable.

#### e.g.
Given:
$$\begin{align}
\dot{x_p} &= \begin{bmatrix}0&1\\0&-5\end{bmatrix}x_p + \begin{bmatrix}0\\1\end{bmatrix}u\\
y &= \begin{bmatrix}1&0\end{bmatrix}x_p\\
\dot{x_c} &= -15x_c + e\\
y &= -1000x_c + 100e\\
\end{align}$$

Then:
$$\begin{align}
A_{cl} &= \begin{bmatrix}
  \begin{bmatrix}0&1\\0&-5\end{bmatrix}-\begin{bmatrix}0\\1\end{bmatrix}100\begin{bmatrix}1&0\end{bmatrix} &
  -\begin{bmatrix}0\\1\end{bmatrix} \\
  -\begin{bmatrix}1&0\end{bmatrix} &
  -15
\end{bmatrix}\\
&= \begin{bmatrix}0&1&0\\-100&-5&-1000\\-1&0&-15\end{bmatrix}\\
\\
\det(sI-A_{cl}) &= \det\begin{bmatrix}s&-1&0\\100&s+5&1000\\1&0&s+15\end{bmatrix}\\
&= s(s+5)(s+15)+100(s+5)\\
&= (s+5)(s^2+15s+100)\\
\end{align}$$

You can check that all the roots of the determinant (all the eigenvalues) have negative real parts. This implies that $\dot{x_{cl}}=A_{cl}x_{cl}$ is asymptotically stable, and therefore the feedback system is internally stable.

### Input-output stability
Given the same feedback loop as before:
<img src="img/stabilitysystem.png" />

This system has 6 transfer functions from $(r, d)$ to $(e, u, y)$. Finding them:

$$\begin{align}
Y &= PU\\
E &= R - PU\\
U &= D+C\\
\Rightarrow \begin{bmatrix}1&P\\-C&1\end{bmatrix}\begin{bmatrix}E\\U\end{bmatrix}&=\begin{bmatrix}R\\D\end{bmatrix}\\
\begin{bmatrix}E\\U\end{bmatrix} &= \frac{1}{1+PC}\begin{bmatrix}1&-P\\C&1\end{bmatrix}\begin{bmatrix}R\\D\end{bmatrix}\\
\\
\frac{E}{R} &= \frac{1}{1+PC}\\
\frac{E}{D} &= \frac{-P}{1+PC}\\
\frac{U}{R} &= \frac{C}{1+PC}\\
\frac{U}{D} &= \frac{1}{1+PC}\\
\frac{Y}{R} &= \frac{PC}{1+PC}\\
\frac{Y}{D} &= \frac{P}{1+PC}\\
\end{align}$$

A feedback system is **input-output stable** if $(e, u, y)$ are bounded whenever $(r, d)$ are bounded.

Since whenever $r$ and $e$ are bounded, so is $y=r-e$, we only need to look at the TFs from $(r,d)$ to $(e,u)$.

#### e.g. 5.2.5
$$P(s)=\frac{1}{(s+1)(s-1)}, \quad C(s)=\frac{s-1}{s+1}$$

The for transfer functions are:
$$\begin{align}
\begin{bmatrix}E\\U\end{bmatrix} &= \begin{bmatrix}
  \frac{(1+1)^2}{s^2+2s+2} & \frac{s+1}{(s-1)(s^2+2s+2)} \\
  \frac{(s+1)(s-1)}{s^2+2s+2} & \frac{(s+1)^2}{s^2+2s+2}
\end{bmatrix}
\begin{bmatrix}R\\D\end{bmatrix}
\end{align}$$
Three of these TFs are BIBO stable; the one from D to E is not. Therefore the feedback system is not input-output stable.

Observe:
$$\frac{Y(s)}{R(s)}=\frac{1}{s^2+2s+2}$$
This is BIBO stable, so don't be fooled. The problem is that $C$ cancels an **unstable pole** of the plant. Input-output stability is more than just the stability of one transfer function.

### Characteristic polynomial
Write:
$$P(s)=\frac{N_p}{D_p}, \quad C(s)=\frac{N_c}{D_c}$$
- $N_p$, $D_p$, $D_c$ are polynomials in $s$
- $\deg(N_p) \lt \deg(D_p)$, $\deg(N_c) \le \deg(D_c)$
- $(N_p, D_p)$ and $(N_c, D_c)$ are coprime

  The **characteristic polynomial** of the feedback system is:
  $$\pi(s) := N_p(s)N_c(s) + D_p(s)D_c(s)$$

#### e.g. 5.2.7
$$P(s)=\frac{1}{(s+1)(s-1)}, \quad C(s)=\frac{s-1}{s+1}$$
$$\begin{align}
\pi(s)&=(1)(s-1)+(s+1)(s-1)(s+1)\\
&= (s-1)(s^2 + 2s + 2)
\end{align}$$

The characteristic polynomial has an unstable root, the one we cancelled.

**Theorem 5.2.6.** The feedback system is input-output stable if and only if its characteristic polynomial has no roots with $\Re(s) \ge 0$.

Observe:
$$\begin{align}
\begin{bmatrix}\frac{1}{1+PC} & \frac{-P}{1_PC} \\ \frac{C}{1+PC} & \frac{1}{1+PC}\end{bmatrix} &= \frac{1}{\pi(s)}\begin{bmatrix}D_pD_c & -N_pD_c \\ D_pN_c & D_pD_c \end{bmatrix}\\
\end{align}$$

The plant $P(s)$ and the controller $C(s)$ have a **pole-zero cancellation** if there exists a complex number $\lambda \in \mathbb{C}$ such that $N_p(\lambda) = D_c(\lambda)=0$ or $D_p(\lambda)=N_c(\lambda)=0$.

It is an **unstable cancellation** if $\Re(\lambda) \ge 0$.

If there is an unstable pole-zero cancellation, then the feedback system is unstable.
**Proof:** Assume there isi an unstable pole-zero cancellation at $\lambda \in \mathbb{C}$ with $\Re(\lambda) \ge 0$.

$$\begin{align}
\pi(\lambda) &= N_p(\lambda)N_c(\lambda) + D_p(\lambda)D_c(\lambda)\\
&= 0 + 0\\
\end{align}$$
So $\lambda$ is a root of $\pi$, so by Theorem 5.2.6, the system is unstable.

### Comparing Internal and Input-Output Stability
It can be shown that the roots of $\pi$ are a subset of the eigenvalues of $A_{\text{closed loop}}$. So, internal stability implies input-output stability.
- usually the two concepts are the same (but not always)
- in this course we generally assume they are the same unless asked specifically to check

### The Routh-Hurwitz Criterion
Consider an $n$th order polynomial:
$$\pi(s) = s^n + a_{n-1}s^{n-1} + ... + a_1s + a_0$$

$\pi(s)$ is **Hurwitz** if all its roots have $\Re(s) \lt 0$.

The Routh-Hurwitz Criterion is a test to determine if a polynomial is Hurwitz without actually computing the roots. It is a necessary condition for a polynomial to be Hurwitz.

Let $\{\lambda_1, ..., \lambda_r\}$ be the real roots of $\pi$.

Let $\{\mu_1, \bar{\mu_1}, ..., \mu_s, \bar{\mu_s}\}$ be the complex conjugate roots of $\pi$.

$$r+2s=n$$

Then, we can write:
$$\pi(s) = (s - \lambda_1)...(s - \lambda_r)(s-\mu_1)(s-\bar{\mu_1})...(s-\mu_s)(s-\bar{\mu_s})$$

If $\pi$ is Hurwitz, then all the roots have $\Re(s) \lt 0$, so the real roots have to be negative. Then $-\lambda_i \gt 0$.

For the complex conjugate roots:
$$\begin{align}
(s-\mu_i)(s-\bar{\mu_i}) &= s^2 + (-\mu_i - \bar{\mu_i})s + \mu_i\bar{\mu_i}\\
&= s^2 - 2\Re(\mu_i)s + |\mu_i|^2\\
\end{align}$$
If $\pi$ is Hurwitz, then $-\Re(\mu_i)\gt 0$ and $|\mu_i| \ne 0$. If we expand $\pi(s)$ out again, all the coefficients $a_i$ will be **positive**.

#### e.g. 5.3.1
$$s^4+3s^3-2s^2+5s+6$$
We have a coefficient with a negative sign, so we immediately know it is not Hurwitz.

$$s^3+4s+6$$
We have a coefficient of 0, and since we need all to be positive, we know it is not Hurwitz.

$$s^3+5s^2+9s+1$$
We are not sure whether or not this is Hurwitz.
