#import "/typ/templates/blog.typ": *
#show: main.with(
  title: "Convex",
  desc: "",
  date: "2026-01-24T16:33:16-05:00",
  tags: ("notes",),
)

#show: note_page

= Theory
== Convex Sets

/ Affine Set:
  Let $S in RR^n$. $S$ is affine iff $forall a, b in S, theta in R, a theta + b (1 - theta) in S$

/ Convex Set:
  Let $S in RR^n$. $S$ is convex iff $forall a, b in S, theta in [0, 1], a theta + b (1 - theta) in S$

/ Conic Set:
  Let $S in RR^n$. $S$ is conic iff $forall a, b in S, theta_1, theta_2 >= 0,  theta_1 a + theta_2 b in S$

#definition(name: "Affine / Convex / Conic Hull")[
  $"hull"(S)$ is all affine / convex / conic combinations of all points in $S$.
]
#definition(name: "Affine Function")[
  $f: RR^n arrow RR^m$ is affine if it can be written 
  $ f(x) = A x + b, A in R^(n times m), b in R^m $
]


#theorem[
  The intersection of convex sets is convex. 
]
#proof[
  Suppose $a, b in S_1 inter S_2$. Then,
  $ a, b in S_1 arrow theta a + (1 - theta) b in S_1 \
    a, b in S_2 arrow theta a + (1 - theta) b in S_2 \
    theta a + (1 - theta) b in S_1 inter S_2
  $
]

#theorem[
  The Cartesian product of two sets is convex.
]
#proof[
  Suppose $a, b in S_1 times S_2$. Then,
  $
    theta a_1 + (1 - theta) b_1 in S_1 \
    theta a_2 + (1 - theta) b_2 in S_2 \ 
    theta a + (1 - theta)b in S_1 times S_2
  $
]

#theorem[
  An affine function applied to a convex set is also a convex set.
]
#proof[
  Suppose $x, y in f(S)$. Is $p = theta a + (1 - theta) b in f(S)$? Well, we know each point must have at least one pre-image in $S$. Call these $x'$ and $y'$ respectively. Furthermore, the convex combination of these points $theta x + (1 - theta) y$ must also be in $S$. Finally, we have
  $
    A(theta x' + (1 - theta)y') + b = theta(x - b) + (1 - theta)(y - b) + b = \
    theta x + (1 - theta) y - (1 - theta) b - theta b + b = \
    theta x + (1 - theta) y
  $
  
  So $p$ has a pre-image in $S$, and the claim is shown. You can also show this for affine inverses.
]

#theorem[
  Projective functions $P(mat(x_1, ..., x_n)) = mat(x_1 / x_n, ..., x_(n - 1))$ preserve convexity.
]
#proof[$
  x = (hat(x), x_n), y = (hat(y), y_n) \
  P(theta x + (1 - theta) y) =
  (theta hat(x) + (1 - theta) hat(y)) / (theta x_n + (1 - theta) y_n) =
  mu hat(x) + (1 - mu) hat(y) 
    
$]

Composing affine and projective functions lets you say linear fractional functions preserve convexity.
$
  P(vec(A, c^t)x + vec(b, d)) = (A x + b) / (c^t x + d)
$

#theorem[
  Any convex set can be represented as the intersection of a (potentially infinite) number of hyperplanes.
]
This relies on the Supporting Hyperplane Theorem, which essentially says that for every point on the boundary, I can draw a hyperplane going through that point such that the entire set is on one side of the boundary. This is true if and only if you're working with a convex set.

== Topology
/ Interior Point: A point such that a centered ball of some sufficiently small radius epsilon fits entirely within $C$.
/ Relative Interior Point: An slight refinement of an interior point. Instead of saying all points in the ball must fit within $C$, you say all points in the ball that are also on the affine hull of $C$ must fit within $C$. This lets you define interiors for subspaces.
/ Boundary Point: A point such that a centered ball always intersects $C$ and $C$'s complement. Alternatively, a point such that all centered balls of radius less than some threshold intersects $C$ and $C$'s complement.
/ Open Set: I don't contain my boundary.
/ Closed Set: I contain my boundary.
/ Compact Set: I contain my boundary and I have a bounded size.

