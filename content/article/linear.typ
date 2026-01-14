#import "/typ/templates/blog.typ": *
#import "@preview/mitex:0.2.6": *
#show: main.with(
  title: "Linear",
  desc: "",
  date: "2025-12-31T17:53:14-05:00",
  tags: ("notes",),
)

#show: note_page

= Decompositions

== Jordon Normal Form
#theorem[
  Every square matrix can be written as $P^(-1)Q P$ where $Q$ is block-diagonal.
]

The "blocks" in the block diagonal correspond to repeated eigenvalues, and the only off-diagonal entries have value $1$, are right above the diagonal and have an equal left and bottom child.
$
  Q =mat(
    lambda_1, 1, 0, 0, 0, 0;
    0, lambda_1, 0, 0, 0, 0;
    0, 0, lambda_2, 1, 0, 0;
    0, 0, 0, lambda_2, 1, 0;
    0, 0, 0, 0, lambda_2, 0; 
    0, 0, 0, 0, 0, lambda_3, 
  )
$

Using Taylor expansions…

$
 f(A) = "poly"(A) = P^(-1)"poly"(Q) P = P^(-1)f(Q)P
$

This leads to a lot of interesting results. One result is the Spectral Mapping Theorem, which states that the eigenvalues of $f(A)$ are $f(lambda_i)$. To see the Spectral Mapping theorem, observe that for a triangular matrix
$
  det(A - lambda I) = 0
$

If $lambda$ is chosen to be equal to any of the diagonal elements (as this makes that column linearly dependent).

This immediately implies the Cayley-Hamilton theorem, which states that every matrix satisfies its own characteristic equation.

The block decomposition is so simple that we can analytically compute $f(A)$ by using Taylor expansions for each block. Pretty awesome.

One big problem with it, is that it’s not numerically stable because it depends a lot on whether two eigenvalues are exactly equal or not. In particular, $P$ is very ill-conditioned.

Hence, it’s often preferred to use the #link("https://en.wikipedia.org/wiki/Schur_decomposition")[Schur Decomposition] which instead of insisting that $Q$ is practically diagonal, allows it to be merely upper-triangular. It also has the nice property that $P$ is now unitary. However, now we’ve lost the sparse structure of $Q$.

Intriguingly, you can actually do similar stuff for continuous transformations (like multiplying a function by x).  Diagonalization corresponds to untangling the systems' dynamics, it's pretty cool!

== QR Decomposition
#theorem[
  Any matrix $A$ can be written as $Q R$, where $Q$ is orthonormal.
]
#proof[
  Take an input a matrix $A in bb(R)^(n times m), n >= m$. Normalize the first column. Now remove the component of the second column along the first column and normalize. Repeat this process until you've orthogonalized every column of $A$. This is the $Q$ matrix. By construction, the $i$th column of $A$ can be written as a weighted sum of columns up to $i$ in $Q$, and hence we get $A = Q R$.
]
This decomposition is handy for solving linear equations where the $n != m$ and so the inverse is not defined. Consider the case of $n > m$. $n > m$ can be handled similarly.
$
  A x = b arrow Q R x = b \ mat(Q_1, Q_2)mat(R_1; 0) x = b \ x = R_1^(-1)Q_1^top b
$

The blocked representation works because only $n$ linearly independent vectors are needed to span the column space of $A$. $R^(-1)$ can be computed very efficiently via back-substitution. 

This can also be used for computing determinants, since $Q$ can be chosen to have determinant $1$, hence $ det(A) = det(Q)det(R) = det(R) = product R_(i i) $
Where the last step follows from $R$ being triangular.

