# PID Control

## 7.1 Classical PID

<img src="img/pidcontroller.png" />
$$\begin{align}
C(s) &= \frac{U(s)}{E(s)}\\
&= K_p + \frac{K_i}{s} + K_ds\\
&= \frac{K_ds^2 + K_ps + K_i}{s}\\
\\
\text{Standard form:}\\
&= K_p\left(1 + \frac{1}{T_is}+T_ds\right)\\
\text{Where:}\\
T_i &= \text{integral time constant}\\
T_d &= \text{derivative time constant}\\
\\
u(t)&=K_pe(t) + K_i \int_0^t e(\tau)d\tau + K_d \frac{de}{dt}\\
\end{align}$$

### Refinements to the basic PID control
1. Since the transfer function for PID is improper, the derivative term is approximated using a low-pass filtered version:
  - $C(s) = K_p\left(1+\frac{1}{T_is}+\frac{T_ds}{\tau_ds+1}\right)$
2. Since $r(t)$ is often discontinuous, we often avoid differentiating it, since it would lead to control spikes.
  - We feed $y$ and $r$ in separately instead of just the error so we have two degrees of freedom
  - <img src="img/twodegreesoffreedom.png" />
  - $U(s)=\frac{K_i}{s}E(s)-\left(K_p + \frac{T_ds}{\tau_ds+1}\right)Y(s)$
3. Anti-windup (deals with actuator constraints), see section 7.4 (won't be tested on this)

### What does each term do?
Consider $u(t) = K_pe(t) + \frac{K_p}{T_i} \int_0^t e(\tau)d\tau + K_pT_d \frac{de(t)}{dt}$.

- Proportional part
  - only depends on the *current* value of $e(t)$
  - high gain usually gives good performance in terms of tracking
  - if $K_p$ is too high, we get instability
- Integral part
  - gives perfect step tracking (see internal model principle discussion earlier)
  - acts on historic data, accumulated error
- Derivative part
  - penalizes fast changes in the error, smooths out transients. Acts kind of like friction in a physical system
  - called the "predictive part" of PID
    - e.g. PD controller: $u(t)=K_p\left(e(t)+T_d\frac{de(t)}{dt}\right)$
    - <img src="img/predictivepid.png" />
    - The $e(t)+T_d\frac{de(t)}{dt}$ terms are a prediction of error at $t+T_d$ seconds using linear interpolation
