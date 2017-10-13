# First and Second Order Systems

## First order
$$\tau \dot{y} = ku$$
or
$$\frac{Y(s)}{U(s)} = \frac{K}{\tau s + 1}$$
or
$$\begin{align}
\dot{x}&=\frac{-x}{\tau} + \frac{K}{\tau} u\\
y &= x
\end{align}$$

Observations:
- Pole at $s=\frac{-1}{\tau}$
- No zeroes
- BIBO stable if and only if $\tau \gt 0$
- steady-state gain: $K$
- bandwidth: $\frac{1}{\tau}$ rad/s
- Impulse response: $g(t)=\frac{K}{\tau} e^{-1/\tau} 1(t)$
  - $g(0)=\frac{K}{\tau}$
  - $g(\tau)=g(0)e^{-1} \approx 0.37g(0)$
  - $g(2\tau)=g(0)e^{-2} \approx 0.14g(0)$
- Higher bandwidth implies faster impulse response, and vice versa

Step response:
$$y(t) = \mathcal{L}^{-1}\{G(s)U(s)\} = \mathcal{L}^{-1}\left\{\frac{K}{\tau s + 1} \frac{1}{s}\right\} = \mathcal{L}^{-1}\left\{\frac{K}{s} - \frac{K}{s + \frac{1}{\tau}}\right\}$$
$$K(1-e^{\frac{-t}{\tau}}), \quad t \ge 0$$

<img src="img/firstordertime.png" />

Observations:
1. After $4\tau$ seconds, $y(t)$ is within 2% of its steady-state value
2. For all $t \gt 0$, $y(t) \lt y_{ss}$ (no overshoot)
3. $y(t)$ increases monotonically (no oscillations)
4. Decrease in $\tau \Leftrightarrow$ step response gets faster $\Leftrightarrow$ bandwidth goes up $\Leftrightarrow$ poles move to the left

## Second order
$$\ddot{y}+2\zeta\omega_n \dot{y} + \omega_n^2 y = K\omega_n^2 u$$
or
$$ \frac{Y(s)}{U(s)} = \frac{K\omega_n^2}{s^2 + 2\zeta\omega_n s + \omega_n^2}$$
or
$$\begin{align}
\dot{x} &= \begin{bmatrix}0&1\\-\omega_n^2&-2\zeta\omega_n\end{bmatrix}x + \begin{bmatrix}0\\K\omega_n^2\end{bmatrix}u\\
y &= \begin{bmatrix} 1 & 0\end{bmatrix}x\\
\end{align}$$

### e.g.
<img src="img/secondorderspring.png" />

$$\begin{align}
M \ddot{q} &= u - K_{spring} q - b\dot{q}\\
\frac{Y(s)}{U(s)} &= \frac{\frac{1}{M}}{s^2 + \frac{b}{M}s + \frac{K_{spring}}{M}}\\
\\
\omega_n &= \sqrt{\frac{K_{spring}}{M}}\\
\zeta &= \frac{b}{2 \sqrt{K_{spring}M}}\\
K &= \frac{1}{K_{spring}}
\end{align}$$

### Pole locations
From the quadratic formula, find the zeroes of the denominator:
$$s = -\zeta \omega_n \pm \omega_n \sqrt{\zeta^2 - 1} = \omega_n\left(-\zeta \pm \sqrt{\zeta^2 - 1}\right)$$

<img src="img/secondorderpolelocations.png" />

Pole locations are used to categorize the system:
- Undamped $\zeta = 0$
- Underdamped $0 \lt \zeta \lt 1$
- Critically damped $\zeta = 1$
- Overdamped $\zeta \gt 1$

Steady-state gain: $K$
Zeroes: none

<img src="img/secondordergian.png" />

### Step response

<img src="img/secondorderstepresponse.png" />

## Underdamped Systems

- Poles are complex conjugate: $s = -\zeta \omega_n \pm j\omega_n \sqrt{q - \zeta^2} = \omega_n e^{\pm j (\pi - \theta)}, \theta = \arccos(\zeta)$

<img src="img/underdampedpolar.png" />

#### Impulse response
$$g(t) = K\frac{\omega_n}{\sqrt{1-\zeta^2}} e^{-\zeta \omega_n t} \sin\left(\omega_n \sqrt{1-\zeta^2} t\right), \quad t \ge 0$$
