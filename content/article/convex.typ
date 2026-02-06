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

From this property, you can immediately deduce that maxes of convex function are still convex, and a lot of other properties.

*TODO*: Setup of a convex optimization problem.

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