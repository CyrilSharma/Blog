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
#definition(name: "Convex Set")[
  Let $S in RR^n$. $S$ is convex iff $forall a, b in S, theta in [0, 1], a theta + b (1 - theta) in S$
]

Intuitively, this is a set which contains no "gaps", i.e empty regions between points in the set.
#align(graphic(cetz.canvas({
  import cetz.draw: *;
  circle((-3, 0), radius: 2, fill: green.transparentize(50%), stroke: none)
  rect((1, -2), (5, 2), fill: red.transparentize(50%), stroke: none)
  rect((2, -1), (4, 2), stroke: white, fill: white)
})))

It's straightforward to show convex sets remain convex under a variety of transforms, such as Cartesian products and intersections. Here are some other useful convexity preserving transformations.

// #theorem[
//   The intersection of convex sets is convex. 
// ]
// #proof[
//   Suppose $a, b in S_1 inter S_2$. Then,
//   $ a, b in S_1 arrow theta a + (1 - theta) b in S_1 \
//     a, b in S_2 arrow theta a + (1 - theta) b in S_2 \
//     theta a + (1 - theta) b in S_1 inter S_2
//   $
// ]

// #theorem[
//   The Cartesian product of two sets is convex.
// ]
// #proof[
//   Suppose $a, b in S_1 times S_2$. Then,
//   $
//     theta a_1 + (1 - theta) b_1 in S_1 \
//     theta a_2 + (1 - theta) b_2 in S_2 \ 
//     theta a + (1 - theta)b in S_1 times S_2
//   $
// ]

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
  Perspective functions $P(mat(x_1, ..., x_n)) = mat(x_1 / x_n, ..., x_(n - 1) / x_n)$ preserve convexity. Note that perspective functions require the last coordinate to be strictly positive.
]
#proof[
  Does $a, b in P(S) => theta a + (1 - theta) b in P(S)$? Let the pre-images of $a$ and $b$ be as follows.
  $
    x = (hat(x), x_n), y = (hat(y), y_n) \
  $
  $
    P(theta x + (1 - theta) y) =
    (theta hat(x) + (1 - theta) hat(y)) / (theta x_n + (1 - theta) y_n) =
    mu hat(x) + (1 - mu) hat(y) 
      
  $
]

Composing affine and projective functions lets you say linear fractional functions preserve convexity.
$
  P(vec(A, c^t)x + vec(b, d)) = (A x + b) / (c^t x + d)
$

// #theorem[
//   Any convex set can be represented as the intersection of a (potentially infinite) number of hyperplanes.
// ]
// This relies on the Supporting Hyperplane Theorem, which essentially says that for every point on the boundary, I can draw a hyperplane going through that point such that the entire set is on one side of the boundary. This is true if and only if you're working with a convex set.

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

The above two cones are useful for quantifying vertices, edges, and if we've reached optimality.

== Convex Functions
#definition(name: "Convex Function")[
  A function is convex if its *domain is convex*, and
  $
    f(theta x + (1 - theta) y) <= theta f(x) + (1 - theta)f(y) | forall theta in [0, 1]
  $
]

This object is the heart of convex analysis. Intuitively, the above definition says convex functions are functions where a line between two points on its graph lie above the rest of the graph. However, there are many other useful and equivalent ways to characterize them.
#theorem(name: "1st Order Convexity Statement")[
  $f in C^1(RR) => f(y) >= f(x) + gradient f(x) (y - x)$
]

#import "@preview/lilaq:0.3.0" as lq
#let indices = range(-20, 20)
#let xs = indices.map(i => i * 0.1)
#let p = 0.80
#let q = 1 - p

