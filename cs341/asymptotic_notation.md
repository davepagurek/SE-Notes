# Asymptotic Notation

## Common growth rates
(increasing order)

- $\Theta(1)$
- $\Theta(\log n)$
- $\Theta(\sqrt{n})$
- $\Theta(n)$
- $\Theta(n^2)$
- $\Theta(n^c)$
- $\Theta(n^\sqrt{n} \log n)$ (best known algorithm for graph isomorphism)
- $\Theta(c^{c(\log n)^{1/3}(\log \log n)^{2/3}})$ (factoring algorithm)
- $\Theta(1.1^n)$
- $\Theta(2^n)$
- $\Theta(c^n)$
- $\Theta(n!)$
- $\Theta(c^n)$

## Loop analysis
### e.g. 1
<img src="img/loop.png">

#### Using $\Theta$
- Loop on $k$: $\Theta(1)$
  - number of iterations: $j-i+1$
  - Complexity is $Theta(j-i+1)$
- Loop on $j$:
  - Complexity: $\sum_{j=i}^n \Theta(j-i+1) = \Theta(i+2+...+n(n-i+1))$
  - $\Theta\left(\frac{(n-i+1)(n-i+2)}{2}\right)$
  - $\Theta(n^3)$

#### Using separate upper and lower bounds: Modified loop structures
- Loop 1
  - $i = 1, ..., \frac{n}{3}$
  - $j=\frac{2n}{3},...,n$
  - $k=\frac{2n}{3},...,n$
  - $\Omega(\frac{n}{3} \cdot \frac{n}{3} \cdot \frac{n}{3}) = \Omega(n^3)$
- Loop 2
  - $i=1,...,n$
  - $j=i+1,...,n$
  - $k=i,...,j$
  - $1 \le i \le k \le j \le n$
- Loop 3
  - $i=1,...,n$
  - $j=1,...,n$
  - $k=1,...,n$
  - $O(n^3)$
- $L1 \subseteq L2 \subseteq L3$
- $\Theta(n^3)$


### e.g. 2
<img src="img/loop2.png">

- $j = i, \frac{i}{2}, \frac{i}{4}, \frac{i}{8}, ..., 1$
  - Number of iterations: $\log_{2} i$
  - $\Theta(\log(1*2*3*...*n))$
  - $\Theta(\log(n!))$
  - $\Theta(n\log n)$
