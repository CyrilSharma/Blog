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
Not every matrix is diagonalizable, but every matrix can still be written as $P^(-1)Q P$. The Jordan Normal form chooses $Q$ to be block diagonal, where “blocks” correspond to repeated eigenvalues, and the only off-diagonal entries have value $1$, are right above the diagonal and have an equal left and bottom child.
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

== QR Decomposition <Example>
Take an input a matrix $A in bb(R)^(n times m), n >= m$. Normalize the first column. Now remove the component of the second column along the first column and normalize. Repeat this process until you've orthogonalized every column of $A$. This is the $Q$ matrix. By construction, the $i$th column of $A$ can be written as a weighted sum of columns up to $i$ in $Q$, and hence we get $A = Q R$.

This decomposition is handy for solving linear equations where the $n != m$ and so the inverse is not defined. Consider the case of $n > m$. $n > m$ can be handled similarly.
$
  A x = b  arrow Q R x = b arrow mat(Q_1, Q_2)mat(R_1; 0) x = b arrow x = R_1^(-1)Q_1^top b
$

The blocked representation works because only $n$ linearly independent vectors are needed to span the column space of $A$. $R^(-1)$ can be computed very efficiently via back-substitution. 

This can also be used for computing determinants, since $Q$ can be chosen to have determinant $1$, hence $ det(A) = det(Q)det(R) = det(R) = product R_(i i) $
Where the last step follows from $R$ being triangular.

== SVD
This is a short proof sketch of the SVD. Using #link(<symmetric>)[what we know] about symmetric matrices we can conclude all the eigenvalues of $A^top A$ are real and all eigenvectors with different eigenvalues are orthogonal. Furthermore, using the Gram-Schmidt process, we can find an orthogonal basis that spans every eigenspace (i.e. the space of vectors which correspond to $A - lambda I  = 0$). Hence, we can construct an orthonormal basis for $A^T A$ using its eigenvectors meaning $A^T A$ is diagonalizable.
$
  A^top A = V D V^top
$

$D$ is a diagonal matrix with all positive entries. This is because
$
  ||A x|| >= 0 arrow x^top (A^top A)x = lambda x^top x >= 0 arrow lambda >= 0
$

Now let $A in bb(R)^(n times m)$ and suppose $A^top A$ has rank $r$. Then, only the first $r$ columns of $D$ have non-zero entries, and only the first $r$ rows of $V^top$ matter. Hence, we can write $V in bb(R)^(m times r), D in bb(R)^(r times r), $. Now let $Sigma = sqrt(D)$ and let $U =  A V Sigma^(-1) in bb(R)^(n times r)$. By construction, $A = U Sigma V^top$.

Finally, observe $U$ is orthonormal. We use the fact that $V^top A^top A V = D$
$
  U^T U = Sigma^(-1) V^top A^top A V Sigma = Sigma^(-1) D Sigma^(-1) = Sigma^(-1) Sigma^2 Sigma^(-1) = I
$

This decomposition for $A$ is known as the reduced SVD. 

= Algorithms
== Richardson Iteration
Suppose we want to solve $A x = b$. Computing inverses is expensive, and not easily done in parallel. Instead, we can run the following equation until we reach a fixed point.
$
  x_(k + 1) = x_k + w(b - A x_k)
$

Subtracting the true answer $x$ from both sides, and writing $e_k = x_k - x$.
$
  e_(k + 1) = e_k + w(b - A(x + e_k)) = e_k + w((b - A x) - e_k) = e_k + w A e_k = (I - w A)e_k  
$

So, the error goes to zero regardless of our initialization if $||I - w A|| < 1$, i.e. $|1 - w lambda_i|$ for all eigenvalues of $A$. If $A$ has both positive and negative eigenvalues, then no matter the choice of $w$ this condition is violated and there won't be convergence.

== Preconditioning
Again we want to solve $A x = b$. Instead of doing it directly let's first rewrite it as $A P^(-1) (P x) = b$. Now let's do this in two pieces.
$
  A P^(-1) y = b \
  P x = y
$

Why might this be a good idea? Well, methods like the Richardson Iteration require A's condition number to be near $1$ for fast convergence. This means the largest and smallest eigenvalues are very close and so $w$ can be chosen to make the error rapidly decay. However, $A$ might not have this property, but $A P^(-1)$ and $P$ might, given a good choice of $P$.


= Properties

== Trace
$
sum_(i, j, k)A_(i j)B_(j k)C_(k i) = T(A B C) = sum_(k, i, j)C_(k i)A_(i j)B_(j k) = T(C A B) = sum_(j, k, i)B_(j k)C_(k i)A_(i j) = T(B C A)
$

$
T(P^(-1) D P) = T(D) = sum_i lambda_i
$

So the trace of a matrix is the sum of its eigenvalues, or more generally the trace of $A^top A$ is the sum of singular values squared.

== Symmetric Matrices <symmetric>
All eigenvalues of a symmetric real matrix are real.

$
  "dot"(A u, u) = u^dagger A^dagger u = u^dagger A u = lambda u^dagger u \
  "dot"(A u, u) = (lambda u)^dagger u = lambda^dagger u^dagger u \
  lambda^dagger = lambda
$

For a symmetric matrix, all eigenvectors with different eigenvalues are orthogonal.

#mitex(`
  \text{dot}(Au, v) = \lambda_1 \text{dot}(u, v)\\
  \text{dot}(Av, u) = \lambda_2 \text{dot}(u, v)\\
  \text{dot}(Av, u) = \text{dot}(Au, v)
`)

The above facts directly imply the claim.

== Odd Polynomials & The SVD
Define $M^(2k + 1)  = M (M^top M)^K$. Then,

#mitex(`
M^\intercal M = (U\Sigma V^\intercal)^\intercal (U\Sigma V^\intercal) = (V \Sigma^\intercal U^\intercal) (U\Sigma V^\intercal) = V \Sigma^2 V^\intercal \\
(M^\intercal M)^k = V \Sigma^{2k} V^\intercal \\
M(M^\intercal M)^k = (U\Sigma V^\intercal)(V \Sigma^{2k} V^\intercal) = U\Sigma^{2k+1}V^\intercal
`)

The main observation here is that $M^top M$ has a rather simple form in terms of its SVD which makes its powers well-behaved.

It's easy to extend this to any linear combination of odd powers will also commute with the SVD.

Anyway, this gives you a lot of power. Muon uses this insight to cheaply "orthogonalize" a matrix e.g. converting $A = U Sigma V^T$ to $U I V^T$. They do this by choosing a matrix polynomial such that $"poly"^n (Sigma) arrow I$ for any $Sigma$. They choose $"poly"^n ~ "sign"$ which works because the SVD has positive singular values.