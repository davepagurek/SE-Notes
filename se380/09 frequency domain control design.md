# Intro to Control Design in the Frequency Domain

- This chapter is about "classical" Frequency domain design
- Specs will be given in terms of **bandwidth** and **stability margins**
- Our real interest is in how the system behaves in the time domain, so we will use the duality between these domains
- We'll take specs like %OS, $T_s$, steady-state tracking error and convert them to the frequency domain

## Intro to stability margins
If a system is stable, how stable is it? This depends on how much error/uncertainty there is in the plant model. Stability margins help answer the question of how much inaccuracy the system can handle. Best understoodusing **Nyquist plots**, but Bode plots work too

### Gain margin
<img src="img/stabilitymargin.png" />

- Think of $K=1$ as our **nominal design**
- Our **gain margin** $K_{gm} = \max\left\{\bar{K} \gt 1: \text{ closed-loop stability for } K \in [1, \bar{K})\right\}$

### Phase margin
<img src="img/phasemargin.png" />
- Think of $\phi=0$ as out **nominal design**
- Our **phase margin** $\Phi_{pm} = \max\left\{\bar{\phi} \gt 0: \text{ closed-loop stability for } \phi \in [1, \bar{\phi})\right\}$

- Large $K_{gm}, \phi_{pm}$ not only ensure robustness, but also good transient behaviour. A system with small $K_{gm}, \Phi_{pm}$ is nearly unstable which could mean slow response and oscillatory behaviour.

### Obtaining gain and phase margins
<img src="img/obtainphase.png" />

Let $L(s) := C(s)P(s)H(s)$. Draw the Bode plot of $L(j\omega)$.

<img src="img/stabilitymarginbode.png" />

- $\omega_{gc}$ is the gain crossover frequency
  - frequency at which $L(j\omega_{gc})=1$
  - frequency at which we measure $\Phi_{pm}$
- $\omega_{pc}$ is the phase crossover frequency
  - frequency at which $\angle L(j\omega_{pc})=\pi$
  - frequency at which we measure $K_{gm}$

Matlab:
```matlab
[K_gm, Phi_pm, omega_pc, omega_gc] = margin(sys);
```

## Performance Specifications
We focus on:
1. input-output stability
2. steady-state tracking error
3. %OS (converted into a $\Phi_{pm}$ spec)
4. Closed-loop bandwidth

### Relationship between crossover frequencies and bandwidth
$$\frac{Y(s)}{R(s)} = \frac{C(s)P(s)}{1+C(s)P(s)} = G(s)$$
<img src="img/bwbode.png" />

Define the loop transfer function:
$$L(s) = C(s)P(s)$$
We can see the open-loop gain crossover frequency:
<img src="img/openloopgaincrossover.png" />

"Normally," $\omega_{gc} \lt \omega_{bw} \lt \omega_{pc}$. For design purposes, we'll use a rule of thumb:
$$\omega_{gc} \approx \omega_{bw}$$

### Relationship between damping ratio and phase margin
Damping ratio: $\zeta$
Phase margin: $\Phi_{pm}$

This relationship can be found in closed form for second-order systems.

<img src="img/dampingratiophase.png" />

$$\frac{Y(s)}{R(s)} = \frac{\omega_n^2}{s^2+2\zeta\omega_ns + \omega_n^2}$$

A messy calculation gives:
$$\Phi_{pm}=\tan^{-1}\left(2\left(\zeta(1+4\zeta^4)^{\frac{1}{2}}-2\zeta^2\right)^{\frac{1}{2}}\right)$$

<img src="img/phasemargingraph.png" />

## Lag Compensation
<img src="img/lagcontroller.png" />

Lag controller:
$$\begin{align}
C(s) &= KC_1(s)\\
&= K\frac{\alpha Ts+1}{Ts+1}, \quad 0 \lt \alpha \lt 1, \quad T \gt 0, \quad K \gt 0
\end{align}$$

Pole and zero locations for a lag controller:
<img src="img/lagpolar.png" />

### Steady-state gain
$$C(0)=K$$
<img src="img/lagbode.png" />

Key befefit: Reduce high frequency gain without changing phase

### Uses
1. Boost low frequency gain to get good tracking and disturbance rejection without affecting stability margins or the high frequency behaviour ($e_{ss}$ spec and %OS spec)
2. To increase phase margin, done indirectly through changing the high frequency gain (See fig. 9.9 in the notes)

### e.g. 9.3.1
$$\begin{align}
P(s) &= \frac{1}{s(s+2)}\\
\\
C(s) &= \text{lag controller}\\
&= K\frac{\alpha Ts+1}{Ts+1}
\end{align}$$

Specs:
1. If $r(t)=t1(t)$, then $|e_{ss}| \le 0.05$.
2. $\Phi_{pm}^{desired} = 45^{\circ}$ (for good damping)

Steps 1: Choose $K$ to meet $e_{ss}$ spec. For now, assume $C(s)$ provides IO stability s we can apply FVT.
$$\begin{align}
e_{ss} &= \lim_{t\rightarrow \infty}e(t)\\
&= \lim_{s \rightarrow 0} sE(s)\\
&= \lim_{s \rightarrow 0} s\frac{1}{1+C(s)P(s)} R(s)\\
&= \lim_{s \rightarrow 0} s \frac{1}{1+\frac{K\alpha Ts+1}{Ts+1} \frac{1}{s(s_2)}} \frac{1}{s^2}\\
&= \frac{2}{K} \le 0.05 \Leftrightarrow K \ge 40
\end{align}$$
Take $K=40$
