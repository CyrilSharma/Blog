#import "/typ/templates/blog.typ": *
#show: main.with(
  title: "Probability",
  date: "2025-06-15T10:17:05-04:00",
  tags: ("math", "notes"),
)

= Inequalities
== Markov's Inequality - $P(X > t) <= E(X)/t$
$ t P(X > t) &<= E(X | X > t) P(X > t) \
             &<= P(X > t) E(X | X > t) + P(X <= t) E(X | X <= t) = E(X) \
   P(X > t) &<= E(X)/t $

== Chevyshev's Inequality - $P(X - E(X) >= epsilon) <= V(x)/epsilon^2$
$ P(X - E(X) >= epsilon) &= P((X - E(X))^2 >= epsilon^2) \
                         &<= E((X - E(X))^2)/epsilon^2 \
                         &= V(X)/epsilon^2 $

== Jensen's Inequality - $g(E(X)) <= E(g(X))$
Given $g$ is convex we have
#[
  #set math.equation(numbering: "(1)")
  $ g(a x + (1 - a) y) <= a g(x) + (1 - a)g(y) $
]
$ g(E(X)) &= g(integral_X x p(x) dif x) \ 
          &= g(x_0p(x_0)dif x + ... + x_n p(x_n) dif x) \
          &<=^"(1)" p(x_0) g(x_0) dif x + (1 - p(x_0))g(dots) dif x \
          &<=^"(1)" p(x_0) g(x_0) dif x + dots + p(x_n) g(x_n) dif x \
          &= E(g(X)) $
The textbook provides a cleaner proof where you just lower-bound g(x) by the tangent line at $E(x)$.
$ E(g(x)) >= E(L(x)) = E(a + b x) = a + b E(x) = L(E(x)) = g(E(x)) $

== Cauchy-Schwartz Inequality - $E(X Y)^2 <= E(X^2)E(Y^2)$
We start by investigating $E((X t + Y)^2)$ which is clearly non-negative.
$ &= E(X^2)t^2 + 2E(X Y)t + E(Y^2) $
For this quadratic equation to be non-negative, the discriminant must be $<= 0$.
$ 4E(X Y)^2  - 4E(X^2)E(Y^2)  <= 0 \
  E(X Y)^2 <= E(X^2)E(Y^2) $

This is interesting because it's hard to think of a direct way to derive this. You have to get the insight to transform it into a quadratic via a dummy parameter to see this.

= Convergence of RVs
There are two common notions of convergence.
+ The probability of $|X_n - X| < epsilon$ tends to 1 as $n$ grows. In other words, I expect to sample almost the exact same things.
+ The distributions become identical. E.g. I have one distribution that asymptotically becomes a normal distribution, that doesn't mean it has particularly good odds of sampling the same thing as whatever that normal distribution is, though. Hence convergence in probability is stronger then convergence in distribution.
+ Bonus: $X_n$ converges quadratically to $X$ iff $lim_(n arrow infinity) E((X_n - X)^2) = 0$

Converging in probability does not imply converging in (3) because expectations can get skewed by extreme points, even very unlikely extremes. Converging in distribution of course does not imply converging in probability.

Another thing is that convergence in distribution is a lot weaker then convergence in probability. You can't even say things like $X_n arrow X, Y_n arrow Y arrow X_n + Y_n arrow X + Y$. To see why, imagine $X$ and $Y$ were normal distributions, but $X_n = -Y_n$. The sum of RVs converges to 0, the sum of the distributions is another normal distribution.

Some of the interesting things you can say come from Slutzky's theorem. Namely that function application and adding constants do behave as expected.

== Law of Large Numbers
Just a statement that the sample mean converges to the distribution mean. You can see this with Chebyshev's.

== Central Limit Theorem
This is more of a proof sketch. We'll use the fact that if the MGF's converge, then the underlying functions do. Let $X_i$ be the ith sample from distribution $X$. Rescale $X_i$ to have mean 0 and variance 1. Let $phi$ denote the mgf of any $X_i$. 

