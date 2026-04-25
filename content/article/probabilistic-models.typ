#import "/typ/templates/blog.typ": *
#show: main.with(
  title: "Probabilistic Models",
  desc: "",
  date: "2026-04-12T22:10:59-04:00",
  tags: ("notes",),
)

#show: note_page

= Exact Sampling
== Rejection Sampling
You want to draw samples from distribution $p(x)$ but you can only draw samples from $q(x)$. Luckily, you can engineer $q(x)$ to cover the domain of $p(x)$, and there exists $C$ such that $C q(x) >= p(x) semi forall x$. The idea is to sample from $q$, and keep the sample with probability $p(x)/(C q(x))$.
$
  P("Accept") = integral 1/C p(x)/q(x) q(x) = 1/C \
  P(x | "Accept") = (p("Accept" | x)p(x))/p("Accept") = C(1/C (p(x))/q(x) q(x)) = p(x)
$

== Speculative Decoding
This is sort of like Rejection sampling, except we can actually compute $p(x)$, we just would prefer not too. This shows up in LLMs, where you have cheap models with distributions close to the base model, and you want to mainly sample from the cheap models.

You accept with probability
$
  min(p(x)/q(x), 1)
$

If you reject, you sample from 
$
  f(x) prop p(x) - min(p(x), q(x))
$

We can analyze this with the law of total probability.
$
  P("Accept") = integral min(p(x)/q(x), 1) q(x) = C \
  P("Accept")P(x | "Accept") = C(1/C min(p(x), q(x))) = min(p(x), q(x)) \
  P("Reject")P(x | "Reject") = (1 - C)(p(x) - min(p(x), q(x)))/(1 - C) \
  P(x) = p(x)
$

== Importance Sampling
The setting here is you want to compute some functional of the distribution $p$, but you can only draw samples from distribution $q$.
$
  integral f(x) p(x) = integral f(x) (p(x))/(q(x)) q(x) approx 1/N sum f(x) (p(x))/(q(x)) 
$ 

= MCMC Sampling
The basic idea here is you have a proposal distribution $q(y|x)$ and an acceptance probability $a(y|x)$. We'll start with some random $x$, and go through several proposal acceptance rounds, and at the end we want our iterate to look like a sample of $p(x)$. The trick is to view a proposal-acceptance round as a _transition operator_ and then ensure 
+ The operator has a stationary distribution.
+ The operator has exactly one stationary distribution.
+ The operator, when iterated, converges to the stationary distribution.
+ The stationary distribution matches $p(x)$.

== Stationary Distribution Existence
To ensure a stationary distribution exists, it suffices to make your transition operator a random walk. An informal argument is as follows.
+ What's the maximum an operator can scale the L2 norm of an input distribution? Well, it cannot change the L1 norm (which is 1) and that upper-bounds the L2 norm. Thus, eigenvalues of this operator are at most norm 1.
+ Is it possible for all eigenvalues to have norm less than $1$? No, because then the transition matrix would necessarily scale down the L2 norm of the input, which would eventually force the L1 norm down as well, which random walks cannot change.
+ Therefore, there must exist a vector with eigenvalue $1$, a stationary distribution.

== Stationary Distribution Uniqueness 
To show there's only one stationary distribution you just need to show after some number of steps, every state has a probability of reaching every other state. This is called *irreducability*. To see this, observe
+ Suppose state $a$ will never after any number of transitions go to state $b$. Then, I can find the stationary distribution for the component connected to $a$, and a stationary distribution for just state $b$, and any combination of the two yields a new stationary distribution for the whole system.
+ Suppose there are two stationary distributions. Then 
  $
    (theta pi_1 + (1 - theta) pi_2)T = theta pi_1 + (1 - theta) pi_2
  $
  That is, any affine combination of the two distributions is stationary, although the weights need to add to $1$ to ensure it's still a distribution. Consider the state where $pi_2 slash pi_1$ is the largest. By subtracting just the right amount of $pi_1$, we can zero out the probability for that state, while keeping all other probabilities positive and still have a valid distribution. But that's a contradiction, because after some number of transitions, there has to be non-zero probability mass on every state.

== Stationary Distribution Convergence
// Uniquesss ensures only one eigenvalue of value 1, but there are still unbounded numbers with -1 or complex.
To ensure you converge to _a_ stationary distribution, you need to ensure after some number of steps, the probability of being in a given state given any starting state is non-zero. This is called *aperiodicity*. An informal argument:
+ Consider the stationary distribution and some other distribution.
+ Sample a bunch of _paired_ trajectories from both.
+ Observe that after some amount of time, there is a non-zero probability that you can be in any state (*aperiodicity*) so there is a non-zero probabilty a given pair entered the same state.
+ After entering the same state, that specific pair will stick together forever.
+ Thus, in the limit every trajectory from the distributions will coincide exactly.

