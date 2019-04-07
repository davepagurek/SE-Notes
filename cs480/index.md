# CS480: Machine Learning

## Core concepts

- **Supervised learning**: Learning given a set of training data and expected results (labels)
- **Unsupervised learning**: Given training data but no labels, cluster the samples based on their contained data
- **Reinforcement learning**: Learning by rewarding favourable results or punishing unfavourable results
- **Inductive bias**: The implicit biases different techniques come in with, e.g. $K$NNs assume new examples should probably behave similarly to similar past data
- **Bias**: How close to the truth a model can actually get (more bias implies farther mean distance from the ideal)
- **Variance**: Regardless of how close to the truth a model gets, how consistent the predictions are
- **Cross-validation**: Average performance by splitting the data into $K$ groups, and for each $K$, using that group as validation data and the rest as training data

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

### Closed-form solution

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

## Margins

**Functional margin**:

$$\hat{\gamma}_i = y_i(w^T x_i + b)$$

If $y_i$ and our prediction $w^T x_i + b$ have the same sign, the functional margin $\hat{\gamma}_i$ will be positive. A large functional margin means a confident and correct prediction.

The functional margin of a training set is the minimum functional margin of individual training examples.

**Geometric margin**:

$$\gamma_i = y_i \left(\frac{w^Tx_i + b}{||w||}\right)$$

This refers to the distance between the hyperplane and a point.

The geometric margin of a training set is the minimum distance between the hyperplane and any point in the training set.

## Kernalizing

- Replace instances of $x$ with the feature mapping $\phi(x)$
- Rewrite to depend on a dot product of the mapped features.
  - For Perceptrons, since $w$ can always be written as a linear combination of $\phi(x_i)$ for all $i$, we can make the prediction depend on dot products between mapped features and not an explicit weight vector:
  - $w\cdot\phi(x)+b = \left(\sum_{i=1}^n \alpha_i \phi(x_i)\right)\cdot \phi(x)+b = \sum_{i=1}^n \alpha_i(\phi(x_i) \cdot \alpha(x)) + b$
- Then, the dot product can be replaced with a kernel $K$

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

## K Nearest Neighbours (KNN)

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

## Support Vector Machines (SVNs)

### Training

We are attempting to maximize the geometric margin of a data set. We look for:

$$\max_{w, b} \frac{1}{||w||}, \quad y_i(w^Tx_i+b) \ge 1 \quad \forall i \in \{1, ..., n\}$$

We use **Lagrangian optimization**. In general, we want:

$$\min_w f(w), \quad g_i(w) \le 0 \forall i, \quad h_i(w) = 0 \forall i$$

Then, we define the **generalized Lagrangian**:

$$L(w, \alpha, \beta) = f(w) + \sum_{i=1}^k \alpha_i g_i(w) + \sum_{i=1}^k \beta_i h_i(w)$$

The **primal problem** is defined:

$$\begin{aligned}
\theta_P(w) &= \max_{\alpha,\beta: \alpha_i \ge 0} L(w, \alpha, \beta)\\
&= \begin{cases}f(w),&w\text{ satisfies all constraints}\\\infty,&\text{otherwise}\end{cases}\\
\end{aligned}$$

We are concerned with finding:

$$p^* = \min_w \theta_P(w) = \min_w \max_{\alpha,\beta: \alpha_i \ge 0} L(w, \alpha, \beta)$$

Instead of minimizing $w$ first, we can minimize with respect to $w$:

$$d^* = \max_{\alpha,\beta: \alpha_i \ge 0} \theta_D (\alpha,\beta) = \max_{\alpha,\beta: \alpha_i \ge 0} \min_w L(w, \alpha, \beta)$$