== Cones 
A convex conic set $K$ can be used to define an ordering as follows.
$
  x succ_k y arrow.l.r x - y in K
$

A cool convex conic set is the set of positive definite matrices.
$
  x^top u A x = u x^top A x >= 0 \
  x^top theta A + (1 - theta) B x = theta x^top A x + (1 - theta) x^top B x >= 0
$

Intuitively, $ A succ_k B arrow x^top A x > x^top B x quad forall x $
Not every set of matrices can be ordered under this metric (e.g. neither A - B or B - A is PD), which is why cones are said to be a generalization of inequalities - they forgo universal ordering.

#definition(name: "Polar Cone")[
  Let $C$ be any set. Then the polar cone $C^degree = { x: x^top y <= 0, forall y in C}$.
]
Intuitively, this is the set of vectors which make more than a $90$ degree angle to all vectors in $C$.
#theorem[Polar cones are convex cones.]
#proof[
  $
    x^top y <= 0 arrow_(u >= 0) u x^top y <= 0\
    a, b in C^degree arrow (theta a + (1 - theta) b)^top y = \
    theta a^top y + (1 - theta) b^top y <= 0, forall y
  $
]

#definition(name: "Normal Cone")[
  $N_C (x) = {g: g^top (y - x) <= 0, forall y in C}$
]
Intuitively, this cone is all the vectors which are more than $90$ degrees off from any _direction into the set_. So for interior points, they're empty, for flat boundaries they're rays, and for corners, they're a proper cone. You can verify this is indeed a convex cone.

#definition(name: "Tangent Cone")[
  $T_C (x)$ is the set of directions we can move in which keep us in the set.
]
It's easy to see the Tangent Cone is just the Polar Cone of the Normal Cone.

The above two cones are useful for quantifying vertices, edges, and if we've reached optimality. If your objective function is telling you to go into a normal cone, you'll know you've reached optimality.

== Convex Functions
#definition(name: "Convex Function")[
  A function is convex if its *domain is convex*, and
  $
    f(theta x + (1 - theta) y) <= theta f(x) + (1 - theta)f(y) | forall theta in [0, 1]
  $
]

This object is the heart of convex analysis. Just like convex sets, there are a ton of properties that can be shown about them...
#theorem[
  If a convex function is differentiable, it obeys 
  $
    f(y) >= f(x) + gradient f(x) (y - x)
  $

  If it's twice differentiable, it obeys
  $
    gradient^2 f succ.eq 0
  $
]

The first statement says any tangent line lower-bounds the convex function, which is pretty intuitive. The second statement says the Hessian must be positive semi-definite. This can be interpreted as saying no matter what direction I walk in, the slope along that curve must be non-decreasing.

A useful tool for relating properties of convex sets to convex functions is the epigraph.
#definition(name: "Epigraph")[
  $
    "Epi"(f) = { (x, t): f(x) <= t }
  $
]
#theorem[
  $"Epi"(f)$ is convex iff $f$ is convex.
]
#proof[
  Suppose $z_1 = (x_1, t_1), z_2 = (x_2, t_2) in "Epi"(f)$.
  If $"Epi"$ is convex, then by definition of convexity, 
  $
    theta z_1 + (1 - theta) z_2 = (theta x_1 + (1 - theta) x_2 , theta t_1 + (1 - theta) t_2) in "Epi" (f)
  $

  By definition of an epigraph, this means
  $
    f(theta x_1 + (1 - theta) x_2) <= theta t_1 + (1 - theta) t_2 = theta f(x_1) + (1 - theta) f(x_2)
  $

  Thus, $f$ is a convex function. The reverse direction is similar.
]

From this property, you can easily deduce that maxes of convex function are still convex, and a lot of other properties. Here's an epigraph-based proof for a problem that will show up later.

