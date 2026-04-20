#import "/typ/templates/blog.typ": *
#show: main.with(
  title: "Probabilistic Models",
  desc: "",
  date: "2026-04-12T22:10:59-04:00",
  tags: ("notes",),
)

#show: note_page

// = Stochastic Calculus
// $
//   w(t + u) - w(t) = cal(N)(0, u) \
//   // lim_(d t -> 0) (w(t + d t) - w(t))/(d t) = 1/(d t) cal(N)(0, d t) = cal(N)(0, 1/ (d t))
//   integral d w approx sum_(i = 0)^(u N) cal(N)(0, 1/N) => d w approx cal(N)(0, d t)
// $

// $
//   dx = f(x, t)dt + g(t)dw
// $
// Reverse SDE
// Itos lemma and connect everything to deterministic calc.
// Focker Plank
// Derive reverse SDE...

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

// TODO: Various schemes for Markov Chain sampling: Langevin, HMC, Temperature Stuff...
// Temperature based Annealing and HMC.

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

== CAVI
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

// TODO: Denoising Score Matching: why regular score matching fails to put mass in the right places.
// TODO: Noise Contrastive Estimation.
// TODO: Diffusion, and a bit ITO calculus.
// TODO: GANs