#let args = (mark: none, stroke: (thickness: 2pt));
#align(center,
  table(
    columns: 2,
    graphic(
      lq.diagram(
        lq.plot(xs, xs.map(x => x*x), ..args),
        lq.plot(xs, xs.map(x => 2 - 2.8*(x + 1.4)), stroke: (thickness: 2pt)),
        lq.plot(xs, xs.map(x => 2 - 1.5*(x + 1.4)), stroke: (thickness: 2pt, dash: "dashed"), mark: none),
        lq.plot(xs, xs.map(x => 2 - 0.5*(x + 1.4)), stroke: (thickness: 2pt, dash: "dashed"), mark: none),
        lq.plot(xs, xs.map(x => 2), ..args),
        xlim: (-2, 2),
        ylim: (0, 4)
      )
    ),
    graphic(
      lq.diagram(
        lq.plot(xs, xs.map(x => x*x), ..args),
        lq.plot(xs, xs.map(x => 2), ..args),
        lq.plot(xs, xs.map(x => 2 + 0.5*x), stroke: (thickness: 2pt, dash: "dashed"), mark: none),
        lq.plot(xs, xs.map(x => 2 - 0.5*x), stroke: (thickness: 2pt, dash: "dashed"), mark: none),
        lq.plot((0,), (2,), mark-size: 16pt),
        lq.plot((-1.4,), (2,), mark-size: 16pt),
        lq.plot((1.4,), (2,), mark-size: 16pt),
        xlim: (-2, 2),
        ylim: (0, 4)
      )
    )
  )
)

This essentially says any tangent line lower-bounds the convex function.
In the first diagram we can see how the zeroth order condition implies an upper bound on the slope ($0 => 1$), and in the second diagram we see how above the line draw by the zeroth order condition, no lower bound will be beneath both boundary points ($1 => 0$).

#theorem(name: "2nd Order Convexity Statement")[
  $f in C^2(RR) => gradient^2 f succ.eq 0$
]

#align(center,
  table(
    columns: 2,
    graphic(
      lq.diagram(
        lq.plot(xs, xs.map(x => 2 - 0.5*(x + 1.4)), stroke: (thickness: 2pt)),
        lq.plot(xs, xs.map(x => 2 - 1*(x)), stroke: (thickness: 2pt, dash: "dashed"), mark: none),
        lq.plot((-1,), (1.8,), mark-size: 16pt),
        lq.plot((1.4,), (0.6,), mark-size: 16pt),
        xlim: (-2, 2),
        ylim: (0, 4)
      )
    ),
    graphic(
      lq.diagram(
        lq.plot(xs, xs.map(x => 2 - 0*(x)), stroke: (thickness: 2pt)),
        lq.plot(xs, xs.map(x => 2 + 1.5*(x - 1.0)), stroke: (thickness: 2pt, dash: "dashed"), mark: none),
        lq.plot(xs, xs.map(x => 2 - 1.5*(x + 1.0)), stroke: (thickness: 2pt, dash: "dashed"), mark: none),
        lq.plot((0,), (2,), mark-size: 16pt),
        xlim: (-2, 2),
        ylim: (0, 4)
      )
    )
  )
)

The second statement says the Hessian must be positive semi-definite. This can be interpreted as saying no matter what direction I walk in, the slope along that curve must be non-decreasing.

The first diagram shows the $1 => 2$, as otherwise one of the lower bounds is broken. The second diagram shows $2 => 1$ as no matter which direction you move the function curves up away from your tangent line.

A useful tool for relating convex sets to convex functions is the epigraph.
#definition(name: "Epigraph")[
  $
    "Epi"(f) = { (x, t): f(x) <= t }
  $
]

#align(center,
  graphic(
    lq.diagram(
      lq.fill-between(xs, xs.map(x => x*x), y2: xs.map(x => 4)),
      xlim: (-2, 2),
      ylim: (0, 4)
    )
  ),
)

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

One example of this problem is finding the closest point in a convex set to a given point.
#align(graphic(cetz.canvas({
  import cetz.draw: *;
  line((-1.5, 1.5), (-0.70, 0.70), stroke: blue)
  rotate(z: 45deg)
  rect((-1, -1), (1, 1), fill: green.transparentize(90%))
})))