#theorem(name: "Convex Partial Minimization")[
  Consider the partial minimization of $f$ over the set $bb(C)$:
  $
      g(x)  = inf_(y in bb(C)) f(x, y)
  $
  If $g$ is always finite, $g$ is convex.
]
#proof[
  First observe $ "Epi"(f) = {(x, y, t): x, y in R^d, f(x, y) <= t } $
  Now, consider the intersection of $"Epi"(f)$ with
  $ C' = {(x, y, t): x in R^d, y in C, t in R} $
  $C'$ is convex, as it can be written $(R^d times C) times R$. $"Epi"(f)$ is convex by the theorem above and we've shown the cartesian product of convex sets is also convex.

  Furthermore,
  $ "Epi"(f) inter C' = { (x, y, t): x in R^d, y in C, f(x, y) <= t } $

  Now, we can use an affine function to drop the $y$ term. Affine functions preserve convexity.
  $
  "Proj"("Epi"(f) inter C') = { (x, t): x in R^d, exists y in C, f(x, y) <= t } 
  $

  Now consider $"Epi"(g)$. This can be written
  $
    "Epi"(g) = { (x, t): x in R^d,  g(x) <= t } = \
    { (x, t): x in R^d,  inf_{y in C} f(x, y) <= t } =  \
    { (x, t): x in R^d, exists y in C, f(x, y) <= t } = \
    "Proj"("Epi"(f) inter C')
  $

  Hence, $"Epi"(g)$ is convex which implies $g$ is convex.
]

= Inequalities
It turns out many of the most useful inequalities can be derived through analyzing a suitable convex function. 
#theorem(name: "Jensen's Inequality")[$ f(E(x)) <= E(f(x)) $]
#proof[
  $
    f(E(x)) = f(lim_(Delta x -> 0) (sum_i (x + i Delta x)p(x + i Delta x) Delta x)) =\
     lim_(h -> 0) sum_i f(x + i Delta x)p(x + i Delta x)Delta x = E(f(x))
  $
]

#theorem(name: "Young's Inequality")[$ 1/p + 1/q => a b <= a^p / p + b^q / q $]
#proof[$
  exp(x/p + y/q) <=_"Convexity" exp(x)/p + exp(y)/q \
  a, b > 0 | exp(log(a^p)/p + log(b^p)/q) <= exp(log(a^p))/p + exp(log(b^p))/q \
  a b <= a^p / p + b^q / q
$]

#theorem(name: "Holder's Inequality")[$ 1/p + 1/q => sum_i |x_i y_i| = norm(x)_p norm(y)_q $]
#proof[
  $
    a_i = x_i / norm(x)_p, b_i = y_i / norm(y)_q\
    |a_i| |b_i| <= abs(a_i)^p / p + abs(b_i)^q / q  \
    sum_i |a_i b_i| <= sum_i (abs(a_i)^p / p + abs(b_i)^q / q) \
    1/(norm(x)_p norm(y)_q) sum_i x_i y_i <= 1/p sum_i abs(a_i)^p + 1/q sum_i abs(b_i)^q = 1/p + 1/q = 1 \
    sum_i |x_i y_i| = norm(x)_p norm(y)_q
  $
]

Plugging in $p = 2$ gives you the Cauchy-Schwarz inequality.

= Algorithms
Here's some important terminology...
#definition(name: "Convergence")[
  *Point-wise*: $lim_(t -> oo) norm(x_t - x^*) -> 0$\
  *Function-wise*: $lim_(t -> oo) norm(f(x_t) - f(x^*)) -> 0$
]
#definition(name: "Rates of Convergence")[
  Let $epsilon_t = hf(norm(x_(t+1) - x^*), norm(x_t - x^*))$.\
  *Linear-Convergence*: $lim_(t -> oo) epsilon_t = C, 0 < C < 1$ \
  *Superlinear-Convergence*: $lim_(t -> oo) epsilon_t = 0$ \
  *Sublinear-Convergence*: $lim_(t -> oo) epsilon_t = 1$ \
  You can also define it for the function values.
]
#definition(name: "Descent Direction")[
  $h | f(x + eta h) <= f(x)$, for sufficiently small $eta$.
]

And here's some "nice" function classes we typically work with. Note that all of these have zeroth order characterizations, but I find these definitions to be the most intuitive.
#definition(name: "G-Lipschitz")[
  $|f(x)-f(y)| <= G|x-y|$
]
#definition(name: [$beta$-Smooth])[
  $norm(gradient f(x) - gradient f(y)) <= beta norm(x - y)$
]
#definition(name: [$alpha$-Strongly Convex])[
  $gradient^2 f(x) succ.eq alpha I $
]