The max min of a function is always less than the min max of the function, so $d^* \le p^*$. Under the following conditions, the **Karush-Kuhn-Tucker (KKT) conditions**, we can determine that they are equal:
- $\frac{\partial}{\partial w_i} L(w^*, \alpha^*, \beta^*) = 0, \quad i = 1,...,n$
- $\frac{\partial}{\partial \beta_i} L(w^*, \alpha^*, \beta^*) = 0, \quad i = 1,...,l$
- $\alpha_i^* g_i(w^*) = 0, \quad i = 1,...,k$ (dual complementarity)
- $g_i(w^*) \le 0, \quad i = 1,...,k$ (primal feasibility)
- $\alpha^* \ge 0, \quad i = 1,...,k$ (dual feasibility)

e.g. to minimize $x^2$ subject to $(x-2)^2 \le 1$:
- $L(x, \lambda) = x^2 + \lambda((x-2)^2 - 1)$
- To solve the primal problem:
  - Take $\frac{\partial}{\partial \lambda} L(x, \lambda) = 0$
  - Solve for where $x = 0$
  - Plug $x$ back in to get the optimal value $p^*$
- To solve the dual problem:
  - Solve $\frac{\partial}{\partial x} L(x, \lambda) = 0$ for $x^*$ in terms of $\lambda$
  - Plug $x^*$ back into $L$ to get the dual formula $g$
  - Solve $0 = \frac{\partial L}{\partial \lambda}$ for $\lambda$
  - Plug that value back into $g$ to get the optimal value $d^*$

To solve an optimal margin classifier, we want to solve $\min_{w,b}\frac{1}{2}||w||^2$, subject to $y_i(w^Tx_i+b) \ge 1$, $i=1,...,n$. We can rewrite the constraints as $g_i(w) = 1 - y_i(w^Tx_i+b) \le 0$ and solve the Lagrangian problem.

The dual formulation:

$$\max_\alpha \underbrace{\sum_{i=1}^n \alpha_i}_{\text{Depends only on}\\\text{dual variable}} - \underbrace{\frac{1}{2} \sum_{i,j=1}^n y_iy_j\alpha_i\alpha_j(x_i^T x_j)}_\text{Depends only on data}$$

We replace $x_i^T x_j$ with a kernel $K(x_i, x_j)$ so that different kinds of nonlinearities can be represented. The kernel function is equivalent to $\phi(x_i)^T\phi(\hat x)$, for some feature mapping $\phi$. The dot product form is useful because it can be many less operations than actually computing the full multiplication. Some kernels:
- **Linear**: $K(x,z) = x \cdot z$
- **Polynomial**: $K(x,z) = (1 + x \cdot z)^d$
- **Gaussian**: $K(x,z) = \exp\left(-\frac{||x-z||^2}{2\sigma^2}\right)$

Due to the dual complementarity condition, we either have $\alpha_i = 0$ or $1 - y_i(w^Tx_i+b) = 0$. Only constraints where the latter is true are "active" constraints, and these are the **support vectors**. They are points lying on the edge of the margin.

To allow for not all constraints to be met, soften the primal problem by using non-infinite values in the loss function, such as quadratic loss or hinge loss.

## Ensemble Learning

### Bagging

Multiple versions of the same model are trained on different datasets. Given an initial dataset $D$, sample from it with replacement to create a bootstrapped dataset $D_*$ for each model instance. Take the average or majority prediction.

Tends to reduce variance but increase bias.

### Random Forests

- Create $K$ different bootstrapped datasets to create $K$ decision trees
  - At each node, pick $m$ features to possible switch on, and pick the one that yields highest information gain
- Combine majority or average vote from all trees

### Boosting (AdaBoost)

- Create a bunch of weak learners (ever so slightly better than random)
- Weight the misclassified examples more when training the next weak learner
- Decide in aggregate from all Weighted weak learners

For $m$ samples:
- Initialize weights $D_1(i) = \frac{1}{m}$
- For $t = 1, ..., T$:
  - Train weak learner with weights $D_t$
  - Get error $\epsilon_t = \sum_{i: h_t(x_i) \ne y_i} D_t(i)$ (the sum of the weights for the misclassified examples)
  - Get $\alpha_t = \frac{1}{2} \ln \left(\frac{1-\epsilon_t}{\epsilon_t}\right)$
  - Set $D_{t+1}(i) = \frac{D_t(i)}{Z_t} \times \begin{cases}e^{-\alpha_t}, &h_t(x_i) = y_i \\ e^{\alpha_t}, &h_t(x_i) \ne y_i \end{cases}$
    - $Z_t$ is picked so $\sum_i D_t(i) = 1$