#proof[
  First observe $ "Epi"(f) = {(x, y, t): x, y in R^d, f(x, y) <= t } $
  Now, consider the intersection of $"Epi"(f)$ with
  $ C' = {(x, y, t): x in R^d, y in C, t in R} $
  $C'$ is convex, as it can be written $(R^d times C) times R$. $"Epi"(f)$ is convex by the theorem above and the cartesian product of convex sets is also convex.

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

// = Inequalities
// It turns out many of the most useful inequalities can be derived through analyzing a suitable convex function. 
// #theorem(name: "Jensen's Inequality")[$ f(E(x)) <= E(f(x)) $]
// #proof[
//   $
//     f(E(x)) = f(lim_(Delta x -> 0) (sum_i (x + i Delta x)p(x + i Delta x) Delta x)) <=\
//      lim_(Delta x -> 0) sum_i f(x + i Delta x)p(x + i Delta x)Delta x = E(f(x))
//   $
// ]

// #theorem(name: "Young's Inequality")[$ 1/p + 1/q => a b <= a^p / p + b^q / q $]
// #proof[$
//   exp(x/p + y/q) <=_"Convexity" exp(x)/p + exp(y)/q \
//   a, b > 0 | exp(log(a^p)/p + log(b^p)/q) <= exp(log(a^p))/p + exp(log(b^p))/q \
//   a b <= a^p / p + b^q / q
// $]

// #theorem(name: "Holder's Inequality")[$ 1/p + 1/q => sum_i |x_i y_i| = norm(x)_p norm(y)_q $]
// #proof[
//   $
//     a_i = x_i / norm(x)_p, b_i = y_i / norm(y)_q\
//     |a_i| |b_i| <= abs(a_i)^p / p + abs(b_i)^q / q  \
//     sum_i |a_i b_i| <= sum_i (abs(a_i)^p / p + abs(b_i)^q / q) \
//     1/(norm(x)_p norm(y)_q) sum_i x_i y_i <= 1/p sum_i abs(a_i)^p + 1/q sum_i abs(b_i)^q = 1/p + 1/q = 1 \
//     sum_i |x_i y_i| = norm(x)_p norm(y)_q
//   $
// ]

// Plugging in $p = 2$ gives you the Cauchy-Schwarz inequality.

= Algorithms
Here's some important terminology...
#definition(name: "Rates of Convergence")[
  Let $epsilon_t = hf(norm(x_(t+1) - x^*), norm(x_t - x^*)) quad lim_(t -> oo) epsilon_t = C$ \
  $C = 0 => "Super-Linear", C = 1 => "Sub-Linear", 0 < C < 1 => "Linear"$
]
#definition(name: "Descent Direction")[
  $h | f(x + eta h) <= f(x)$, for sufficiently small $eta$.
]

And here's some "nice" function classes we typically work with. Note that all of these have other characterizations.
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
#definition(name: "Gradient Descent")[
  $x_0 = hat(0) quad x_(t + 1) = x_t - eta_t nabla f(x_t) quad x_t approx min_(x in bb(R)^d) f(x)$
]

#lemma(name: "Descent Lemma")[
  For a $beta$-smooth function, gradient descent with $eta = hf(1, beta)$ yields
  $
    f(x_(t + 1)) <= f(x_t) - 1/(2 beta) norm(gradient f(x_t))^2
  $
]

Let's see what $beta$-smoothness tells us about GD.
$ norm(gradient f(x) - gradient f(y)) <= beta norm(eta gradient f(x)) = beta eta norm(gradient f(x)) $
#align(graphic(
  cetz.canvas({
    import cetz.draw: *;
    circle((0, 2), radius: 0.5, stroke: (dash: "dashed"))
    line((0, 0), (0, 2), mark: (end: "straight"), name: "x")
    line((0, 0), (0.36, 2.4), mark: (end: "straight"), name: "y")
    content((-1, 1), padding-right: 5pt, [$nabla f(x)$])
    content((1, 1), padding-right: 5pt, [$nabla f(y)$])
  })
))