== Gradient Descent
#definition(name: "Unconstrained Gradient Descent")[
  Suppose you have a function $f$ which allows querying values and gradients (1st order oracle). Consider the following problem.
  $
    min_(x in bb(R)^d) f(x) 
  $

  One approach is to do 
  $
    x_0 = hat(0) \
    x_(t + 1) = x_t - eta_t nabla f(x_t)
  $
]

#lemma(name: "Descent Lemma")[
  For a $beta$-smooth function, choosing $eta = hf(1, beta)$ yields
  $
    f(x_(t + 1)) <= f(x_t) - eta/2 norm(gradient f(x_t))^2
  $
]
#proof[
  $
    f(x + h) <= f(x) + gradient f(x)^top h + beta/2 norm(h)^2 \
    f(x_(t + 1)) <= f(x) - 1/beta norm(nabla f(x))^2 + 1/(2 beta) norm(nabla f(x_t))^2 \
    f(x_(t + 1)) <= f(x) - 1/(2 beta) norm(nabla f(x_t))^2 = f(x) - eta/2 norm(gradient f(x_t))^2 \
  $
]

An interesting insight in the above proof is that if you differentiate the first line with respect to $h$, you get $x_(t + 1) = x_t - eta gradient f(x_t)$ is the minimizer of the quadratic in terms of $h$. Hence, you can view gradient descent as repeatedly moving to the minimum of a locally fitted quadratic, where the Hessian is approximated using $beta$.

#theorem[
  For a $beta$-smooth function, gradient descent gives the following guarantee
  $
    min_(t = 1...k) norm(gradient f(x_t))^2 <= 2beta / k (f(x_0) - f(x^*))
  $
]
#proof[
  Suppose it was false. Then, the gradient must exceed this inequality on every step.
  $
    f(x_k) <= f(x_0) - k eta/2 2 beta / k (f(x_0) - f(x^*)) \ 
    f(x_k) <= f(x^*) -> f(x_k) = f(x^*)
  $

  Ah, but the gradient at the global optimum is zero, so we've reached a contradiction.
]

#theorem[
  For a convex $beta$-smooth function, gradient descent with $eta = hf(1, beta)$ yields
  $
    f(x_k) - f(x^*) <= beta/(2k) norm(x_0 - x^*)^2
  $
]
#proof[
  $
    norm(x_(t+1) - x^*)^2 = norm(x_t - eta gradient f(x_t) - x^*)^2 = \
    norm(x_t - x^*)^2 + eta^2 norm(gradient f(x_t))^2 - 2 eta gradient f(x_t)^top (x_t - x^*) \
    2 eta gradient f(x_t)^top (x_t - x^*) = norm(x_t - x^*)^2 - norm(x_(t+1) - x^*)^2 + eta^2 norm(gradient f(x_t))^2 \
  $
  Substitute in the first order convexity condition.
  $
     2 eta (f(x_t) - f(x^*)) <= norm(x_t - x^*)^2 - norm(x_(t+1) - x^*)^2 + eta^2 norm(gradient f(x_t))^2
  $

  Now use the descent lemma.
  $
     2 eta (f(x_t) - f(x^*)) <= norm(x_t - x^*)^2 - norm(x_(t+1) - x^*)^2 + eta^2 2 /eta (f(x_t) - f(x_(t + 1))) \
     2 eta (f(x_(t + 1)) - f(x^*)) <= norm(x_t - x^*)^2 - norm(x_(t+1) - x^*)^2 \
  $

  Finally, use a telescoping sum to simplify things.
  $
     sum_(t=0)^(k-1) 2 eta (f(x_(t+1)) - f(x^*)) <= sum_(t=0)^(k-1) (norm(x_t - x^*)^2 - norm(x_(t+1) - x^*)^2) \
    2 k eta (f(x_k) - f(x^*)) <= norm(x_0 - x^*)^2 - norm(x^(k) - x^*)^2 \
    f(x_k) - f(x^*) <= 1/(2 k eta) norm(x_0 - x^*)^2  = beta /(2 k) norm(x_0 - x^*)^2
  $
]