- Assuming classes are $\{1, -1\}$, then the final output is the sign of the sum of the predictions of every weak learner

## Active Learning

Learning how to take samples to achieve the best results

### Pool-based Uncertainty Sampling

Given a pool of unlabelled samples, ask the oracle for a label on the most uncertain one.

When using **version spaces**, pick samples that will eliminate half of the possible model parameters.

### Query by Committee

Train multiple models, and query instances for which committee members disagree.

Disagreement metrics:
- Vote Entropy: $x_{VE}^* = \operatorname*{argmax}_x - \sum_y \frac{\text{vote}_C(y,x)}{|C|} \log \frac{\text{vote}_C(y,x)}{|C|}$
  - $\text{vote}_C(y,x)$ is the number of times $x$ is classified as $y$ by committee members
- Soft Vote Entropy: $x_{SVE}^* = \operatorname*{argmax}_x - \sum_y P_C(y|x) \log P_C(y|x)$
  - $P_C(y|x)$ is the probability of $x$ being labelled $y$ by committee members
- KL divergence: $x_{KL}^* = \operatorname*{argmax}_x \frac{1}{C} \sum_{\theta \in C} \sum_y P_\theta(y|x) \log \frac{P_\theta(y|x)}{P_C(y|x)}$
  - Average divergence of each committee member's $\theta$ prediction from the consensus