== Stationary Distribution Correctness
#definition(name: "Detailed Balance")[
  Let $pi$ be a distribution, and let $T$ be a transition operator where $T_(i j)$ gives the probability of transitions from state $i$ to state $j$.
  $
    pi_i T_(i j) = pi_j T_(j i)
  $
]

Intuitively, this is saying there is no net probability flow across every transition. This forces $pi$ to be a stationary distribution 

#theorem[
  A distribution which satisfies detailed balance is a stationary distribution.
]
#proof[
  $
    (pi T)_i = sum_j pi_j T_(j i) = sum_j pi_i T_(i j) = pi_i sum_j T_(i j) = pi_i
  $
]

So if we can show a distribution $p(x)$ satisfies detailed balance for $T$, then $T$ has the right stationary distribution. Note that detailed balance is sufficient but not necessary.

== Metropolis Hastings
The idea is to make our proposal distribution choose "nearby" states, and make our acceptance probability a function of the target probabilities. Specifically...
$ q(j|i) = q_(i j) quad a(j|i) = min((p_j q_(j i))/ (p_i q_(i j)), 1) $

We can easily verify detailed balance.
$
  p_i T_(i j) = p_i q_(i j) min((p_j q_(j i)) / (p_i q_(i j)), 1) = p_j q_(j i)  min((p_i q_(i j)) / (p_j q_(j i)), 1) = p_j T_(j i)
$

All the other necessary properties can be verified easily.

== Gibb's Sampling
The idea here is to fix all variables bar one and sample from the marginal distribution. Again, we can verify detailed balance.
$
  p_x T_(x y) = 1/L p_x p(x_i = Y | x_(not i)) = 1/L p_x p(x_i = Y, x_(not i))/p(x_(not i)) = \
  1/L (p_x p_y) /p(x_(not i)) =  1/L p_y (p_x) /p(x_(not i)) = 1/L p_y p(y_i = X, y_(not i))/p(x_(not i)) =  p_y T_(y x)
$

== Temperature Annealing
The problem with Metropolis Hastings methods is they tend to get stuck in regions of high probability. Asymptotically they still has the desired stationary distribution, but it can take many steps until convergence. The idea of this method is to sometimes take steps along higher temperature distributions, which allow escaping high density regions.

We'll take a step in the current chain with probability $1/2$, and otherwise copy our state either to the chain above or below us. Detailed balance within a chain is pretty straightforward.
$
  1/2 1/L (product p_i (x_i) )T_(x, y) = \
  1/(2L) (product p_i (x_i) )min( (p_i (y_i))/(p_i (x_i)), 1) = 1/(2L) (product p_i (y_i) )min( (p_i (y_i))/(p_i (x_i)), 1) = \
  1/2 1/L (product p_i (y_i) )T_(y, x)
$

Detailed balance across chains is the exact same. To extract a sample from the chain with the desired temperature you just throw away the samples from the other chains.


// TODO: HMC. AIS.

= Optimization
== Contrastive Divergence <contrastive-divergence>
Suppose we want to optimize a distribution. The most obvious idea is to just run the MLE.
$
  argmax_theta EE_(p_"data") log(q_theta (x)) \
  nabla_theta EE_(p_"data") log(q_theta (x)) = nabla_theta EE_(p_"data") (-E_theta (x) - log(Z_theta)) = \
  - EE_(p_"data") E'_theta (x) - (Z'_theta) / (Z_theta) = 
  - EE_(p_"data") E'_theta (x) -  1/(Z_theta) integral -exp(-E_theta (x))E'_theta (x) dif x = \
  - EE_(p_"data") E'_theta (x) + EE_(q_theta) E'_theta (x)
$

You can use any of the sampling methods to deal with the second term.

== Gibb's Variational Principle <gibbs>
Let $p(x) = 1/Z exp(-E(x))$. Our goal is to estimate $Z$, the normalization constant. 
#theorem[$
  log(Z) = max_q (H(q) - EE_(x tilde q) E(x))