#theorem[
  If $f$ is $beta$-smooth and $alpha$-strongly convex, $eta = hf(1, beta)$ yields
  $
    norm(x_k - x^*)^2 <= (1 - alpha/beta)^k norm(x_0 - x^*)^2
  $

  That, is gradient descent yields linear convergence.
]
#proof[
  Almost the same as the above proof. The first order convexity condition for $alpha$-strongly convex functions is as follows.
  $
    f(y) >= f(x) + gradient f(x)^top (y - x) + alpha/2 norm(y - x)^2
  $

  So if you substitute that in to the above proof you get
  $
     2eta(f(x_t) - f(x^*) + alpha / 2 norm(x_t - x^*)^2) <= norm(x_t - x^*)^2 - norm(x_(t + 1) - x^*) \
     norm(x_(t + 1) - x^*)^2 <= (1 - alpha / beta)norm(x_t - x^*)^2 \
     norm(x_k - x^*)^2 <= (1 - alpha / beta)^k norm(x_0 - x^*)^2
  $
]

One popular example of a function that is both $beta$-smooth and $alpha$-strongly convex is $norm(A x - b)^2$! Expanding it yields $x^top A^top A x + "affine"$, $A^top A$ is PSD. Its minimum eigenvalue is equivalent to $alpha$ and its largest is equal to $beta$.

All the above methods rely on choosing a specific step size. However, dynamically choosing the step size might make more sense if you only have weak guarantees on the function's behavior. Simply guessing a step-size and backtracking can be used (backtracking line search). If evaluating $f$ is expensive (neural networks), you probably don't want to do this.

== Subgradient Methods
#definition(name: "Subgradient")[
  $g | f(y) >= f(x) + g^top (y - x)$
]
From the definition, it's also immediately clear the subgradient is a convex set. If the subgradient is non-empty everywhere the function is convex by a relaxed version of the first order convexity criteria. If $f$ is differentiable, the subgradient has at most one element (e.g. there's only one "tangent" line). Notice that unlike the gradient, the subgradient is a global property, it is a constraint on the entire function.

It's easy to see the following properties.
+ $dif (a f) = a dif(f))$ \
+ $dif (f_1 + f_2) = dif(f_1) + dif(f_2)$ \
+ $g(x) = f(A x + b) -> dif (g(x)) = A^top dif (f(A x + b))$


#import "@preview/cetz:0.2.2": draw
#align(center, graphic(
  cetz.canvas({
    import cetz.draw: *;
    line((0, 0), (2, 0), stroke: (dash: "dashed"))
    line((2, 0), (4, -2), stroke: (dash: "dashed"))
    line((2,0), (0, 2))
    line((2,0), (4, 0))
    line(
      (0,0), (2,0), (4,-2),
      fill: green.transparentize(80%),
      stroke: none,
      close: true,
    )
  })
))

One interesting property is the sub-gradient of the maximum of functions.
$
  "ConvexHull"(union.big_(forall i | f_i(x) = f(x)) dif f_i(x))
$

This is pretty intuitive, the functions which don't achieve the maximum don't define the curvature, and the convex hull essentially means anything in between the two subgradients is valid (which you can justify by looking at the green region in the above diagram).

Here's an example application. Consider $abs(x)$. What's the subgradient at $x = 0$? Well, using the above property on $max(x, -x)$, we immediately obtain the convex hull of ${-1, 1}$ which is $[-1, 1]$.

We can generalize our optimality conditions from earlier to use subgradients.
#lemma[
  Let $I_C (x) = 0 "if" x in C "else" oo$. For $x in C$, the subgradient is $"NC"(x)$.
]
#proof[
  $
    f(y) >= f(x) + g^top (y - x) \
    "Choose" y in C => 0 >= g^top (y - x) = "NC"(x)
  $
]