Dealing with outliers
- Density weighting: $x^* = \operatorname*{argmax} H_\theta(Y|x) \left(\frac{1}{U} \sum_{x' \in U} \text{sim}(x, x')\right)^\beta$
  - $\text{sim}(x, x')$ is the average similarity of $x$ to all other instances in the pool $U$
  - $\beta$ is the importance of the density term
- Estimated error reduction: $\operatorname*{argmax}_x \sum_{x' \in U} \left(H_\theta(Y|x') - E_{Y|\theta,x}[H_{\theta^+}(Y|x')]\right)$
  - $H_\theta(Y|x')$ is the uncertainty before the query
  - $E_{Y|\theta,x}[H_{\theta^+}(Y|x')]$ is the expected uncertainty after querying for $x$

## Unsupervised Learning

### K-Means Clustering
- Pick desired number of clusters $K$
- Assume a distribution for each class (e.g. Gaussian)
- Randomly assign parameters for each distribution
- Iterate until Convergence:
  - Assign instances to the most likely class given current parameters (expectation)
  - Estimate new parameters given the elements last assigned to each class (maximization)

Picking $K$:

$$\begin{aligned}
W(K) &= \sum^K_{k=1}\sum_{i \in I_k} ||x_i-\bar{x}_k||^2\\
B(K) &= \sum_{k=1}^K n_k ||\bar{x}_k - \bar{x}||^2\\
CH(K) &= \frac{B(K)/(K-1)}{W(K)/(N-K)}\\
K^* &= \operatorname*{argmax}_{K \in \{2, ..., K_{max}\}} CH(K)\\
\end{aligned}$$

### Hierarchical Clustering

Linkage (dissimilarity) functions:
- Single: $d(G,H) = \min_{i\in G, j\in H} d_{i,j}$
- Complete: $d(G,H) = \max_{i\in G, j\in H} d_{i,j}$
- Average: $d(G,H) = \frac{1}{n_G \cdot n_H} \sum_{i\in G, j\in H} d_{i,j}$

Algorithm:
- Until there are only two classes left:
  - Create a matrix of linkages between each pair
  - Take the argmin element and combine the classes for its row and column into a bigger class

### Principal Component Analysis (PCA)
- Normalize features (so each has zero mean)
- Compute covariance matrix
- Compute eigenvectors
- Keep first $k$ eigenvectors and project onto them to get new features $z$

## Semi-Supervised Learning

### Self-Learning
- Initially set $L$ equal to labelled training data and $U$ equal to all unlabelled data
- Repeat:
  - Train on $L$
  - Apply classification to a subset of $U$
  - Move that subset from $U$ to $L$ with the applied labels

### Co-Training
- Train two classifiers: $f_1$ from $(X_1, Y)$ and $f_2$ from $(X_2, Y)$
- Classify unlabelled data with $f_1$ and $f_2$
- Add $f_1$'s $k$ most confident to $f_2$'s labelled data
- Add $f_2$'s $k$ most confident to $f_1$'s labelled data
- Repeat

Assumes:
- Each view alone is sufficient to make good predictions
- The two views are conditionally independent given the class label

### Gaussian Mixture Model (GMM)

Assumes data is generated by:
- Picking a single Gaussian source out of many sources, given weights for each
- Generating a value from that single Gaussian distribution given its parameters

With labelled data:
$$\begin{aligned}
\log (D|\theta) &= \log \prod_{i=1}^l p(x_i, y_i | \theta)\\
&= \log \prod_{i=1}^l p(y_i | \theta) p(x_i | y_i, \theta)\\
\end{aligned}$$

With labelled and unlabelled data:
$$\begin{aligned}
\log (D|\theta) &= \log \prod_{i=1}^l p(x_i, y_i | \theta) \prod_{i=l+1}^{l+u} p(x_i | \theta)\\
&= \log \prod_{i=1}^l p(y_i | \theta) p(x_i | y_i, \theta) \prod_{i=l+1}^{l+u} \sum_{k=1}^K p(y_i = k | \theta) p(x_i | y_i, \theta)\\
\end{aligned}$$

#### For 2-class GMM, Expectation  Maximization
Expectation step:
$$\gamma_{i,k} \leftarrow P(y_i = k | x_i) = \frac{\pi_k \mathcal{N}(x_i; \mu_k, \sigma_k)}{\sum_{k'=1}^2 \pi_{k'} \mathcal{N}(x_i; \mu_{k'}, \sigma_{k'})}$$

Maximization step:
$$\begin{aligned}
\mu_k &\leftarrow \frac{1}{\sum_{i=1}^N \gamma_{i,k}}\sum_{i=1}^N \gamma_{i,k}x_i\\
\sigma_k &\leftarrow \frac{1}{\sum_{i=1}^N \gamma_{i,k}} \sum_{i=1}^N \gamma_{i,k} (x_i - \mu_k)^2\\
\pi_k &\leftarrow \frac{1}{N} \sum_{i=1}^N \gamma_{i,k}\\
\end{aligned}$$

### Other methods

Graph-based
- Edges have similarity weights

Semi-supervised SVM
- $\min_{w,b} \sum_{i=1}^l \max(1-y_i(w^T x_i + b), 0) + \lambda_1 ||w||^2 + \lambda_2 \sum_{j=l+1}^{l+u} \max(1 - |w^T x_j + b|, 0)$
- Prefer unlabelled points outside the margin

## Neural Networks

$\sigma(x) = \frac{1}{1 + e^x}$

$\frac{\partial \sigma(x)}{\partial x} = \sigma(x)(1-\sigma(x))$

Gradient descent:

$$\begin{aligned}
E &= \frac{1}{2} \sum_{m \in M} (y^{(m)} - o^{(m)})^2\\
\frac{\partial E}{\partial w_i} = \frac{1}{2} \sum_{m \in M} \frac{\partial E \partial o^m}{\partial o^m \partial w_i}\\
&= \frac{1}{2}\sum_{m \in M} \frac{\partial E}{\partial o^m}\left(\frac{\partial o^m \partial z}{\partial z \partial w_i}\right)\\
&= -\sum_{m \in M} x_1^{(m)} o^{(m)} (1 - o^{(m)})(y^{(m)} - o^{(m)})\\
\Delta w_i &= -\epsilon \frac{\partial E}{\partial w_i}\\
\end{aligned}$$