== SVD
#theorem[
  Any matrix $A in bb(R)^(n times m)$ with rank $r$ can be written as $A = U Sigma V^top$ where $U in bb(R)^(n times r), V in bb(R)^(m times r), Sigma in bb(R)^(r times r)$, $U$, $V$ are orthonormal, and $Sigma$ is diagonal and non-negative.
]
#proof[
  Since #link(<diagonalizable>)[symmetric matrices are diagonalizable], we can write
  $
    A^top A = V D V^top
  $

  Where $V$ is an orthonormal matrix and $D$ is a diagonal matrix. $D$ has all positive entries. This is because
  $
    ||A x|| >= 0 arrow x^top (A^top A)x = lambda x^top x >= 0 arrow lambda >= 0
  $

  Now let $A in bb(R)^(n times m)$ and suppose $A^top A$ has rank $r$. Then, only the first $r$ columns of $D$ have non-zero entries, and only the first $r$ rows of $V^top$ matter. Hence, we can write $V in bb(R)^(m times r), D in bb(R)^(r times r)$. Now let $Sigma = sqrt(D)$ and let $U =  A V Sigma^(-1) in bb(R)^(n times r)$. By construction, $A = U Sigma V^top$.

  Finally, observe $U$ is orthonormal. We use the fact that $V^top A^top A V = D$
  $
    U^T U = Sigma^(-1) V^top A^top A V Sigma = Sigma^(-1) D Sigma^(-1) = Sigma^(-1) Sigma^2 Sigma^(-1) = I
  $

  This decomposition for $A$ is known as the reduced SVD. The entries of $Sigma$ are known as the singular values, and the columns of $U$ and $V$ are known as the singular vectors.
]

= Algorithms
== Richardson Iteration
#theorem[
  Suppose we want to solve $A x = b$. Computing inverses is expensive, and not easily done in parallel. Under certain conditions, we can instead run the following equation until we reach a fixed point.
  $
    x_(k + 1) = x_k + w(b - A x_k)
  $
]
#proof[
  Subtracting the true answer $x$ from both sides, and writing $e_k = x_k - x$.
  $
    e_(k + 1) = e_k + w(b - A(x + e_k)) = \
    e_k + w((b - A x) - e_k) = e_k + w A e_k = (I - w A)e_k  
  $

  So, the error goes to zero regardless of our initialization if $||I - w A|| < 1$, i.e. $|1 - w lambda_i| < 1$ for all eigenvalues of $A$. If $A$ has both positive and negative eigenvalues, then no matter the choice of $w$ this condition is violated and there won't be convergence. This means $A$ should not be indefinite. It's also easy to see that if the $lambda$s are tightly concentrated, then $|1 - w lambda_i|$ can be made quite small, allowing fast convergence.
]

As a sidenote, Richardson Iterations are equivalent to doing gradient descent on the following quadratic function.
$
  1/2 x^top A x - b^top x + c 
$

The convergence condition above corresponds to ensuring the quadratic is bowl shaped instead of saddle shaped, which ensures the gradient consistently points towards or away from the flat part of the curve.

== Preconditioning
#definition[
  Again we want to solve $A x = b$. Instead of doing it directly let's first rewrite it as $A P^(-1) (P x) = b$. Now let's do this in two pieces.
  $
    A P^(-1) y = b \
    P x = y
  $

  This is known as the right-preconditioned system. You can also solve the left-preconditioned system.
  $
    P A x = P b
  $
  #{""}
]

Why might this be a good idea? Well, methods like the Richardson Iteration converge fast if the largest and smallest eigenvalues are close. $A$ might not have this property, but $A P^(-1)$ and $P$ might, given a good choice of $P$.

For example, if you use a left-preconditioned system and set $P = A^top$, then even if $A$ wasn't positive semi-definite, $P A$ is positive semi-definite, and Richardson iterations or conjugate gradient descent will converge swiftly.


= Properties

== Trace
#theorem[The trace is invariant to cyclic permutations.]
#proof[$
sum_(i, j, k)A_(i j)B_(j k)C_(k i) = T(A B C) = \
sum_(k, i, j)C_(k i)A_(i j)B_(j k) = T(C A B) = \
sum_(j, k, i)B_(j k)C_(k i)A_(i j) = T(B C A)
$]

