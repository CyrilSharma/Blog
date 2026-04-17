#import "/typ/templates/blog.typ": *
#show: main.with(
  title: "Probabilistic Models",
  desc: "",
  date: "2026-04-12T22:10:59-04:00",
  tags: ("notes",),
)

#show: note_page
= Sampling
== Rejection Sampling
You want to draw samples from distribution $p(x)$ but you can only draw samples from $q(x)$. Luckily, you can engineer $q(x)$ to cover the domain of $p(x)$, and there exists $C$ such that $C q(x) >= p(x) semi forall x$. The idea is to sample from $q$, and keep the sample with probability $p(x)/(C q(x))$.
$
  P("Accept") = integral 1/C p(x)/q(x) q(x) = 1/C \
  P(x | "Accept") = (p("Accept" | x)p(x))/p("Accept") = C(1/C (p(x))/q(x) q(x)) = p(x)
$

== Importance Sampling
The setting here is you want to compute some functional of the distribution $p$, but you can only draw samples from distribution $q$.
$
  integral f(x) p(x) = integral f(x) (p(x))/(q(x)) q(x) approx 1/N sum f(x) (p(x))/(q(x)) 
$ 

// TODO: Various schemes for Markov Chain sampling: Langevin, HMC, Temperature Stuff...
// TODO: Speculative Decoding.

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

Here's one method, called the score estimator (for reasons we will soon see).
$
  nabla EE_(q_theta) f_theta (x) = nabla integral f_theta (x) q_theta (x) =  integral f'_theta (x) q_theta (x) + integral f_theta (x) q'_theta (x) \
  EE_(q_theta)(f'_theta (x)) + integral f_theta (x) nabla log(q_theta (x)) q_theta (x) = \
  EE_(q_theta)(f'_theta (x)) + EE_(q_theta) (f_theta (x) nabla log(q_theta (x)))
$

As usual, you can compute the expectations using monte-carlo estimators.

Another approach is construct $h$ such that $h(theta, epsilon) tilde q_theta$. Then our problem becomes...
$
  nabla EE_(epsilon) f_theta (h(theta, epsilon)) =
  integral f'_theta (h(theta, epsilon)) h'(theta, epsilon) p(epsilon) = EE_epsilon f'_theta (h(theta, epsilon)) h'(theta, epsilon)
$

These are two very different estimators! In general, neither dominates the other, but for specific settings one might be better than the other.

// TODO: Expectation-Maximization and CAVI

== Score-Matching
The idea of score-matching is simple.
$
  argmin_theta EE_(p_"data") norm(nabla_x log(q_theta (x)) - nabla_x log(p_"data" (x)))^2 
$

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

// TODO: Denoising Score Matching
// TODO: Diffusion, and a bit ITO calculus.