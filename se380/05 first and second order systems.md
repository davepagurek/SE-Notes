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
$$g(t) = K\frac{\omega_n}{\sqrt{1-\zeta^2}} \underbrace{e^{-\zeta \omega_n t}}_\text{decay rate} \sin\underbrace{\left(\omega_n \sqrt{1-\zeta^2} t\right)}_\text{oscillation rate}, \quad t \ge 0$$

Observe: If we fix $\zeta \in (0,1)$, then larger bandwidth $\Leftrightarrow$ faster decay

#### Step response
$$\begin{align}
u(t) &= 1(t)\\
\Rightarrow U(s) &= \frac{1}{s}\\
\\
Y(s) &= G(s)U(s)\\
\Rightarrow y(t) &= \mathcal{L}^{-1}{G \dot U}\\
&= K\left(1 - \frac{1}{\sqrt{1 - \zeta^2}} e^{-\zeta \omega_n t} \sin\left(\omega_n \sqrt{1 - \zeta^2}t + \theta\right)\right), \quad \theta = \arccos \zeta\\
\end{align}$$

### Summary

- As $\zeta \rightarrow 1$, response is less oscilatory, less overshoot, imaginary part of poles approaches zero
- As $\zeta \rightarrow 0$, response is more oscillatory, more overshoot, real part of poles approaches 0
- $\omega_{BW} \approx \omega_n$. As $\omega_n \rightarrow \infty$, response is faster, poles have larger magnitude.
- Frequency of oscillation depends on imaginary part of the poles; rate of decay depends on the real part

## General characteristics of step response
- Look at common metrics to quantify the quality
- metrics apply to **any** system
- we use $G(s) = \frac{K \omega_n^2}{s^2 + 2\zeta \omega_n s + \omega_n^2}$ to get equations for the metrics in therms of $K, \omega_n, \zeta$

<img src="img/stepcharacteristics.png" />

### Overshoot
- only undamped second order systems have it:
$$\%OS = \frac{||y||_\infty - |G(0)|}{|G(0)|}$$
- only depends on dampting ratio:
$$\%OS = \exp\left(\frac{-\zeta \pi}{\sqrt{1 - \zeta^2}}\right), \quad 0 \lt \zeta \lt 1$$
- More damping (larger $\zeta$) $\Leftrightarrow$ less overshoot

#### e.g. mass-spring damper
$$\frac{Y(s)}{U(s)} = \frac{\frac{1}{M}}{s^2 + \frac{b}{M}s + \frac{K_{spring}}{M}}$$

- Find conditions on $M,b,K_{spring}$ so that $\%OS \le \%OS_{max} = 0.05$

$$\begin{align}
\zeta &= \frac{b}{2\sqrt{MK_{spring}}}\\
\zeta &\ge \frac{-\ln(\%OS_{max})}{\sqrt{\pi^2 + (\ln\%OS_{max})^2}} =:\zeta_{min}\\
\\
\text{To meet specs:}\\
\frac{b}{2\sqrt{MK_{spring}}} \ge 0.6901\\
\end{align}$$

The angle the poles make is $\pm(\pi - \arccos \zeta)$.
$$ \zeta \ge \zeta_{min} \Leftrightarrow \theta \le \arccos(\zeta_{min})$$
In this example, $\theta \le 46^{\circ}$
<img src="img/overshootangle.png" />
Therefore the overshoot spec is not met if there are poles in the shaded region.

### Settling time
- The smallest time $T_s$ such that $\forall t \ge T_s,\quad \frac{|G(0)-y(t)|}{|y(t)|} \le 0.02$.
- An estimate is obtained by looking at the decay rate $e^{-\zeta \omega_n t}$:
$$e^{-\zeta \omega_n t} \le 0.02 \Rightarrow t \ge \frac{4}{\zeta \omega_n} \text{ (approx)}$$
i.e. $T_s = \frac{4}{\zeta \omega_n}$
