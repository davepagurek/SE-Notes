# CS480: Machine Learning

## Core concepts

Concept | Description
--------|------------
Supervised learning | Learning given a set of training data and expected results (labels)
Unsupervised learning | Given training data but no labels, cluster the samples based on their contained data
Reinforcement learning | Learning by rewarding favourable results or punishing unfavourable results
Inductive bias | The implicit biases different techniques come in with, e.g. $K$NNs assume new examples should probably behave similarly to similar past data
Bias | How close to the truth a model can actually get (more bias implies farther mean distance from the ideal)
Variance | Regardless of how close to the truth a model gets, how consistent the predictions are
Cross-validation | Average performance by splitting the data into $K$ groups, and for each $K$, using that group as validation data and the rest as training data

## Performance
- **True positive**: Class 1 predicted as 1
- **False positive**: Class 0 predicted as 1
- **True negative**: Class 0 predicted as 0
- **False negative**: Class 1 predicted as 0

$$\begin{aligned}
\text{Accuracy} &= \frac{TP + TN}{TP + TN + FP + FN}\\
\\
\text{Error Rate} &= \frac{FP + FN}{TP + TN + FP + FN}\\
\\
\text{Precision} &= \frac{TP}{TP + FP}\\
\\
\text{Recall} &= \frac{TP}{TP + FN}\\
\\
F &= \frac{2 \cdot \text{Precision} \cdot \text{Recall}}{\text{Precision} + \text{Recall}}\\
\\
\text{Weighted }F &= \frac{(1 + \beta^2) \cdot \text{Precision} \cdot \text{Recall}}{\beta^2 \cdot \text{Precision} + \text{Recall}}\\
\end{aligned}$$

## Regularizer
A regularizer is a term that adds a cost to having large weights, adding inductive bias favouring "simpler" solutions.

**Ridge regularizers** use 2-norms, meaning that equivalent-cost weight vectors will make a circle when plotted.

**Lasso regularizers** use 1-norms, meaning that equivalent-cost weight vectors make a diamond when plotted. This adds incentive for having weights with values exactly at 0 instead of simply having small values, as a ridge regularizer would.

## Optimization techniques

Instead of using 0-1 loss, use a more nicely differentiable loss.

### Gradient Descent

If we are learning weights $w$ subject to loss function $f$:

- Initialize $w$
- Compute the gradient $g = \left.\frac{\partial f}{\partial w} \right\rvert_{w}$
- Step down the gradient by setting $w' = w - \eta g$

## Closed-form solution

e.g. for squared loss with a 2-norm regularizer with no bias:

$$\begin{aligned}
\mathcal{L}(w) &= \frac{1}{2}||Xw-Y||^2 + \frac{\lambda}{2}||w||^2\\
\nabla_w \mathcal{L}(w) &= X^T(Xw-Y) + \lambda w\\
&= X^T Xw - X^T Y + \lambda w\\
&= (X^T X + \lambda I)w - X^T Y\\
\\
(X^T X + \lambda I)w - X^T Y &= 0\\
(X^T X + \lambda I)w &= X^T Y\\
w &= (X^T X + \lambda I)^{-1} X^T Y\\
\end{aligned}$$

## Probability

**Joint probability**: $P(A, B) = P(A = a \land B = b) \forall a, b$.

**Conditional probability**: $P(A|B) = \frac{P(A \land B)}{P(B)}$

**Product rule**: $P(A \land B) = P(A|B)P(B)$. Following this, $P(A, B | C) = P(A|B, C)P(B|C)$

**Sum rule**: $\sum_i P(A_i | C) = 1$

Two events are **independent** if and only if $P(A,B) = P(A)P(B)$.

**Bayes Rule**, given a hypothesis $H$ and evidence $e$:

$$\underbrace{P(H|e)}_\text{posterior} = \frac{\underbrace{P(e|H)}_\text{likelihood} \underbrace{P(H)}_\text{prior}}{\underbrace{P(e)}_\text{normalizer}}$$

