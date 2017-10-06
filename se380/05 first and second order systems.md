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
  - $g(2\tau)=g(0)e^{-2} \approx 0.14g(0)
- Higher bandwidth implies faster impulse response, and vice versa

## Second order
$$\ddot{y}+2\zeta\omega_n \dot{y} + \omega_n^2 y = K\omega_n^2 u$$
or
$$ \frac{Y(s)}{U(s)} = \frac{K\omega_n^2}{s^2 + 2\zeta\omega_n s + \omega_n^2}$$
or
$$\begin{align}
\dot{x} &= \begin{bmatrix}0&1\\-\omega_n^2&-2\zeta\omega_n\end{bmatrix}x + \begin{bmatrix}0\\K\omega_n^2\end{bmatrix}u\\
y &= \begin{bmatrix} 1 & 0\end{bmatrix}x\\
\end{align}$$
