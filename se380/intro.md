# Feedback Control

## What is control engineering?

### e.g. Automated highway
<img src="img/highway.png" />

**Objective:**
- decide on the velocity commands to the follower in order to maintain a safe inter-vehicle distance

**Assumptions:**
- cars only move forward and reverse on flat ground
- through software running on an embedded computer, we can assign different velocities to the follower
- Model for follower: $\frac{df(t)}{dt} = u(t)$, where we decide $u(t)$
- Leader moves at a constant but unknown speed

#### Solution 1: Open loop
- Don't equip follower with any sensors (save that money 💰)
- algorithm to decide velocity only has access to the desired inter-vehicle distance, labelled $r(t)$

<img src="img/openloop.png" />

- Since the algorithm has no access to $y(t)$, it can't make an informed decision
- Toasters work like this (doesn't sense toast burntness, just goes for a set time)


#### Solution 2: Closed Loop
- equip the follower with sensors that can measure $y(t)$

<img src="img/closedloop.png" />

- Simplest control algorithm
  - $u(t) = -K_p (r(t) - y(t)), \quad K_p \gt 0$
- Better control algorithm: **proportional-integral error feedback**
  - $u(t) = -K_p (r(t) - y(t)) - K_i \int_0^t{(r(T)-y(T)) dT}, \quad K_p, K_i \gt 0$

### e.g. Web server
(See 1.4.1 in the notes)

- Web server that responds to GET and POST requests from browsers
- The server has a buffer of pending requests so no requests are lost