Picture a circle of small radius (no bigger then $gradient f(x)$) around $gradient f(x)$. Within this small _region of trust_ ($eta <= 1/beta$) all vectors in the circle point at least somewhat in the direction of $gradient f(x)$. If you imagine breaking the path from $nabla f(x) -> nabla f(y)$ up, each step in that path will decrease the function. This is exactly what the proof exploits.

#proof[
  $
    "dot"(gradient f(x) - gradient f(y), gradient f(x)) <=_"Cauchy Scharz" beta eta norm(gradient f(x))^2  \
    norm(gradient f(x))^2 - "dot"(gradient f(y), gradient f(x)) <= beta eta norm(gradient f(x))^2  \
    -"dot"(gradient f(y), gradient f(x)) <= (beta eta - 1) norm(gradient f(x))^2 \
    f(x + h) = f(x) + integral_0^(1) gradient f(x + t h)^top (-eta gradient f(x))dif t \
    f(x + h) <= f(x) + integral_0^(1) (beta t eta - 1) eta norm(gradient f(x)) dif t\
    f(x + h) <= f(x) + ((beta eta^2) / 2 -  eta) norm(gradient f(x))^2 \
    f(x + h) <= f(x) - 1/(2 beta) norm(gradient f(x))^2
  $
]

// #proof[
//   $
//     f(x + h) <= f(x) + gradient f(x)^top h + beta/2 norm(h)^2 \
//     f(x_(t + 1)) <= f(x) - 1/beta norm(nabla f(x))^2 + 1/(2 beta) norm(nabla f(x_t))^2 \
//     f(x_(t + 1)) <= f(x) - 1/(2 beta) norm(nabla f(x_t))^2 = f(x) - eta/2 norm(gradient f(x_t))^2 \
//   $
// ]

// An interesting insight in the above proof is that if you differentiate the first line with respect to $h$, you get $x_(t + 1) = x_t - beta gradient f(x_t)$ which is the minimizer of the quadratic in terms of $h$. Hence, you can view gradient descent as repeatedly moving to the minimum of a locally fitted quadratic.

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
    f(x_k) - f(x^*) <= (beta)/(2k) norm(x_0 - x^*)^2
  $
]
// #proof[
//   $
//     norm(x_(t+1) - x^*)^2 = norm(x_t - eta gradient f(x_t) - x^*)^2 = \
//     norm(x_t - x^*)^2 + eta^2 norm(gradient f(x_t))^2 - 2 eta gradient f(x_t)^top (x_t - x^*) \
//     2 eta gradient f(x_t)^top (x_t - x^*) = norm(x_t - x^*)^2 - norm(x_(t+1) - x^*)^2 + eta^2 norm(gradient f(x_t))^2 \
//   $
//   Substitute in the first order convexity condition.
//   $
//      2 eta (f(x_t) - f(x^*)) <= norm(x_t - x^*)^2 - norm(x_(t+1) - x^*)^2 + eta^2 norm(gradient f(x_t))^2
//   $

//   Now use the descent lemma.
//   $
//      2 eta (f(x_t) - f(x^*)) <= norm(x_t - x^*)^2 - norm(x_(t+1) - x^*)^2 + eta^2 2 /eta (f(x_t) - f(x_(t + 1))) \
//      2 eta (f(x_(t + 1)) - f(x^*)) <= norm(x_t - x^*)^2 - norm(x_(t+1) - x^*)^2 \
//   $

//   Finally, use a telescoping sum to simplify things.
//   $
//      sum_(t=0)^(k-1) 2 eta (f(x_(t+1)) - f(x^*)) <= sum_(t=0)^(k-1) (norm(x_t - x^*)^2 - norm(x_(t+1) - x^*)^2) \
//     2 k eta (f(x_k) - f(x^*)) <= norm(x_0 - x^*)^2 - norm(x^(k) - x^*)^2 \
//     f(x_k) - f(x^*) <= 1/(2 k eta) norm(x_0 - x^*)^2  = beta /(2 k) norm(x_0 - x^*)^2
//   $
// ]

