# Root-Locus Method

## 6.1 Basic root-locus construction
### e.g. 6.1.1
$$C(s)=K_p, \quad P(s) = \frac{1}{s(s+2)}$$
$$\begin{align}
\pi(s) &= s^2 + 2s + K_p\\
s &= -1 \pm \sqrt{1-K_p}\\
\end{align}$$

- If $K_p \le 0$, lose IO stability
- If $0 \lt K_p \le 1$, we have two roots with negative real part

<img src="img/rootlocuseg1.png" />

- This root locus tells us that the system can go unstable with bad choices of $K_p$
- From the diagram, we can qualitatively see that $K_p$ should be such that $\Im(s)$ of the poles $\ne 0$, but not too big.
- Matlab: use `sisotool` or `rltool`

### Construction
<img src="img/basicrootlocus.png" />
$$\pi(s) = \underbrace{D_pD_c}_{D(s)} + K\underbrace{N_pN_c}_{N(s)}$$

A root-locus diagram is a drawing of how the roots of $\pi$ change as $K$ is changed.

Assumptions:
- $C(s)P(s)$ proper
- $K \ge 0$
- $D(s)$ and $N(s)$ are monic (leading coefficient is 1)

Let $n:=\deg(D(s))$, $m:=\deg(N(s))$

**Rules**
1. Roots of $\pi$ are symmetric about the real axis
2. There are $n$ "branches" (paths) of the root locus (since $\deg(\pi)=n$)
3. Roots of $\pi$ are a continuous function of $K$
4. When $K=0$, roots of $\pi$ are equal to the roots of $D$
5. As $K \rightarrow +\infty$, $m$ branches of the root locus approach the roots of $N(s)$ ($\pi(s) = 0 \Leftrightarrow \frac{N(s)}{D(s)}=\frac{-1}{K}$)
6. The remaining $n-m$ branches tend towards $\infty$. They do so along asymptotes:
  - Go through the point $s=\sigma + 0j$ where $\sigma = \frac{\sum \text{roots of } D - \sum \text{roots of } N}{n-m}$ (centroid)
  - Make angles $\phi_1, ...,\phi_{n-m}$ with real axis given by $\phi_k := \frac{(2k-1)\pi}{n-m}, k \in \{1, ..., n-m\}$
  - Asymptote patterns: (fig. 6.4)
  - <img src="img/rootlocussigmalocations.png" />
7. ("no-yes-no" rule) A point $s_0$ on the real axis is a part of the root locus if and only if $s_0$ is to the **left** of an **odd** number of poles/zeroes.
  - It follows from the fact that on the root locus, $\angle N(s_0) - \angle D(s_0) = \angle \frac{-1}{K} = \pi$
8. (angles of departure/arrival)
  - <img src="img/departurearrival.png" />
  - To compute, use $\angle N(s) - \angle D(s) = \pi$
  - $\Rightarrow \angle (s-z_1) + \angle (s-z_2) + ... + \angle(s - z_m) - \angle (s-p_1) + ... + \angle (s-p_n) = \pi$
  - To compute the angle of departure at pole $p_i$, plug $s=p_i$ into the above and solve for $\angle (s-p_i) =: \theta_{p_i}$.
