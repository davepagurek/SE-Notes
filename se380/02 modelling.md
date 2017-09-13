# Modelling systems

<img src="img/dynamicsystem.png" />

1. Apply known laws to get a system of differential equations
2. Linearize the model at an operating point to get a system of linear equations
3. Take the Laplace transform with zero initial conditions to get a system of linear algebraic equations
4. Isolate input and output to get a transfer function
5. Experimentally determine parameter values for the transfer function (e.g. weight of your robot)

## Applying known laws to get equations
### e.g. Spring

<img src="img/spring.png" />

$q \in \mathbb{R}$ is the position of the mass M

$\dot{q} := \frac{dq}{dt}, \quad \ddot{q} := \frac{d^2q}{dt^2}$

Assume that $q=0$ corresponds to the mass location at which the spring is neither stretched nor compressed.

Newton's 2nd law: $M\ddot{q} = \sum{ \text{forces acting on } M}$

Force due to spring: $F_K(q) = Kq$, assumed to be linear

Force due to damper, possibly nonlinear: $C(\dot{q})$

Altogether, we get a second order nonlinear ODE:
$$M\ddot{q} = -Kq - C(\dot{q}) + u$$

Note: if the damper is linear ($C(\dot{q})=bq), then the overall system is linear

### e.g. Resistor

<img src="img/resistor.png" />

$V_R(t) = h(i(t)), \quad h : \mathbb{R} \rightarrow \mathbb{R}$ is possibly nonlinear

$u(t)$: applied voltage; $y(t)$: voltage across capacitor

Apply Kirchoff's Voltage Law:
$$\begin{align}
-u(t) + V_R + y &= 0\\
\\
i(t) &= C\frac{dy}{dt} \quad \text{(capacitor equation)}\\
V_R &= h(i(t)) = h(C\dot(y))\\
\\
-u(t) + h(C\dot{y}) + y &= 0\\
\end{align}$$

Note: if the resister were linear ($h(i) = Ri$), the whole system would be linear (see 2.3.4 in notes)

## State models

### e.g. Cart
<img src="img/carairresistance.png" />

Newton's second law: $M\ddot{y} = u - D(\dot{y})$

We put this model into a standard form by defining two **state variables**:
$$x_1 := y \text{ (position)}, \quad x_2 := \dot{y} \text{ (velocity)}$$

Together, $x_1$ and $x_2$ make up the **state** of the system. We do some rewriting to have a systematic way to do linearization:

$$\begin{align}
\dot{x_1} &= x_2 & \text{(state equation)}\\
\dot{x_2} &= \frac{1}{M}u - \frac{1}{M}D(x_2) & \text{(state equation)}\\
y &= x_1 & \text{(output equation)}\\
\end{align}$$

Together, these equations make up the **state-space model.** These equations have the general form:

$$\dot{x} = f(x,u) \text{ where } y = h(x)$$

In this example:

$$\begin{align}
X &= (x_1, x_2) \in \mathbb{R}^2\\
f(x,u) &= \begin{bmatrix}
x_2 \\
\frac{1}{M}u - \frac{1}{M}D(x_2)
\end{bmatrix}\\
\end{align}$$

In the special case where air resistance is a linear function of $x_2$ ($D(x_2)=d x_2$), then $f(x,u)$ becomes a linear function of $x$ and $u$:

$$f(x,u) = \begin{bmatrix}
0 & 1 \\
0 & \frac{-d}{M}
\end{bmatrix} \begin{bmatrix}
x_1 \\
x_2
\end{bmatrix} + \begin{bmatrix}
0 \\
\frac{1}{M}
\end{bmatrix} u
$$

Define $C = \begin{bmatrix}1 & 0\end{bmatrix}$. In the linear case, we get:
$$\begin{align}
\dot{x} &= Ax + Bu\\
y &= Cx\\
\end{align}$$

This is a linear, time-invariant (LTI) model