#let idxs = range(0, 1000)
#let xs = idxs.map(i => (float(i) - 500)/125)
#align(graphic(lq.diagram(
  lq.plot(xs, xs.map(x => -calc.exp(-x*x))),
  lq.plot((-3,),(0,), mark-size: 8pt)
)))

Without convexity, we could only say that the slope got pretty small. The reason we can say more with convexity is it gives a lower-bound on the norm of the gradient which by the descent lemma means we make substantial progress per step. This would not be the case if you were in a relatively flat region of a non-convex curve (shown above).

#proof[
  $
    f(x) - f(y) <= nabla f(x)^top (x - y) => norm(nabla f(x_t)) >= (f(x_t) - f(x^*))/(norm(x_t - x^*)) \
  $
  Substituting this lower-bound into the descent lemma yields...
  $
    f(x_(t + 1)) <= f(x_t) - 1/(2 beta)  (f(x_t) - f(x^*))^2/(norm(x_t - x^*))^2 \
    epsilon_(t + 1) <= epsilon_t - 1/(2 beta)  (epsilon_t^2)/norm(x_t - x^*)^2 <= 
    epsilon_t - 1/(2 beta)  (epsilon_t^2)/norm(x_0 - x^*)^2\
    epsilon_(t + 1) <= epsilon_t - c epsilon_t^2
  $

  This is a finite-difference equation! You can rearrange it to make it solvable with telescoping.
  $
    (epsilon_t - epsilon_(t + 1))/(epsilon_(t + 1)epsilon_t) >= c epsilon_t^2/(epsilon_(t + 1)epsilon_t) => 1/(epsilon_(t+1)) - 1/(epsilon_(t)) >= c \
    1/(epsilon_k) - 1/(epsilon_(0)) >= k c => epsilon_k <= 1/(k c)
  $

  So we get 
  $
    epsilon_k <= 2/(eta k) norm(x_0 - x^2) = (2 beta)/k norm(x_0 - x^2)
  $
  
  This bound is _not_ as tight as the theorem, however this proof is direct.
]


#theorem[
  If $f$ is $beta$-smooth and $alpha$-strongly convex, $eta = hf(1, beta)$ yields
  $
    norm(x_k - x^*)^2 <= (1 - alpha/beta)^k norm(x_0 - x^*)^2
  $

  That, is gradient descent yields linear convergence.
]
#proof[
  // Almost the same as the above proof. The first order convexity condition for $alpha$-strongly convex functions is as follows.
  // $
  //   f(y) >= f(x) + gradient f(x)^top (y - x) + alpha/2 norm(y - x)^2
  // $

  // So if you substitute that in to the above proof you get
  // $
  //    2eta(f(x_t) - f(x^*) + alpha / 2 norm(x_t - x^*)^2) <= norm(x_t - x^*)^2 - norm(x_(t + 1) - x^*) \
  //    norm(x_(t + 1) - x^*)^2 <= (1 - alpha / beta)norm(x_t - x^*)^2 \
  //    norm(x_k - x^*)^2 <= (1 - alpha / beta)^k norm(x_0 - x^*)^2
  // $

  $
     f(x_(t + 1)) <= f(x_t) - 1/(2 beta)  (f(x_t) - f(x^*))^2/(norm(x_t - x^*))^2 \
     alpha/2 norm(x_(t + 1) - x^*)^2 <= alpha/2 norm(x_t - x^*)^2 -(alpha^2)/(4 beta) norm(x_t - x^*)^2 \ 
     norm(x_(t + 1) - x^*)^2 <= (1 - alpha/(2 beta)) norm(x_t - x^*)^2 \
     norm(x_k - x^*)^2 <= (1 - alpha/(2 beta))^k norm(x_0 - x^*)^2 
  $

  Again, a slightly worse result then it is possible to prove.
]