#theorem[
  $x^*$ is optimal if $exists g in dif f(x) | (-g) in "NC"(x)$
]
#proof[
  $
    "argmin"_(x in C) f(x) = "argmin" f(x) + I_C(x) = \
    dif f(x) + I_C(x) = dif f(x) + "NC"(x)
  $
  $0$ must be in the subgradient of $x^*$ for it to be optimal.
  $
    f(y) >= f(x^*) => f(y) >= f(x^*) + 0^top (y - x)
  $
  Hence $0 in dif f(x) + "NC"(x)$ which shows the claim.
]

#definition(name: "Subgradient Method")[
  Essentially, replace the gradient in gradient descent with the subgradient. Interestingly, the subgradient is not guaranteed to be a descent direction.
]
#theorem[
  For a convex $G$-lipschitz function and step sizes $n_t$, we have
  $
    f(x_t^"best") - f(x^*) <= (norm(x_0 - x^*)^2 + G^2 sum n_t^2)/(2 sum n_t)
  $
]
#proof[
  The beginning is almost identical to previous proofs, where we try to bound how different consecutive $x$s are. I'll skip ahead a bit.
  $
    2 eta_t g^top (x_t - x^*) = norm(x_t - x^*)^2 - norm(x_(t+1) - x^*)^2 + eta_t^2 norm(gradient f(x_t))^2 \
  $

  Now apply the $G$-lipschitz property.
  $
    2 eta_t (f(x_t) - f(x^*)) <= norm(x_t - x^*)^2 - norm(x_(t+1) - x^*)^2 + G^2 eta_t^2 \
  $
  
  Performing a telescoping sum yields the desired claim.
]

To extract a rate out of this, let $norm(x_0 - x^*) = R$. Then we have
$
   f(x_t^"best") - f(x^*) <= R^2/(2 sum n_t) + (G^2 sum n_t^2)/(2 sum n_t)
$

Let's assume $n_t = C t^alpha$. Then we get 
$
  R^2/(2 sum n_t) + (G^2 sum n_t^2)/(2 sum n_t) =
  R^2/(2 C sum t^alpha) + (G^2 C^2 sum t^(2 alpha))/(2 C sum t^alpha) \
  R^2/(2 C k^(alpha + 1)) + (G^2 C^2 k^(2 alpha + 1))/(2 C k^(alpha + 1))
$

Set $C = R/G$ and $alpha = -1/2 - epsilon$.
$
  ~ (R G) / sqrt(k)
$

So the rate ends up being a bit worse than with $beta$-smoothness. That's because we were forced to take smaller and smaller steps to deal with the inadequacy of our linear model. $beta$-smooth functions give curvature information and can guarantee a substantive decrease per step.

=== Interior Points
The point of the Subgradient method is it can be applied to non-differentiable convex functions. Here's an important example. Consider the problem of finding a point at the intersection of some number of convex sets.
$
  l | l in inter.big C_i 
$

This is a very useful problem because oftentimes we are minimizing a function over a constrained domain. For convex minimization, if you can find a single point in this intersection, then following the gradient while staying in the convex set is sufficient to find the optimal answer (this approach is known as interior point methods). 

We can rewrite this problem into a convex minimization problem. Define
$
  f(z) = max_(i) min_(y in C_i) norm(y - z)^2
$

This function tells us to find the closest point for each set, and report the distance to the furthest point. The minimum of zero will occur if we're in an intersection of all sets. This function is clearly convex as it is the maximum of convex minimization problems (and we've shown both operations preserve convexity).

The max makes this non-differentiable, but we can still solve this with Subgradient methods. In particular, the Subgradient of this function will tell us we should move directly towards one of the convex sets (imagine we just had one convex set, and then you can use the property about the max of Subgradients).

#align(center, graphic(
  cetz.canvas({
    import cetz.draw: *;
    let x = 0
    let px = 0
    let step = 1.0
    for i in range(10) {
      x = step + px
      let stroke = (paint: blue, dash: "dashed")
      line((px, 0), (x, step), stroke: stroke)
      line((x, step), (x, 0), stroke: stroke)
      px = x
      step *= 0.5
    }
    line((0, 0), (3, 0), (3, -0.2), (0, -0.2), close: true, fill: green.transparentize(80%))
    line((0, 2), (3, -1), (3.14, -0.86), (0.14, 2.14), close: true, fill: green.transparentize(80%))
  })
))
I won't show this, but you can prove that this algorithm remains stable if you move all the way to the projection of the current point onto that set (see the above diagram). Pretty elegant algorithm!