$]
#proof[
  Just use the method of Lagrange multipliers.
  $
    max_q (integral -log(q(x)) q(x) dif x - integral E(x)q(x) dif x + C (integral q(x) dif x - 1)) \ 
    (C - 1 - log(q(x)) - E(x)) dif x = 0 \ 
    q(x) = 1/Z exp(- E(x)) \
    H(q) - EE_(x tilde q) E(x) = EE_(x tilde q) - (-E(x) - log(Z)) - EE_(x tilde q) E(x) = log(Z)
  $
]

Using this principle, we can immediately obtain an upper and lower-bound on the normalization constant. If we maximize $q$ over a subset of valid distributions, we get a lower-bound, and if we maximize $q$ over a super-set (e.g. some distributions which aren't actually valid probability distributions) we obtain an upper-bound.

This is sometimes useful by itself (e.g. if you actually want to evaluate the probability of a sample), but the more useful case is for computing posteriors.
#corollary[
  $
    p(z|x) = argmax_q H(q(z|x)) + EE_(x tilde q(z|x)) log(p(z, x))
  $
]

We can directly try to maximize the above formulation without making any mention of normalization constants.

You can also view these statements as KL minimizations.
$
  argmin_q "KL"(q(z|x), p(z, x)) = argmin_q EE_(z tilde q(z|x)) log(q(z|x)) - EE_(z tilde q(z|x)) log (p(z, x)) \
  argmax H(q(z|x)) + EE_(x tilde q(z|x)) log(p(z, x))
$

This is nice because when we restrict the possible $q$s, it now has a sensible interpretation, we're just finding the closest $q$ in the family we have to the target distribution.

We can also write the following, since the $p(x)$ term is not a function of $q$.
$
 argmin_q "KL"(q(z|x), p(z, x)) = EE_(z tilde q(z|x)) log(q(z|x)) - log(p(z, x)) \ 
 EE_(z tilde q(z|x)) log(q(z|x)) - log(p(z, x))
$

This is everyone's favorite optimization objective: the ELBO! This is precisely what VAEs optimize.

#definition(name: "VAE Optimization Objective")[
  $ max_theta max_phi sum_(x in "dataset") EE_(z tilde q(z|x)) log(q_theta (z|x)) - log(p_phi (z, x)) $
]

== Coordinate Ascent Variational Inference
The @gibbs gives us a way to estimate posteriors without normalization constants. We can further increase the problem tractability by using what's known as a mean-field approximation. Essentially, we're going to restrict $q_theta$ such that
$
  q_theta (z | x) = product_i q^i_theta (z_i | x)
$

Now, we can use coordinate ascent to optimize the ELBO with respect to each term independently. The algorithm becomes
+ Optimize the ELBO with respect to a single $q^i_theta$.
+ If the ELBO has stopped improving quit, otherwise switch to a different $i$.

Sometimes step 1 has a closed form. To see this, observe...
$
   argmin_(q_i (z_i|x)) "KL"(q(z|x), p(z, x)) = \ 
   argmin_(q_i (z_i|x)) integral product_j q_j (z_j|x) (log(p(z, x)) - sum_j log(q_j (z_j|x))) = \
   argmin_(q_i (z_i|x)) integral q_i (z_(i)|x) (EE_(q_i (z_(not i)|x)) log(p(z, x)) - log(q_i (z_i|x))) = \ 
   argmin_(q_i (z_i|x)) "KL"(q_i (z_i|x), exp(EE_(q_i (z_(not i)|x)) log(p(z, x)))) prop \
   exp(EE_(q_i (z_(not i)|x)) log(p(z, x)))
$

$p$ gives a distribution over latents, $q$ gives a distribution over latents, and with good modeling choices, this final expression can be the same type of distribution as $q$. This allows you to directly read off the optimal parameters for $q$, no gradient descent required.

You can also run CAVI without this by directly minimizing the KL. The only real trick there is you need to be able to differentiate through expectations, which I cover later.

== Expectation Maximization
@contrastive-divergence works decently if you observe the full state of a system. However, sometimes there are unobserved pieces of data (latents) which have a causal influence on the data and it's useful to be able to model those.
$
  argmax_theta EE_(x tilde p_"data") log(p_theta (x)) =
  argmax_theta EE_(x tilde p_"data") log(integral p_theta (x, z)dif z)
$