#align(image("../img/bowl_trajectory_1_20.png"))
This $hf(alpha,beta)$ term is interesting. It's called the condition number of the problem. The intuitive reason for what this represents is the maximum difference in curvature between different directions. If you have a fixed step size, you have to make your step size small enough to deal with the maximum curvature regions. However, this means you move very slowly along the minimum curvature regions (shown above). Dealing with this problem is why momentum and higher-order methods were developed!

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
    "argmin"_(x in C) f(x) = "argmin" f(x) + I_C (x) = \
    dif f(x) + I_C(x) = dif f(x) + "NC"(x)
  $
  $0$ must be in the subgradient of $x^*$ for it to be optimal.
  $
    f(y) >= f(x^*) => f(y) >= f(x^*) + 0^top (y - x)
  $
  Hence $0 in dif f(x) + "NC"(x)$ which shows the claim.
]

#definition(name: "Subgradient Method")[
  Essentially, replace the gradient in gradient descent with the subgradient.
]

Interestingly, the negative subgradient is _not_ guaranteed to be a descent direction! You can see this with $|x|$. Furthermore, this can happen even at a suboptimal point. Consider the function $|x| + 2|y|$. At $(1, 0)$ a valid negative subgradient is $(-1, 2)$. Hence, $1 - epsilon + 2 (2 epsilon) = 1 + 3 epsilon$. You can see some nice examples #link("https://parameterfree.com/2018/06/20/54/")[here].

However, for 1D functions this actually cannot happen. This is because the subgradient is convex and for a point to be suboptimal it must not contain zero. Hence, the subgradient and the true descent direction always have the same sign in this case.

#theorem[
  For a convex $G$-lipschitz function and step sizes $n_t$, we have
  $
    f(x_t^"best") - f(x^*) <= (norm(x_0 - x^*)^2 + G^2 sum n_t^2)/(2 sum n_t)
  $
]
#proof[
  Expand $norm(x_(t + 1) - x^*)^2$ in terms of $x_t$ to obtain.
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

#import "@preview/ctz-euclide:0.1.5": *
#align(graphic(cetz.canvas({
  ctz-init()
  ctz-style(point: (
    shape: "circle",
    size: 0.06,
    stroke: black + 0.8pt,
    fill: white,
  ))
  ctz-def-points(z: (-2, 0), z2: (2, 0), x1: (-3, 1), x2: (3, 1))
  ctz-draw(
    points: ("z", "z2", "x1", "x2"),
    labels: (
      z: (pos: "below left", text: $z_1$),
      z2: (pos: "below right", text: $z_2$),
      x1: (pos: "above left", text: $x_1$),
      x2: (pos: "above right", text: $x_2$)
    )
  ) 
  ctz-draw-line("z", "z2", stroke: (dash: "dashed"))
  ctz-draw-line("x1", "x2", stroke: (dash: "dashed"))
  ctz-draw-line("x1", "z")
  ctz-draw-line("x2", "z2")
  ctz-draw-angle("z","x1","z2", radius: 0.4)
  ctz-draw-angle("z2","z","x2", radius: 0.4)
  ctz-draw(
    ellipse: ((0, 0), 2.0, 0.5),
    sketchy: true, stroke: blue,
    fill: blue.transparentize((90%)),
    roughness: 5
  )
})))

The proof is just formalizing the above geometric argument.

#proof[
  $
    "dot"(x_1 - z_1, z_2 - z_1) <= 0 \
    "dot"(x_2 - z_2, z_1 - z_2) <= 0 \
    "dot"((x_1 - x_2) + (z_2 - z_1), z_2 - z_1) <= 0 \
    "dot"(x_1 - x_2, z_2 - z_1) + norm(z_2 - z_1)^2 <= 0\
    norm(x_2 - x_1) norm(z_1 - z_2) >= norm(z_2 - z_1)^2 \
    norm(z_2 - z_1) <= norm(x_2 - x_1)
  $
]

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
    1/eta (z^* - x) + dif(h(z^*))
  $
  Hence, $z^*$ is a minimizer if and only if
  $
    1/eta (x - z^*) in dif(h(z^*))
  $

  You can then apply subgradient monotonicity
  $
    "dot"(g_x - g_y, x - y) >= 0, forall g_x in dif h(x), g_y in dif f(y) \
    "dot"(1/eta (x - z_1^*) -  1/eta (y - z_2^*), z_1^* - z_2^*)  >= 0 \
    "dot"(x - y, z_2 - z_1) >= norm(z_2 - z_1)^2 \
     norm(z_2 - z_1)^2 <= norm(x - y)^2
  $
]