Furthermore, 
$
T(P^(-1) D P) = T(D) = sum_i lambda_i
$

So the trace of a matrix is the sum of its eigenvalues, or more generally the trace of $A^top A$ is the sum of singular values squared.

== Symmetric Matrices
#theorem[All eigenvalues of a symmetric real matrix are real.]
#proof[$
  "dot"(A u, u) = u^dagger A^dagger u = u^dagger A u = lambda u^dagger u \
  "dot"(A u, u) = (lambda u)^dagger u = lambda^dagger u^dagger u \
  lambda^dagger = lambda
$]

#theorem[For a symmetric matrix, all eigenvectors with different eigenvalues are orthogonal.]
#proof[$
  "dot"(A u, v) = lambda_1 "dot"(u, v) \
  "dot"(A v, u) = lambda_2 "dot"(u, v) \
  "dot"(A v, u) = "dot"(A u, v) \
  lambda_1 "dot"(u, v) = lambda_2 "dot"(u, v) \
  "dot"(u, v) = 0 
$]

#theorem[Symmetric Matrices are diagonalizable.] <diagonalizable>
#proof[
  We know all the eigenvalues of the symmetric matrix $A_n$ are real. Hence, $A_n$ has some real eigenvector corresponding to some real eigenvalue, call this $u_1$. Extend $u_1$ to an orthonormal basis $u_1, ..., u_n$ for $bb(R)^n$. Let $U_n$ be the orthonormal matrix whose columns are $u_1, ... u_n$. Now, define $A_(n - 1)$ as
  $
    A_(n - 1) = U_n A_n U_n^top
  $

  Observe $A_(n - 1)$ is symmetric.
  $
    A_(n - 1)^top = U_n A_n^top U_n^top = A_(n - 1) 
  $

  Hence, $A_(n - 1)$ is symmetric. Furthermore, 
  $
    A_(n - 1)vec(1, 0, ..., 0) = U_n A_n U_n^top vec(1, 0, ..., 0) = \
    U_n A_n u_1 = U_n lambda_1 u_1 = \
    vec(lambda_1, 0, ..., 0)
  $

  Combining the two properties, $A_(n - 1)$ looks like this.
  $
    mat(
      lambda_1, 0;
      0, B;
    )
  $

  Because $A_(n - 1)$ is symmetric its principal submatrix $B$ is also symmetric. Observe that any eigenvector $b$ for $B$ can produce an eigenvector for $A_(n - 1)$, $vec(0, b)$. We can use the first column of $A_(n - 1)$ and $vec(0, b)$ to orthogonalize $A_(n - 1)$, and we can keep doing this until we arrive at $A_1$ which is completely diagonal.
  $
    Q_1 .... Q_n A_n Q_n^top ... Q_1 ^top = Q A_n Q^top = D
  $

  Where $D$ is a diagonal matrix consisting of the eigenvalues of $A_n$ and $Q$ is the product of the orthonormal matrices. Since the product of orthonormal matrices is also orthonormal, $Q^top = Q^(-1)$ and thus $A_n$ is diagonalizable.
]

== Odd Polynomials & The SVD
#definition[$
  M^(2k + 1)  = M (M^top M)^k
$]

#theorem[
  Given the SVD of $M$ is $U Sigma V$...
  $
    M^(2k + 1) = U Sigma^(2k + 1) V
  $
]

#proof[$
  M^top M = \(U Sigma V^top)^top (U Sigma V^top) = (V Sigma^top U^top)(U Sigma V^top) = V Sigma^2 V^top \
  (M^top M)^k = V Sigma^(2 k) V^top \
  M(M^top M)^k = (U Sigma V^top)(V Sigma^(2 k) V^top) = U Sigma^(2 k + 1) V^top
$]

The main observation here is that $M^top M$ has a rather simple form in terms of its SVD which makes its powers well-behaved.

It's easy to extend this to any linear combination of odd powers will also commute with the SVD.

