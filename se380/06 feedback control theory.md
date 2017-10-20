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
<img src="img/controllerinternalstability.png" />

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