**Maximum a Posteriori** makes predictions by finding the hypothesis that maximizes the probability of evidence given a prior:

$$\begin{aligned}
h_{MAP} &= \operatorname*{argmax}_{h_i} P(h_i | e)\\
&= \operatorname*{argmax}_{h_i} P(h_i) P(e | h_i)
\end{aligned}$$

**Maximum Likelihood** makes predictions by selecting the hypothesis that makes the evidence the most likely:

$$h_{ML} = \operatorname*{argmax}_{h_i} P(e | h_i)$$

If you pick two probability distribution families for the likelihood and the prior and arrive at a posterior in the same family as the prior, then we call the prior family a **conjugate prior** for the likelihood family.

## Decision trees

### Training
Until either a maximum depth is reached or all remaining data gets grouped into the same leaf, add a decision tree node splitting on the feature that yields the highest information gain.

Given an event $E$ with a probability $P(E)$ of occurring, knowing for sure that $E$ will occur tells you $I(E) = \log_2\frac{1}{P(E)}$ bits of information.

Entropy sums all possibilities multiplied by the information gain each would yield:

$$\begin{aligned}
H(s) &= \sum_i^k p_i I(s_i)\\
&= \sum_i^k p_i \log\frac{1}{p_i}\\
&= - \sum_i^k p_i \log p_i\\
\end{aligned}$$

For binary classification, this simplifies to:

$$H(s) = -p_\oplus \log p_\oplus - p_\ominus \log p_\ominus$$

**Conditional entropy** is the expected number of bits needed to encode $y$ if the possible values of $x$ are known. This is done by taking the sum for each possible value of $x$ of the percentage of samples having that $x$ value in the set multiplied with the entropy of the set of samples having that $x$ value:

$$H(y | x) = \sum_v P(x = v) H(y | x = v)$$

### Prediction

Given an example $x$, step through the decision tree until a leaf node with a prediction is reached.

## $K$ Nearest Neighbours ($K$NN)

### Training

Store all training examples (e.g. in a $k$-d tree).

### Prediction

Define distance between samples, such as Euclidean distance. Any metric will do as long as:
- It is symmetric: $d(a, b) = d(b, a)$
- It is definite: $d(a, b) = 0 \text{ iff } a = b$
- Triangle inequality holds: $d(a,b) \le d(a,c) + d(c,b)$

Pick the closest $K$ stored training examples to the input according to the distance metric. Predict the most common label (or a random label of the possible tied most common labels) out of those $K$.

For **distance-weighted** $K$NN, compute a weight $w$ where $0 \le w \le 1$ for each of the $K$ nearest neighbours (e.g. based on distance.) Predict based on those weights, $\frac{\sum_i w_i y_i}{\sum_i w_i}$, instead of simply the most common label $y$. Example weight functions are $\frac{1}{c + d(a, b)^n}$ for some $c, n$ or $e^{-\frac{d(a,b)^2}{\sigma^2}}$.

## Perceptron

### Training

- For training data with $n$ features, prepend a 1 to each row of the training data matrix $X$ to add a bias term.
- Create a row vector $w$ ("weights") with size $n+1$, randomly initializing each element. $w_1$ is the bias.
- For each example, make a prediction (see below).
  - If we incorrectly predicted a 0 when the correct label was 1, add the input vector to the weight vector: $w' = w + \eta x$
  - If we incorrectly predicted a 1 when the correct label was 0, subtract the input vector to the weight vector: $w' = w - \eta x$
  - If we were correct, do nothing
- Repeat until stable

Intuitively, the non-bias terms of $w$ make a vector pointing toward the positive examples, normal to the decision plane. If an example was misclassified, it is because it was on the wrong side of the plane. The vector from the origin to the example should is in the opposite direction of $w$. So, adding it to $w$ makes the resulting $w'$ point slightly closer to that example than it did before.

### Prediction

Let $a = w \cdot x$. Then, we define the prediction $y$:

$$y = \begin{cases}1, &a \gt 0\\0, &a \le 0\end{cases}$$

### Concepts