Anyway, this gives you a lot of power. Muon uses this insight to cheaply "orthogonalize" a matrix e.g. converting $A = U Sigma V^T$ to $U I V^T$. They do this by choosing a matrix polynomial such that $"poly"^n (Sigma) arrow I$ for any $Sigma$. They choose $"poly"^n ~ "sign"$ which works because the SVD has positive singular values.

== Orthogonality
#theorem[
  A set of mutually orthogonal vectors is a set of linearly independent vectors.
]

#proof[
  Define the basis to be $u_1, ..., u_n$. Then we have
  $
      "dot"(u_i, u_j) = 0 quad forall i != j,
  $

  Now suppose the basis was linearly dependent. Then, there must exist $a_1, ..., a_n$ such that 
  $
    a_1 u_1 + ... + a_n u_n = 0
  $

  Now we have
  $
    "dot"(a_1 u_1, a_2 u_2 + ... + a_n u_n) = \
    a_1 a_2 "dot"(u_1, u_2) + ... + a_1 a_n "dot"(u_1, u_n) = 0 \
    "dot"(a_1 u_1, a_2 u_2 + ... + a_n u_n) = "dot"(a_1 u_1, -a_1 u_1) = -a_1 "dot"(u_1, u_1) < 0
  $

  Hence, we've arrived at a contradiction, and our basis must be linearly independent.
]

#theorem[The product of orthonormal matrices is also orthonormal.]
#proof[$
  U := [u_1, ..., u_n], V := [v_1, ..., v_n] \
  "dot"(U v_i, U v_j) = v_i^top U^top U v_j = 0 \
  "dot"(U v_i, U v_i) = v_i^top U^top U v_i = 1
$]

== Metrics
#definition[
  The operator norm of a matrix is the largest amount it can scale any vector.
  $
    ||A|| = sup{ ||A v|| : ||v|| <= 1}
  $
]

The specific value of the operator norm depends on how you measure "large". For example, you could measure how much the L2-Norm scales. You can even use different input and output norms. For example,
$
  sup{ ||A v||_(l_2) : ||v||_(l_1) <= 1}
$

For the common case of $l_2 arrow l_2$, observe that $A$ can be written as $U Sigma V^T$ using the SVD. Since $U$ and $V^T$ are orthonormal, $Sigma$ controls the scaling. Hence, the operator norm is equal to the largest entry of $Sigma$. 

#definition[
  Suppose I have the equation $A x = b$, and there is some error $epsilon$, in $b$. The condition number measures how "sensitive" the output is given a change a small change in the input, more precisely it is the maximum ratio of relative error in $b$ to relative error in $x$.
  $
   max_(epsilon, b != 0) frac((||A^(-1) epsilon||) / (||A^(-1) b||), (||epsilon||) / (||b||), style: "horizontal") = 
   max_(epsilon != 0) ((||A^(-1) epsilon||) / (||epsilon||)) max_(b != 0) ((||b||) / (||A^(-1) b||)) = \
   max_(epsilon != 0) ((||A^(-1) epsilon||) / (||epsilon||)) max_(gamma != 0) ((||A gamma||) / (||gamma||)) =\
   ||A^(-1)||||A||
  $

  Where the last step came from choosing $b = A gamma$.
]

== Definite and Indefinite
#definition[
  A matrix $A$ is positive-definite if
  $
    x^top A x > 0, forall x
  $

  You can similarly definite negative definite and the semi variants which allow $x^top A x = 0$. If it doesn't fit into any of these categories, it's called indefinite.
]

The best way to think about these matrices is in terms of the $x^top A x$ object. This object is literally a quadratic equation in high dimensions. For a definite matrix, all choices of $x$ decrease $x^top A x$, or all directions increase $x^top A x$. Hence, you have a nice bowl shaped quadratic and this makes optimization easy. On the other hand, if some directions move you up and some move you down, you end up with a saddle. This can mess up gradient-descent based optimization methods.