== Projected Gradient Descent
#definition(name: "Projected Gradient Descent")[
  $x_(t + 1) = "Projection"(x_t - eta gradient f(x))$
]
The algorithm is quite simple, simply take gradient steps, and then force your point into the convex set after each step.

This is sensible because projection onto convex sets has some nice properties.
#lemma[
  $z = "Projection(x)" => "dot"(x - z, y - z) <= 0, forall y in C$
]
#proof[
  We know a point is the minimizer of a convex function if the negative gradient is more than ninety degrees off from any direction into the set (there is no direction we can move which decreases the function). Since minimizing the $norm(x - z)$ is the same as minimizing $1/2 norm(x-z)^2$ we have
  $
    "dot"(gradient 1/2 norm(x - z)^2, y - z) = "dot"(z - x, y - z) <= 0, forall y in C
  $
]

#theorem[
  $norm("Projection"(x_1) - "Projection"(x_2)) <= norm(x_1 - x_2)$
]
#proof[$
  "dot"(x_1 - z_1, z_2 - z_1) <= 0 \
  "dot"(x_2 - z_2, z_1 - z_2) <= 0 \
  "dot"((x_1 - x_2) + (z_2 - z_1), z_2 - z_1) <= 0 \
  "dot"(x_1 - x_2, z_2 - z_1) + norm(z_2 - z_1)^2 <= 0\
  norm(x_2 - x_1) norm(z_1 - z_2) >= norm(z_2 - z_1)^2 \
  norm(z_2 - z_1) <= norm(x_2 - x_1)
$]

This is a super useful property! Observe that this means projection strictly improves the answer.
$
  norm(P_C (x) - x^*) = norm(P_C (x) - P_C (x^*)) <= norm(x - x^*) 
$

Using this, it's easy to show all the rates we showed for earlier methods immediately generalize to projected gradient descent. 

== Proximal Gradient Descent
#definition(name: "Proximal Gradient Descent")[
  Minimize $f(x) + h(x)$ where $f, h$ are convex, but only $f$ is guaranteed differentiable.
  $
    "Prox"(y) = "argmin"_(z in R^d) 1/2 norm(y - z)^2 + h(z)\
    x_(t + 1) = "Prox"(x_t - eta gradient f(x))
  $
]
This can be seen as a generalization of both gradient descent and projected gradient descent by choosing $h$ to be zero or the indicator function. The main point of this is that just like projected gradient descent recovered the rates of gradient descent, we can recover those rates here too. This is an improvement over the rate you would get by applying the subgradient method. The idea behind $"Prox"$ is a step of GD can be viewed as minimizing a quadratic, and now we're just minimizing a quadratic plus an auxiliary term.

#theorem[$"Prox"$ is a contraction.]
#proof[
  $
    dif (1/(2 eta) norm(x - z^*)^2 + h(z^*)) \
    1/eta (x - z^*) + dif(h(z^*))
  $
  Hence, $z^*$ is a minimizer if and only if
  $
    1/eta (x - z^*) in dif(h(z^*))
  $

  You can then apply subgradient monotonicity
  $
    "dot"(g_x - g_y, x - y) >= 0, forall g_x in dif f(x), g_y in dif f(y) \
    "dot"(1/eta (x - z_1^*) -  1/eta (y - z_2^*), z_1^* - z_2^*)  >= 0 \
    "dot"(x - y, z_2 - z_1) >= norm(z_2 - z_1)^2 \
     norm(z_2 - z_1)^2 <= norm(x - y)^2
  $
]

#definition(name: "Generalized Gradient")[
  $G(x_t) = hf((x_t - "Prox"_(eta, h)(x_t - eta gradient f(x_t))), eta)$
]

*TODO*: Show that when the generalized gradient is zero, the function is optimal (use the first step of last proof and just algebra). Also contrast the generalized gradient to the subgradient.

== Stochastic Gradient Descent
*TODO*: Prove a sqrt(K) convergence rate.