Unfortunately, that inner integral is pretty difficult to evaluate. Without major restrictions on $p_theta$, we won't be able to marginalize out the Latents. So let's relax the problem.
$
  log(integral p_theta (x, z) q(z)/q(z) dif z) >=_"Jensen's" 
  integral (log(p_theta (x, z)) - log(q(z)) q(z) dif z =\
  H(q (z)) + EE_(z ~ q(z))log(p_theta (x, z))
$

Looking at the @gibbs, the choice of $q(z)$ which maximizes this inner quantity (e.g. the tightest lower-bound) is $p_theta (z|x)$.

At that particular choice of $q$ the left-hand side becomes 
$
  log(EE_(p(z|x)) (p_theta (x, z)) / (p(z|x)) dif z) = log(EE_(p(z|x)) p(x) dif z)
$

Jensen's is tight for constants, so our particular choice of $q$ actually yields an _equality_.

Now, let's replace the inner integral in the original formulation with the expression we just derived.
$
  argmax_theta EE_(x tilde p_"data") H(p_(theta) (z|x)) + EE_(p_(theta_t) (z|x))log(p_theta (x, z)) \
  argmax_theta EE_(x tilde p_"data") (EE_(p_(theta) (z|x))log(p_theta (x, z))) \
  argmax_theta EE_(x tilde p_"data") (EE_(p_(theta) (z|x))log(p_theta (x, z)))
$

Now the hard part is maximizing with respect to the inner expectation. We can do a coordinate-ascent style trick as follows.
+ Compute the inner expectation treating $p_theta (z|x)$ as fixed to obtain some function of theta: $Q(theta)$ (choose $p(z|x)$ is be easy to sample from).
+ Maximize $Q(theta)$ to derive a new $theta$, then return to step 1.

This actually converges to the true optimum. The rough intuition is the maximization step increases the ELBO (a.k.a $Q(theta)$), and the expectation step improves the value of $Q(theta)$ all the way up to the true likelihood. Combined, they monotonically force the likelihood up. Only at the optimum can either step stall.


== Differentiating Distributions
Suppose we're trying to optimize 
$
  EE_(q_theta) f_theta (x)
$

One notable example where this show up is if you're trying to optimize a KL with respect to a parameterized distribution. 

Here's one method, called the score estimator (for reasons we will soon see).
$
  nabla EE_(q_theta) f_theta (x) = nabla integral f_theta (x) q_theta (x) =  integral f'_theta (x) q_theta (x) + integral f_theta (x) q'_theta (x) \
  EE_(q_theta)(f'_theta (x)) + integral f_theta (x) nabla log(q_theta (x)) q_theta (x) = \
  EE_(q_theta)(f'_theta (x)) + EE_(q_theta) (f_theta (x) nabla log(q_theta (x)))
$

The gradient log is called the score. As usual, you can compute the expectations using monte-carlo estimators.

Another approach is construct $h$ such that $h(theta, epsilon) tilde q_theta$. Then our problem becomes...
$
  nabla EE_(epsilon) f_theta (h(theta, epsilon)) =
  integral f'_theta (h(theta, epsilon)) h'(theta, epsilon) p(epsilon) = EE_epsilon f'_theta (h(theta, epsilon)) h'(theta, epsilon)
$

These are two very different estimators! In general, neither dominates the other, but for specific settings one might be better than the other.

== Score-Matching
The idea of score-matching is simple.
$
  argmin_theta EE_(p_"data") norm(nabla_x log(q_theta (x)) - nabla_x log(p_"data" (x)))^2 
$

The motivation is we know how to sample from a distribution if we have its score, using Langevin sampling. Learning the score also helps us skirt estimating normalization constants.

We can rewrite the inner term as follows $
  EE_(p_"data") norm(nabla_x log(q_theta (x)))^2 - 2 (nabla_x log(q_theta (x)))^top (nabla_x log(p_"data" (x))) + norm(nabla_x log(p_"data" (x)))^2
$

Dropping the term independent from $theta$ we obtain: 
$
  => argmin_theta  EE_(p_"data") norm(nabla_x log(q_theta (x)))^2 - 2 (nabla_x log(q_theta (x)))^top (nabla_x log(p_"data" (x)))
$

To compute this, observe the first term is simple.
$
  norm(nabla_x log(q_theta (x)))^2 = norm(nabla_x (-E_theta (x) - log(Z)))^2 = norm(nabla_x E_theta (x))^2 
$

The second term is tricky because we don't have a way to estimate the score at data points. Here's the workaround.
$
  EE_(p_"data") (nabla_x log(q_theta (x)))^top (nabla_x log(p_"data" (x))) = \
  sum_i EE_(p_"data")  (d/(d x_i) log(q_theta (x))) (d/(d x_i) log(p_"data" (x)))
$

Zeroing in on this expectation...
$
  integral (d/(d x_i) log(q_theta (x))) (d/(d x_i) log(p_"data" (x))) p_"data" (x) = \
  integral (d/(d x_i) log(q_theta (x))) (d/(d x_i) p_"data" (x)) = \
  integral [(d/(d x_i) log(q_theta (x))) p_"data" (x)]_(x_i=-infinity)^(x_i=infinity) - integral d^2/(d^2 x_i)log(q_theta (x)) p_"data" (x) = \
  0 - EE_(p_"data") d^2/(d^2 x_i)log(q_theta (x)) = EE_(p_"data") d^2/(d^2 x_i) E_theta (x)
$

The third line is where all the magic happened. All we did was use integration by parts, and in the fourth line we dropped the bracketed term under mild assumptions (the energy function and $p_"data"$ go to 0 as $x$ gets extreme). Plugging this result in we obtain...

$
  EE_(p_"data") (nabla_x log(q_theta (x)))^top (nabla_x log(p_"data" (x))) = EE_(p_"data")  ("TR"(nabla^2_x E_theta (x)))
$

The naive way of doing this requires running several backwards passes, one per each diagonal element. There's a neat trick called sliced score matching which reduces the overhead. Specifically, change the objective function to...
$
  argmin_theta EE_(v tilde p_v) EE_(p_"data") (v^top nabla_x log(q_theta (x)) - v^top nabla_x log(p_"data" (x)))^2 
$

If you choose $p_v$ such that $v v^top = I$, it's easy to verify that the objective actually remains unchanged. 

$
  EE (v^top a)^2 = EE (v^top a)(v^top a) = EE a^top v v^top a = a^top I a = norm(a)^2
$

If you perform the same analysis, you'll find you only need the following to compute your estimates
$
  "TR"(H_x v v^top) = ip(H_x v, v) = ip(nabla_x J_x v, v)
$

So in other words, run one forward pass, do a backwards pass, do a weighted sum of all the gradient updates, then do a backwards pass again and dot with $v$. This reduces the number of backwards passes from $d$ to 2. You can also use #link("https://en.wikipedia.org/wiki/Automatic_differentiation")[forward mode differentiation] to compute everything in one pass. This trick is known as the #link("https://docs.backpack.pt/en/master/use_cases/example_trace_estimation.html")[Hutchinson Trace Estimator].

== Denoised Score Matching
If we stare at the score matching objective you might see a problem.
$
  argmin_theta EE_(p_"data") norm(nabla_x log(q_theta (x)) - nabla_x log(p_"data" (x)))^2 
$
This loss only care about matching the score at _data points in the training set_. There's no incentive to make the score smooth around those points, or to accurately track the scores in less populated regions.

The trick to alleviating this is to force the model to learn the scores at different noise levels, analogous to Annealed Temperature Sampling. Something like...
$
  argmin_theta 1/L sum EE_(p_("data", i)) norm(nabla_x log(q_(theta, i) (x)) - nabla_x log(p_("data", i) (x)))^2 
$

Where $z ~ p_("data", i)$ satisfies $z = x + epsilon$, where $x ~ p_("data")$. One immediate advantage of this is we no longer need Hutchinson Trace Estimators.
$
  nabla_x log(p_("data", i)(x)) = nabla_x log(integral p_"data" (z)p_(epsilon)(x - z)dz) =
  (EE_(z ~ p_"data") (nabla_x p_epsilon (x - z)))/(EE_(z ~ p_"data")(p_(epsilon)(x - z)))
$

This is quite easy to estimate, but for Gaussians it actually has a closed form.

Now, how do you sample from this thing? The obvious idea is to run Langevin until convergence whenever you switch noise levels. This is called Annealed Langevin Sampling.

== Noise Contrastive Estimation
The idea of NCE is to train a classifier to distinguish between samples from a noise distribution and the data distribution.

$ p_(theta, c)(x) = exp(ip(theta, x) - c) = exp(ip(tilde(theta), tilde(x))) \
  D_tilde(theta) (x) = ((p_tilde(theta) (x))/(p_tilde(theta) (x) + k q(x))) \
  argmax_theta EE_(x, y) y log(D_tilde(theta)(x)) + (1 - y) log(1 - D_(tilde(theta)) (x))
$
Here, $y$ is a $0-1$ variable which is 1 with $1-k$ odds. If we draw a $1$ we draw from the data distribution, and otherwise we draw from the noise distribution $q$. You can show (somewhat painfully) that the objective is convex.

$
  Der_tilde(theta) (p_tilde(theta) (x)) = Der_tilde(theta) (exp(tilde(T)(x)^top tilde(theta))) = 
  (exp(tilde(T)(x)^top tilde(theta))) tilde(T) (x)^top = p_tilde(theta) (x) tilde(T) (x)^top \
  Der_tilde(theta) (D_tilde(theta) (x)) = (k q(x) p_tilde(theta)(x))/(p_tilde(theta) (x) + k q(x))^2 tilde(T)(x)^top = (1 - D_tilde(theta) (x)) D_tilde(theta) (x) tilde(T) (x)^top \
  Der_tilde(theta) (log(D_tilde(theta)(x) )) = 
  1/(D_tilde(theta) (x)) (1 - D_tilde(theta) (x)) D_tilde(theta) (x) tilde(T) (x)^top  = (1 - D_(tilde(theta))(x)) tilde(T) (x)^top \
  Der_tilde(theta) (log(1 - D_tilde(theta)(x) )) = -1/(1 - D_tilde(theta) (x)) (1 - D_tilde(theta) (x)) D_tilde(theta) (x) tilde(T) (x)^top = -D_tilde(theta) (x) tilde(T)(x)^top \
  dif(Der_tilde(theta) (log(1 - D_tilde(theta)))) = d(-D_tilde(theta) (x) tilde(T)(x)^top) =
  -(1 - D_tilde(theta) (x)) D_tilde(theta) (x) tilde(T) (x) tilde(T)(x)^top d tilde(theta) \
  dif(Der_tilde(theta) (log(D_tilde(theta)))) = d((1 - D_(tilde(theta))(x)) tilde(T) (x)^top) = 
   -(1 - D_tilde(theta) (x)) D_tilde(theta) (x) tilde(T) (x) tilde(T)(x)^top d tilde(theta)  \
  Der^2 L(D_tilde(theta)) = Der^2(-1/(k + 1) EE_(p_"data") log(D_tilde(theta)) - (k/(k+1))EE_q log(1 - D_tilde(theta))) = \
  1/(k + 1) integral ((k q(x) + p_"data" (x))(1 - D_tilde(theta) (x)) D_tilde(theta) (x) \) tilde(T)(x) tilde(T)(x)^top dx 
$
This is an integral of a positively-weighted PSD matrix, so it remains PSD, and by the second-order convexity criteria the objective is convex. Furthermore, you can show there's a local maximum (and by convexity a global maximum) at $p_theta (x) = p_"data" (x)$.

$
  Der(L(D_tilde(theta))) = Der(-1/(k + 1) EE_(p_"data") log(D_tilde(theta)) + (k/(k+1))EE_q log(1 - D_tilde(theta))) = \
  -1/(k + 1) integral (p_"data" (x) (1 - D_tilde(theta) (x)) - k q(x) D_tilde(theta) (x)) tilde(T)(x)^top = 0\ 
  integral (p_"data" (x) + k q(x)) D_tilde(theta) (x) = 1 \
   D_tilde(theta) (x) = (p_"data" (x))/(p_"data" (x) + k q(x))
$


The magical part about this optimization objective is that we _learn the normalization constant alongisde the parameters_. Of course in practice. if you really use pure noise for $q$, the classifier will find a very easy job distinguishing between the data and noise distribution. This will dry up the training signal, and prevent the model from getting anywhere near $p_"data"$. 

= Stochastic Calculus
A lot of sampling methods are update rules where you take the current state, apply some transformation, and add noise.

$
  dx = f(x_t, t)dt + g(t) cal(N) (0, Delta t) quad "or" quad  dx = f(x_t, t)dt + g(t) dw
$

This is known as a Stochastic Differential Equation. To get a feel for them let's look at the simple case of $f(x_t, t) = 0, g(t) = 1$.
$
  sum Delta x_t = sum (x_(t + Delta t) - x_t) = x_T - x_0  = sum_(t = 0)^(t slash Delta t) cal(N) (0, Delta t) = cal(N)(0, t)
$

This distribution is called a Wiener process. Let's look at its derivative...
$
  lim_(Delta t -> 0) (w(t + Delta t) - w(t))/(Delta t) = lim_(Delta t -> 0) (cal(N)(0, Delta t))/(Delta t) = lim_(Delta t -> 0) cal(N)(0, 1/(Delta t))
$

Intuitively what this is saying is that the derivative can be arbitrarily large, which is not surprising because you can imagine samples from $cal(N)(0, Delta t)$ are typically of size $sqrt(Delta t)$, which is much larger than $Delta t$. Traditional Calculus is not really equipped to handle functions that are infinitely rough, and this is where the tools of Stochastic Calculus come in. There is more than one way to define a Stochastic Calculus, we will be focusing on Ito calculus.

== Shorthands
Algebraically, you can "derive" most Ito calculus results if you know the following few differential tricks.
$
  dw^2 = dt quad dw dt = 0 quad dt^2 = 0
$

I call them tricks because they should be viewed as shorthands for the actual statements. For example $dw^2 = dt$ actually means
$
  "For suitable" phi | integral phi(w) dw^2   = integral phi(w)dt
$

There are a couple of things to unpack here. First, the integrals correspond to _Ito integrals_, namely
$
  integral phi(w) dw^2 = lim_(dt_i -> 0) sum phi(w_i)cal(N)(0, dt_i)^2 
$

Two choices the Ito Integral makes here is to evaluate the Rienmann sum at the left endpoint, and to ensure the limit exists no matter how we space out the points ($dt_i$ can vary). 

If we don't choose the left endpoint it actually _changes the result_. This doesn't happen in normal calculus, however there is a good reason for it. Different discretizations change how much you expect the mean to drift.

$
  u(x) = lim_(dt -> 0) E(X_(t + dt) - X_t | X_t = x)/dt
$

Hence, you are actually defining a qualitatively different process if you change the discretization.

Second, the result of an Ito integral is a distribution. Thus, that integral equality is really saying that the distribution on the left-hand side approaches the distribution of the right-hand side as the discretization gets finer and finer. There are many ways to define how close two distributions are, and they don't always agree. The Ito integral specifically requires convergence in L2 norm.

$
  EE(X - X^*) -> 0
$

So $dw^2 = dt$ is really saying...
$
   EE((sum phi(w_i)^2 (dw_i^2 - dt_i))^2) -> 0
$

Anyway, this is pretty easy to show. Consider one of the cross-terms.
$
   EE(phi(w_i) phi(w_j) (dw_i^2 - dt_i) (dw_j^2 - dt_j)) = \
   EE(phi(w_i) phi(w_j)) EE((dw_i^2 - dt_i)) EE((dw_j^2 - dt_j)) = 0\
$
The fact that the expectation factors like this is a side effect of choosing a "suitable" $phi$, namely one which was "unaware" of the future trajectory of $w$. We've shown it suffices to bound everything which isn't a cross-term.
$
  E((sum phi(w_i)^2 (dw_i^2 - dt_i)^2) <=_("Assume" phi "bounded") g^2 E(sum (cal(N)(0, dt_i) ^2 - dt_i)^2) = \
  g^2 sum dt_i^2 E((cal(N)(0, 1) - 1)^2) = (C T) / N -> 0
$

You don't have to assume $phi$ is bounded, there are weaker conditions you can use for convergence but nonetheless this is the idea. All the other statements can be proven in similar ways. Also, you'll notice I didn't assume all the time increments are the same. This is because the goal is to prove any approximation to the integral converges, not just some of them.

== Ito's Lemma
Now that we have some algebraic tools, we can begin to prove some useful results. The first one is essentially a change of variables formula.
$
  dx = f(x, t)dt + g(t)dw \
  d(h(x, t)) = ...?
$

You can Taylor expand $g(x)$ using Taylor's theorem.
$
  h(x + dx, t + dt) = h(x, t) + h_x (x, t)dx + h_t (x, t)dt + 1/2 h_(x x)(x) dx^2 +\
    1/2 h_(t t)(x) dt^2 + h_(x t) (x) dx dt + O("cubic") \
$
Now we can apply all our differential tricks.
$
  dx^2 = (f dt + g dw)(f dt + g dw) = f^2 dt^2 + f g dt dw + g f dw dt + g^2 dw^2 = g^2 dt \
  dx dt = (f dt + g dw) dt = f dt^2 + g dw dt = 0 \
  dx^3 = (g^2 dt) dx = 0 quad dx^2 dt = g^2 dt dt = 0 quad dt^2 dx = 0 dx = 0 quad dt^3 = dt^2 dt = 0 \
  d h = h_x (f dt + g dw) + h_t dt + 1/2 h_(x x) g^2 dt = \
  (f h_x + h_t + 1/2 h_(x x) g^2)dt + g h_x dw
$

You could make all this rigorous my manipulating limit sums but this is algebraically equivalent.


== Fokker-Planck Equation
We can use Ito's Lemma to derive a formula for how the probability density itself evolves under the SDE. The trick is just analyzing the expected value of $h(x)$ for a suitable $h$.
$ E(d h) = E((f h_x + h_t + 1/2 h_(x x) f^2)dt + g h_x dw) =
  E((f h_x + h_t + 1/2 h_(x x) f^2)dt) \
  => d/dt E(h) = E((d h) / dt) = integral (f h_x + 1/2 h_(x x) f^2) p (x) \
$

We dropped the $h_t$ term because $h$ does not depend on $t$. We can get rid of the derivatives on $h$ using integration by parts.
$
  integral (f h_x + 1/2 h_(x x) f^2) p_t (x) = integral h_x f p (x) + 1/2 integral h_(x x) g^2 p(x) \
  = - integral h d/dx (f p(x)) - 1/2 integral h_x g^2 d/dx p(x)
  = - integral h d/dx (f p(x)) + 1/2 integral h g^2 d^2/dx^2 p(x)
$

Note that we dropped some terms in the integration by parts, corresponding to the $[u v]^oo_oo$ terms. These will always be zero under some mild regularity conditions ($f p -> 0$ at the extremes of the distribution).

An alternate way of getting this expectation is simply differentiating through the integral.
$
  d/dt E(h) = integral  d/dt h p (x)
$

We now choose $h$ to a point-mass, forcing equality of the integrands for all $x$.
$
  d/dt p(x) = -d/dx (f p(x)) + 1/2 g^2 d/dx^2 p(x)
$

This is known as the Fokker-Planck Equation!

== Reverse SDE
Finally, we can derive an SDE which maps the distribution under some number of steps of the SDE back to the original distribution. We start by negating the Fokker-Planck equation.
$
  - d/dt p(x) = nabla_x (f p(x)) - 1/2 g^2 nabla_(x x) p(x)
$

If we integrated this and added it to the end distribution, we would recover the original distribution. To find an SDE that has this form, we can sort of just guess what choice of $f$ and $g$ will work. I'll denote the appropriate choices as $a$ and $b$ respectively.

$
  a = -f + g^2 nabla_x log(p(x)) quad b = g
$

Plugging these into the Fokker-Planck equation we immediately obtain...
$
  nabla_x (a p) = -nabla_x (f p) + g^2 nabla_(x x) p \
  d/dt p(x) = nabla_x (f p) - g^2 nabla_(x x) p + 1/2 g^2 nabla_(x x) p(x) = \
  nabla_x (f p(x)) - 1/2 g^2 nabla_(x x) p(x)
$

== Langevin Sampling
The idea of Langevin sampling is to construct a forward SDE such that $p(x)$ is a fixed point, and everything else converges to the fixed point. 
$
  d/dt p(x) = -nabla_x (f p(x)) + 1/2 g^2 nabla_(x x) p(x)
$

Let's choose $f = nabla_x log(p(x))$ and $g = sqrt(2)$. As desired, $p(x)$ is a fixed point.
$
  d/dt p(x) = -nabla_x (nabla_x log(p(x)) p(x)) + nabla_(x x) p(x) = 0
$

Furthermore, if $p(x) prop exp(-E(x))$, the corresponding SDE looks a lot like gradient descent on the energy function $E(x)$.
$
  dx = (nabla_x log(p(x)))dt + sqrt(2) cal(N)(0, dt) \ 
  dx = -nabla_x E(x)dt + sqrt(2) cal(N)(0, dt) \  
$

In fact, you can actually show Langevin sampling converges quickly because it is basically doing gradient descent over the KLs, but I won't show that here.

Note that this is _not_ the same as simulating a reverse SDE, because we're computing the score with respect to the _target_ distribution, not the _current_ distribution. 

== Diffusion
Diffusion is essentially Denoised Score Matching. The main difference is _how it chooses the noise levels_, which DSM doesn't really constrain. Essentially, construct $p_("data", i)$ such that it can be viewed as the forward process of an SDE. Then, when going backwards use an SDE solver on the reverse SDE! The connection to SDEs enables a wide variety of tricks. For example, there are solvers which can account for local curvature and take dynamic step sizes. Furthermore, with an appropriate forward diffusion process the reverse SDE might actually be an ODE! This is the insight of #link("https://arxiv.org/abs/2010.02502")[DDIM].
// TODO: Denoising Score Matching: why regular score matching fails to put mass in the right places.
// TODO: Noise Contrastive Estimation.
// TODO: Diffusion, and a bit ITO calculus.
// TODO: GANs