$ phi("sample mean") &= phi(t/sqrt(n))^n \
                     &= (1 + t^2/(2 n) + t^3/(3! n^(3/2)) + dots)^n \
                     &= (1 + (t^2/2 + ("stuff which tends to zero"))/n)^n \
                     &= e^(t^2/2) $

The core observation is that the $sqrt(n)$ term kills all terms after the second in the taylor expansion. Still, I don't find this proof very satisfying.

Another way to look at is it suppose the distribution definitely converges, then what would it converge too? Well, suppose it gives a distribution $D$ from the distribution family $F$. We would want $D_1, D_2 in F arrow D_1 + D_2 in F$. This is enough to kind of intuit the distribution family $F$.
$ (X_1 + dots + X_n)/sqrt(n) &arrow D \
  (X_1 + dots + X_(2 n))/sqrt(2 n) &arrow D $

Hence $D + D arrow sqrt(2)D$. Generalizing this, we have $D + dots + D$ = $sqrt(n)D$. Then
$ phi(t)^n &= phi(sqrt(n) t) \
  n log(phi(t)) &= log(phi(sqrt(n) t)) \
  n w(t) &= w(sqrt(n) t) \
   w(t) &= c t^2 \
   phi(t) &= e^(c t^2) $

Then the other desired properties, like it should be normalized and sum to 1 force it to be a normal distribution. 

== Detour -- The Kelly Criteria!
So let's suppose we're taking bets. The probability of winning is $p$ and the probability of losing is $q$. If I win I gain however much I bet, otherwise I lose that amount.

Clearly, going all in on every bet will almost certainly result in ruin, even if it maximizes the EV, and betting the minimum (minimizing the risk) will barely get you anything. How much should you bet then? 

Let's assume we'll bet a fixed fraction of our income, $f$. Let's assume capital is inifitely divisible and then you start with $X_0$. The amount you will end with after $n$ rounds is $X_n = X_0(1 + f)^S (1 - f)^F$. 

Let's choose to maximize the growth rate of capital per round $g(f) = log((X_n /X_0)^(1/n))$.
$ g(f)   &= S/n log(1 + f) + F/n log(1 - f) \
  E(g(f)) &= p log(1 + f) + q log(1 - f) $

Maximizing,
$ d/(dif f) E[g(f)] &= p/(1 + f) - q/(1 - f) = 0 \
                    &arrow p(1 - f) - q(1 + f) = 0 \
                    &arrow (p - q) = (p + q)f \
                    &arrow f = p - q $

You can also see the derivative is monotoically decreasing, hence this is indeed the maximum. We can also intuit the rest of the graph.

#import "@preview/lilaq:0.3.0" as lq
#let indices = range(100)
#let xs = indices.map(i => i * 0.01)
#let p = 0.80
#let q = 1 - p

#align(center)[
  #graphic(
    lq.diagram(
      lq.plot(xs, xs.map(f => p * calc.log(1 + f) + q * calc.log(1 - f))),
      lq.plot(xs, xs.map(x => 0)),
      xaxis: (mirror: false, label: "Fraction Bet"),
      yaxis: (mirror: false, label: "Expected Growth"),
      grid: none,
      xlim: (0, 1.0),
      ylim: (-0.1, 0.1),
    )
  )
]

Interetsingly, this seemingly arbitrary choice to maximize the expected growth rate has some very nice properties. Namely, for any value $M$ the probability of exceeding $M$ tends to 1. Furthermore, any strategy which doesn't maximize the expected growth rate will in the long run lose to a strategy of this form. So, in some sense fractional betting is "optimal".

Also, it seems to do pretty well in contexts it wasn't exactly designed for. For example, maximizing the probability of exceeding some amount of wealth after n turns. You can of course make some contrived examples where it bets incorrectly, but this just goes to show that the Kelly Criterion is a much more general and useful tool for betting then risk minimization or reward maximization.

At some point I'm going to try and crack #link("https://en.wikipedia.org/wiki/Machi_Koro")[Machi Koro] with this...

