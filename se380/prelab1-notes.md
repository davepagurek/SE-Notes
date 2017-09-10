# Prelab 1 Notes
Things I think are important to understanding the prelab

## Laplace transforms

If $f(t)$ is a function in the time domain, then the laplace transform $\mathcal{L}\{f(t)\} = F(s)$ is in the frequency domain.

$s$ is a complex variable, so $s = \sigma_{\text{(real part)}} + j\omega_{\text{(imaginary part)}}$.
- The unit of $s$ is in rad/s
- The imaginary part is the frequency
- The real part represents a decay coefficient

## Transfer functions

Transfer functions exist in the $s$-plane, not the time plane.

The transfer function $T(s)$ of a system with an input signal $X(s)$ and output $Y(s)$ is just defined to be the ratio of input to output:

$$T(s) = \frac{X_{\text{(input)}}(s)}{Y_{\text{(output)}}(s)}$$

### How do you get a transfer function?

#### 1. Block diagram to transfer function

There is a direct mapping from block diagram to transfer function:

<img src="img/transfer-simple.png" />
**Square blocks multiply.** In this case, $Y(s) = X(s)F(s)$.

<img src="img/transfer-complex.png" />
**Circle blocks sum,** taking into account signs on input arrows. In this case, $Y(s) = (X(s)-G(s))F(s)$.

#### 2. System response to transfer function

You can produce an input $x(t)$ and measure the system response $y(t)$. Then, you can just take the Laplace transform of $x(t)$ and divide it by the Laplace transform of $y(t)$ to get the transfer function.

- If your input is the Dirac delta function (a value of basically $\infty$ for a tiny width of $dx$ followed by nothing), then $\mathcal{L}\{\delta(t)\} = 1$, so the Laplace transformed system response $Y(s)$ is equal to the transfer function.
- If your input is the unit step function (a value of 0 for $x \lt 0$ and a value of 1 otherwise), $X(s) = s$, so the observed system response divided by $s$ will be your transfer function: $T(s) = Y(s)/s$
