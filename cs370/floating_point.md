# Floating Point Numbers

## Compounded error
For a given real number $\alpha$ and $n, n\ge 0$. There is a trick to evaluate:

$$\begin{align}
I_n &= \int_0^1{\frac{x^n}{x+\alpha} dx}\\
&= \int_0^1 \frac{x^n + x^{n-1}\alpha - x^{n-1} \alpha}{x+\alpha} dx \\
&= \int_0^1 \frac{x^n + x^{n-1}\alpha}{x+\alpha} dx - \int_0^1 \frac{x^{n-1}\alpha}{x+\alpha} dx\\
&= \int_0^1 \frac{x^{n-1}(x+\alpha)}{x+\alpha} dx - \int_0^1 \frac{x^{n-1}\alpha}{x+\alpha} dx\\
&= \int_0^1 x^{n-1} dx - \alpha I_{n-1}\\
&= \frac{1}{n} x^n \bigg|^1_0 - \alpha I_{n-1}\\
&= \frac{1}{n} - \alpha I_{n-1}\\
I_n &= \frac{1}{n} - \alpha I_{n-1}
\end{align}$$

So, to evaluate $I_{100}$:

$$\begin{align}
I_1 &= \frac{1}{1} - \alpha I_0\\
I_2 &= \frac{1}{2} - \alpha I_1\\
...\\
I_{100} &= \frac{1}{100} - \alpha I_{99}\\
\end{align}$$

$$\begin{align}
I_0 &= \int_0^1 \frac{x^0}{x+\alpha} dx\\
&= \int_0^1 \frac{1}{x+\alpha} dx\\
&= \ln(x+\alpha) \bigg|^{x=1}_{x=0}\\
&= \ln(1+\alpha)-\ln(\alpha)\\
\end{align}$$

In matlab:

```matlab
% Try alpha values of 0.5 and 2.
alpha = 0.5;
N = 100;
I = log((1+alpha) / alpha);
for n = 1:N
  I = 1/n - alpha * I;
end
disp(['Answer: ' num2str(I)]);
```

If $\alpha=0.5$, $I_{100}=0.0066444$.
If $\alpha=2$, $I_{100}=6.053*10^{12}$.

For $0 \le x \le 1, \alpha \gt 1$:
$$0 \le \frac{x^n}{x+\alpha} \le x^n \Rightarrow \int_0^1 \frac{x^n}{x+\alpha} \le \int_0^1 x^n$$

This means $I_{100}$ should have been less than $\frac{1}{101}$, and not on the order of $10^{12}$.

### What happened?

Each **computed** $I$ value has an error associated with it that compounds over multiple operations.

$$\begin{align}
I_n^{comp} &= I_n^{exact} + e_n\\
I_n^{exact} &= \frac{1}{n} - \alpha I^{exact}_{n-1}\\
I_n^{comp} &= \frac{1}{n} - \alpha I^{comp}_{n-1}\\
e_n &= I_n^{comp} - I_n^{exact}\\
&= -\alpha(I_{n-1}^{comp} - I_{n-1}^{exact})\\
&= -\alpha e_{n-1}\\
&= -\alpha(-\alpha e_{n-2})\\
|e_n| &= |\alpha| |e_{n-1}|\\
&= |\alpha|^2 |e_{n-2}|\\
&= |\alpha|^3 |e_{n-3}|\\
...\\
&=|\alpha|^n |e_0|\\
\end{align}$$

If $|\alpha|<1$, then $|e_n| \rightarrow 0$ (good)
If $|\alpha|>1$, then $|e_n| \rightarrow \infty$ (bad)
