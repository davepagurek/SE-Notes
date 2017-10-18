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

Closed-loop response is dominated by poles at $s=-1 \pm 7.3j$, making it look like an underdamped second-order system with a lot of overshoot.

Input signal: From 0 to 5s, move in the counter-clockwise direction by 1 radian. After 5s, return to the upright position.

<img src="img/pendulumresponse.png" />