- **Margin**: The distance from the boundary to the closest point.
- **Rosenblatt's Convergence Theorem**: For a margin $\gamma$ and assuming $||x|| \le 1 \forall x$, Perceptron training will converge after at most $\gamma^{-2}$ updates.
- **Voted Perceptron**: Keep track of how many training steps, $c$, each weight vector is stable for before it gets replaced. In prediction, predict using each weight vector, proportional to its $c$.
- **Averaged Perceptron**: Keep track of weight vectors and their $c$ as in Voted Perceptrons, and predict using the average weight vector, weighted proportional to the $c$ for each vector.

## Bayesian Linear Regression

### Training

We want to maximize the posterior probability of weights given labels and data. We typically minimize log of the probability, since it is easier to take the derivative of.

$$\begin{aligned}
P(w|y,X) &\propto \frac{P(y|w,X)P(w|X)}{P(y|x)}\\
P(w|x,y) &= \frac{\left(\prod_{i=1}^N P(y_i|x_i, w)\right)P(w)}{P(y|x)}\\
-\ln P(w|x,y) &= -\sum_{i=1}^N \ln P(y_i|x_i, w) - P(w)+\ln(y|x)\\
&= \frac{1}{2\sigma^2}\sum_{i=1}^N(y_i - f(x_i))^2 + \frac{\alpha}{2}||w||^2 + C\\
\end{aligned}$$

From this point, take the derivative, equate to 0, and solve.

### Prediction

We don't estimate a single $w$. Instead, we average all possible models, weighting different models according to their posterior probability.

## Naive Bayes classification

### Training
The point of generative learning is to find $P(y|x)$ by estimating $P(x|y)$ and $P(y)$. Generally, this would be the calculation for $P(x|y)$:

$$\begin{aligned}
P(x|y) &= P(x_1, x_2, ..., x_m | y)\\
&= P(x_1|y)P(x_2|y,x_1)P(x_3|y,x_1,x_2) ... P(x_m|y,x_1,x_2,...,x_{m-1})\\
\end{aligned}$$

Instead, we introduce the **Naive Bayes** assumption that $P(x_i, x_j) = P(x_i)P(x_j), i \ne j$, treating all features as conditionally independent, giving us instead:

$$P(x|y) = \prod_{i=1}^m P(x_i|y)$$

We define probabilities:
- $\theta_1 = P(y=1)$
- $\theta_{j,1} = P(x_j = 1 | y = 1)$
- $\theta_{j,0} = P(x_j = 1 | y = 0)$

Then, find parameters that maximize log-likelihood:

$$\begin{aligned}
P(y|x) &\propto P(y)P(x|y)\\
&= \prod_{i=1}^n\left(P(y_i) \prod_{j=1}^m P(x_{i,j}|y_i)\right)\\
&\propto \sum{i=1}^n\left(\ln P(y_i) + \sum{j=1}^m \ln P(x_{i,j}|y_i)\right)\\
&\propto \sum{i=1}^n\left(y_i \log \theta_1 + (1-y_i) \log(1 - \theta_1)\right)\\
&\quad + \sum_{j=1}^m y_i\left(x_{i,j}\log\theta_{i,1} + (1-x_{i,j})\log(1 - \theta_{i,1})\right)\\
&\quad + \sum_{j=1}^m (1-y_i)\left(x_{i,j}\log\theta_{i,0} + (1-x_{i,j})\log(1 - \theta_{i,0})\right)\\
\end{aligned}$$

For discrete classification, choose Bernoulli distributions for $\theta$ values. For continuous values, choose Gaussian.

### Prediction

Calculate the probabilities of $P(y=c)$ for each class $c$.

### Other properties

The decision boundary can be found by checking where $\frac{P(y=1|x)}{P(y=0|x)} = 1$, or for easier computation, $\ln \frac{P(y=1|x)}{P(y=0|x)} = 0$.

**Laplace smoothing**: add an addition of a constant into the numerator and the denominator of the maximum likelihood estimator to avoid a probability ever going to zero, acting as hallucinated examples.