#definition(name: "Generalized Gradient")[
  $G(x_t) = hf((x_t - "Prox"_(eta, h)(x_t - eta gradient f(x_t))), eta)$
]
#theorem[
  $G(x^*) = 0 => x^* = "argmin"_x G(x)$
]
#proof[
  $
    G(x^*) = 0 => "Prox"_(eta, h)(x_t - eta gradient f(x_t)) = x_t \
    tilde(x) = x_t - eta gradient f(x_t) quad z^* = "Prox"_(eta, h)(tilde(x)) \
    1/eta (tilde(x) - z^*) = 1/eta (x_t - z^* - eta gradient f(x_t)) => \
    G(x_t) in gradient f(x_t) + dif(x_t - eta G(x_t)) \
    0 in gradient f(x_t) + dif h(x_t)
  $
]

So, you can see this approach takes a qualitatively different step then the subgradient method, it evaluates the sub-differential at an offset point. This will actually lead to a better rate of convergence!

== Stochastic Gradient Descent
#definition(name: "SGD")[
  You wish to minimize the risk $R = E_(X times Y) l_theta (x, y)$. If you can draw $(x_t, y_t)$ samples simply choose the gradient step to be
  $
    theta_(t+1) = theta_t - eta gradient_theta l(f_theta (x_t), y_t)
  $
]
#theorem[
  Given the following conditions.
  + $norm(theta_0 - theta^*) = R$
  + $forall theta, E_(x, y, theta) (norm(nabla_theta l(f_theta (x), y))^2) = E(norm(g)^2) <= G$.
  SGD achieves the following rate.
  $
    E(f(1/k sum theta_t, x, y) - f(theta^*, x, y)) <= (R G)/sqrt(k)
  $
]
#proof[
  We use our standard approach of bounding step sizes.
  $
     norm(theta_(t+1) - theta^*)^2 = norm(theta_t - theta^*)^2 + eta^2 norm(tilde(g_t))^2 - 2 eta tilde(g_t)^top (theta_t - theta^*) \
     E(norm(theta_(t+1) - theta^*)^2|theta_t) <= norm(theta_t - theta^*)^2 + eta_t^2 E(norm(tilde(g_t))^2 |theta_t) - 2 eta_t tilde(g_t)^top (theta_t - theta^*) \  
     E(norm(theta_(t+1) - theta^*)^2 | theta_t) <= E(norm(theta_t - theta^*)^2) + eta_t^2 E(norm(tilde(g_t))^2 |theta_t) - 2 eta_t (f(theta_t, x, y) - f(theta^*, x, y)) \
    //  E(norm(theta_(t+1) - theta^*)^2) <= E(norm(theta_t - theta^*)^2) + eta_t^2 G^2 - 2 eta_t E(g_t^top (theta_t - theta^*)) \
     E(norm(theta_(t+1) - theta^*)^2) <= E(norm(theta_t - theta^*)^2) + eta_t^2 G^2 - 2 eta_t E(f(theta_t, x, y) - f(theta^*, x, y))
  $

  Apply the same analysis done in the subgradient portion to obtain
  $
    (R G) / sqrt(k) &>= 1/k sum E(f_(theta_i) (x, y) - f_(theta^*) (x, y)))\
    &= (1/k sum E(f(theta_i, x, y))) - E(f (theta^*, x, y)) \
    &= E(f(1/k sum (theta_t), x, y)) - E(f(theta^*, x, y))
  $
]