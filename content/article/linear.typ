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

The block decomposition is so simple that we can analytically compute $f(A)$ by using Taylor expansions for each block. Pretty awesome.

One big problem is it’s not numerically stable because it depends a lot on whether two eigenvalues are exactly equal or not. Hence, it’s often preferred to use the #link("https://en.wikipedia.org/wiki/Schur_decomposition")[Schur Decomposition].

== Schur Decomposition
#theorem[
  Every square matrix can be written as $Q^(-1)T Q$ where $T$ is upper-triangular and $Q$ is orthonormal.
]
#proof[
  This is almost the same argument used to show #link(<diagonalizable>)[Symmetric matrices are diagonalizable]. Let the matrix be $A in R^(n times n)$. Find an eigenvalue. Construct an orthogonal basis for the corresponding eigenbasis. Extend the basis to cover the full space, and create a corresponding change of basis matrix $Q$. Now we have,
  $
    Q^T A Q = mat(
      lambda, ...;
      0, A_2;
    ) 
  $

  You can repeat the process recursively on $A_2$.
]


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

== LU Decomposition
#theorem[
  Any matrix $A$ can be written as 
  $
    P A = L U
  $

  Where P is a permutation matrix, L is lower-triangular, and U is upper-triangular.
]
#proof[
  Essentially, we get this result from Gaussian elimination. First observe that when we left-multiply a matrix $M$ by a matrix $R$, the entries of $R$ can be interpreted as "how much of each row" to include.

  Now, in Gaussian elimination, we walk down the diagonal, and subtract off multiples of the current row until everything in the current column below our entry has been eliminated. This entire operation can be summarized like this.

  $
    A arrow mat(
      1, ,  , , ...;
      , 1, , , ;
      , a, 1, , ;
      , b, , 1, ;
      ..., , , , ...;
    ) A =  mat(
      ..., ,  , , ...;
      0, f, g, h, ;
      0, 0, i, j, ;
      0, 0, k, l, ;
      ..., , , , ...;
    )
  $

  Where $a$ and $b$ are chosen to zero out the entries beneath the pivot ($f$). Call the matrix used at the $i$th step $L_i$. This can fail if the current diagonal entry is zero, but in that case we can just pivot: swap in a row with a non-zero entry. If there is no such row, then everything below the entry is already zero so you can keep going (note that in this case, the matrix is not invertible). This corresponds to multiplication by a permutation matrix, call the one we use at the $i$th iteration $P_i$. 
  
  At the end of Gaussian elimination, we'll end up with an upper-triangular matrix $U$, and the product of several row subtraction operations like above.
  $
    L_n P_n... L_1 P_1 A = L_n^* ... L_1^* P_n ... P_1 = L_n^* ... L_1^* P  = U
  $

  To see the re-arrangement step, we just do
  $
    L_(n - 1)^* = P_n L_(n - 1) P_n ^(-1) \
    L_(n - 2)^* = P_n P_(n - 1) L_(n - 2) P_(n - 1)^(-1) P_(n)^(-1) \
    ...
  $
  It's easily verified that the $L^*$ matrices only have their sub-diagonal entries re-arranged. As rough intuition for what happens, the left multiplications rearrange the rows, messing up the diagonals. The right multiplications rearrange columns which corrects the diagonal without touching the rest of the rows.
  
  Now, each of the $L$ terms can be inverted by negating the sub-diagonal entries (just try it). Hence, we can write 
  $
    P A = L_1^(-1)...L_n^(-1) U = L U
  $

  Finally, the product of lower-triangular matrices is lower-triangular which gives the final result.
  
]

== Cholesky Decomposition
#theorem[
  Any symmetric positive definite matrix $A$ can be written as 
  $
    A = L L^T
  $

  Where L is lower-triangular.
]
#proof[
  This uses the same idea of Gaussian elimination, except instead of zeroing out just the column we take advantage of the symmetry and also zero out the row.

  Hence, we apply operations like 
  $
    L_1 A L_1^top = mat(1, 0; 0, A_1)
  $

  At the end we'll end up with 
  $
    L_n ... L_1 A L_1^top ... L_n^top = I
  $

  From here doing the same inverse trick as Gaussian elimination gives the desired result. Now, it's important to note that _we did not need pivoting during this process_. This is because the positive definite property guarantees that all diagonal entries are non-zero.
  $
    e_i^top A e_i = e_i A_i = A_(i i) > 0
  $ 
]

The simpler decomposition and lack of pivoting makes this decomposition very useful when its applicable.

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

== Householder Triangularization
I won't cover this super thoroughly, but it's a cool idea so here's the gist. Apply a series of orthogonal matrices to $A$, such that you end up with a triangular matrix.
$
  Q_n ... Q_1 A = Q A = R
$

This is an alternative way to find a $Q R$ decomposition, which intriguingly is a bit slower but also numerically more stable.

Anyway, each orthogonal matrix will zero out the bottom of a column.
$
  mat(
    a, b, c;
    d, e, f;
    g, h, i 
  ) arrow 
  mat(
    sqrt(a^2 + d^2 + g^2), ..., ;
    0, ..., ;
    0, ...,  
  )
$

You do this by choosing $Q_i$ to be a reflection matrix, where it reflects $x$ along the line of symmetry between it and the target vector.

#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge
#align(center, graphic(
  diagram(
    // draw vectors from origin
    edge((0,0), (3, -4), "->", label: $x = vec(a, d, g)$, label-pos: .6),
    edge((0,0), (0.5*8, 0.5*-4), "--", label-pos: .6, ),
    edge((0,0), (5, 0), "->", label: $vec(||x||, 0, 0)$, label-pos: .6, label-side: right, label-sep: 1em),
  )
))

To do this, first take the difference between the current vector and the target vector, normalize it, and call it $v$. For a vector $x$, the component in the direction of $v$ is $(v v^*)x$. If you remove twice that component, you will have performed a reflection. Hence, you just choose $Q_i$ to be $I - 2 v v^*$.

== Reduction to Hessenberg Form
Hessenberg form is like triangularizing a matrix, except we only eliminate zeros beneath the off-diagonal. The final matrix will look like this.
$
  mat(
    a, b, c, d;
    e, f, g, h;
    ,  i, j, k;
    ,   , l, m;
  )
$

We can transform a matrix $A$ into a Hessenberg matrix as follows
+ Using the same trick as Householder triangularization, find an orthogonal transformation $Q$ that zeros everything below the off-diagonal.
+ Set $A = Q A Q^*$. You can verify the right multiplication will only change columns to right of the current column.

Now you could just left multiply $Q$, but doing both allows you to find a Hessenberg matrix $A$ is similar too, which is a first step in many other algorithms.

== Rayleigh Quotient Iteration
#definition[
  The Rayleigh Quotient $r(x)$ is defined as $r(x) = (x^top A x)/(x^top x)$.
]
#lemma[
  The eigenvalues of $(A - mu I)^(-1)$ are of the form $(lambda_j - mu)^(-1)$
]
#proof[$
  (A - mu I)^(-1) v = lambda v \
  v = (A - mu I) lambda v \
  (lambda^(-1) + mu) v = A v \
  (lambda^(-1) + mu) v = lambda_j v \
  lambda = (lambda_j - mu)^(-1)
$]

#definition(name: "Power Iteration")[Power iteration is the process whereby we take $v$, compute $A v$, then $A^2 v$, etc. until some convergence criteria is met]

It's easy to see that if we normalize at the end, the vector will converge to the eigenvector with the largest eigenvalue. Combining this with the above lemma gives a way to use power iteration to generate a particular eigenvector of a matrix, provided we have a good estimate of the corresponding eigenvalue. We can then compute the Rayleigh Quotient of this new eigenvector to get a better estimate of the corresponding eigenvalue, and repeat until convergence. 

== QR Iteration
#theorem[
  Under certain conditions $A^m V$ (where $V$ is $n$ linearly independent vectors) converges to the $n$ eigenvectors associated with the largest eigenvalues.
]
#proof[
  The idea is essentially power iteration but for many vectors. Define $V$ to be a $m times n$ matrix with $n$ linearly independent columns. Let $A$ be a symmetric real matrix with eigen-decomposition $U D U^top$. Let $hat(U)$ be the matrix whose first $n$ columns of $U$ and $hat(D)$ be the top left $n times n$ subset of $D$. Finally, let $epsilon$ be an $m times n$ matrix representing some error term. Then...
  $
    A^m V = U D^m U^top V = hat(U) hat(D)^m hat(U)^top V + lambda_(n + 1)^k epsilon = \
    (hat(U) hat(D)^m + lambda_(n + 1)^k epsilon (hat(U)^top V)^(-1)) hat(U)^top V approx \
    hat(U)hat(D)^m hat(U)^top V
  $

  We drop the $lambda_(n + 1)^k$ term because we assume it's smaller than all the eigenvalues chosen, hence its contribution drops off exponentially. 

  We conclude that $A^m V$ has the same column space as $hat(U)$. Now, repeat this argument over and over, where $V$ is the first column, the first two columns, etc. Since it converges to the same column space every time, it must be that the $i$th column of $V$ converges to the eigenvector associated with the $i$th largest eigenvalue.
  
  In order for this argument to hold, $hat(Q)^top V$ must always be invertible. One way this can hold is if the first $n$ rows of $hat(Q)$ are linearly independent. This is equivalent to saying all the leading principle submatrices are non-singular, or that $Q$ has an LU decomposition. 

  In general though, you don't need to worry about this, as $V$ projecting onto a space with rank less than $n$ only happens in adversarial cases. It's similar to the odds of random 2D points being colinear.
]

This gives us a method to directly compute all the eigenvectors! However, we also know from regular power iteration that each of the vectors in $V$ is also converging to the eigenvector with the largest eigenvalue. Hence, this basis will be really ill-conditioned. The easy fix is to simply find an orthonormal basis for the current $V$ on every iteration, and use that instead.
$
  Q_0 = I\
  V_k arrow.l A Q_(k - 1)\
  V_k arrow.r Q_k R_k\
  A_k = Q_k^top A Q_k approx D
$

That's essentially it! It's worth noting that usually you don't bother having a separate $V_k$, and instead just do
$
  A_0 = A\
  A_k arrow.r Q_k R_k\
  A_(k + 1) arrow.l R_k Q_k
$

This is equivalent to simultaneous iteration.
$
  A_k = (Q_(k - 1)...Q_0)^T A (Q_0...Q_(k -1)) = hat(Q_(k - 1))^T A hat(Q_(k - 1)) \
  A_i = Q_i R_i \
  hat(Q_(i - 1)) A_i = hat(Q_i) R_i \
  A hat(Q_(i - 1)) = hat(Q_i) R_i
$

The last step essentially specifies the same update rule as simultaneous iteration. It's worth noting that the QR decomposition can be found in $n^2$ instead of $n^3$ time. The trick is to first reduce $A$ to Hessenberg form, and then you can use Householder reflectors which only touch two rows to zero out the sub-diagonal entries. The Hessenberg structure will remain throughout this process, via a similar argument used in reducing to Hessenberg form.

Also, it's easy to see the diagonal entries of $A_k$ are Rayleigh quotients, and are converging rapidly towards the eigenvalues. You can use these estimates to further accelerate convergence of the QR algorithm (it's called the shifted QR algorithm) but I won't show that here.

== Arnoldi Iteration
This is a similar process to Gram-Schmidt orthogonalization, but it's used to compute a similar Hessenberg matrix. The main benefit over using Householder reflectors is that you can stop the process part way through (with Householder reflectors, you need to know every single reflector before you can conclude what the entries of $Q$ and $H$ are). This is very desirable for high-dimensional problems, where a partial reduction suffices.

Let $A, Q, H in RR^(m times m)$, with $H$ Hessenberg and Q orthonormal. Then,
$
  A Q = Q H
$

If we restrict ourselves to the first $n$ columns of $Q$: $Q_n$...
$
  A Q_n = Q_(n + 1)tilde(H_n)
$
Where $tilde(H_n)$ is an $(n + 1) times n$ sized Hessenberg matrix. We need the first $n + 1$ columns on the RHS because the Hessenberg matrix has sub-diagonal entries. This gives us a recurrence for the $n$th column.
$
  A q_n = h_(1 n)q_1 + ... + h_(n + 1, n) q_(n + 1)
$

Algorithmically, think of this as plugging some term $q_n$ in on the left and extracting a new vector $q_(n + 1)$. You can compute $h_(i j)$ for the first $n$ terms using projections, and for the last $h$ term it's just the magnitude of the remaining vector. For the first term $q_1 = frac(b, ||b||, style: "horizontal")$, vector you can choose any arbitrary $b$.

This is a bit different from Gram-Schmidt orthogonalization. Gram-Schmidt took each column of $A$, and subtracted out components. The Arnoldi iteration makes no attempt to use the columns of $A$. Instead, it repeatedly invokes $A$ on the previous iterate to compute the next iterate. It's easy to see the Arnoldi iteration computes a basis for the Krylov subspace (just stare at the recurrence).
$
  chevron.l b, A b, A^2 b, ..., A^(n - 1) b chevron.r
$

This Hessenberg matrix also has an interesting interpretation. 
$
  A Q_n = Q_(n + 1)tilde(H_n) \
  Q_n^* A Q_n = Q_n^* Q_(n + 1)tilde(H_n) \
  Q_n^* A Q_n = H_n
$

Where $H_n$ is the same as $tilde(H_n)$ with the bottom row chopped off. $H_n$ can be viewed as a projection matrix. Imagine I have some vector in the basis of $Q_n$, applying $H_n$ is equivalent to applying $A$ and then projecting back onto the Krylov subspace.

This Krylov basis ($Kappa_n$) is interesting. Imagine writing a vector $x$ in this basis.
$
  x = c_0 b + c_1 A b + ... + c_(n - 1) A^(n - 1) b = q(A) b
$

This gives Arnoldi iterations a connection to polynomials of matrices. You can prove that the characteristic polynomial of $H_n$, $h$ minimizes
$
  ||h(A) b||
$

Over the space of monic degree $n$ polynomials.

As a quick ad-lib of what happens,
$
  min ||h(A) b|| = min ||A^n b - Q_n y|| \
  h(A) b perp "column"(Q_n) \
  Q_n^* h(A) b = 0 arrow Q_n^* Q h(H) Q^* b = 0 \
  arrow h(H_n) = 0
$

The last step you get by analyzing $H$ as a block matrix. You can also show the last step is necessary, not just sufficient.

Let $h(A) = (A - a I)(A - b I)...$. The above result gives cool insights into the eigenvalues of $H_n$ (called the Ritz values).
+ The Ritz values of $A + lambda I$ are just shifted up by $lambda$.
+ The Ritz values of $lambda A$ are just scaled by $lambda$.

To see this, just think about how to change the roots of $h(A)$ in order to keep $h(A)b$ as small as possible.

This also gives insights into why the Ritz values are good approximations of eigenvalues. Namely, imagine if $h$ wasn't forced to be degree $n$, and could be larger. Then you could choose $h$ to be the characteristic polynomial of $A$, which would force $h(A)b = 0$ by the Cayley-Hamilton theorem. Since $h$ is only of dimension $n$, you cannot do that, but you could choose the zeros of $h$ to be close to the largest eigenvalues of $A$. This zeros out the eigenspaces which typically contribute to most of the magnitude of $h(A)b$. Of course, $b$ might not have much of a component in those dominant eigenspaces, so it may not be optimal to do this, but this nonetheless explains the tendency.

== GMRES


= Properties

== Rank and Spaces
#definition[
  The dimension of the space spanned by the columns of a matrix is called the column-rank. The analogous quantity for the rows is the row-rank. There are analogous quantities for null spaces.
]

#lemma[Let $B = F A$. If $F$ is invertible, the columns of $A$ are linearly independent iff the columns of $B$ are linearly independent.]
#proof[
  Suppose $exists alpha_1, ..., alpha_n$ s.t.
  $
    alpha_1 a_1 + ... + alpha_n a_n = 0
  $
  Then left-multiplying by $F$ immediately reveals...
  $
    alpha_1 F a_1 + ... + alpha_n F a_n = 0 \
    alpha_1 b_1 + ... + alpha_n b_n = 0 \ 
  $
  The reverse direction is shown by using $A = F^(-1) B$.
]

#lemma[Let $B = F A$. If $F$ is invertible, $"col-rank"(A) = "col-rank"(B)$]
#proof[
  Suppose $A$ has column-rank $r$, e.g it has $r$ linearly independent vectors. The previous lemma implies that $B$ has at least $r$ linearly independent vectors. Thus $"col-rank"(A) <= "col-rank"(B)$. The reverse is also true, since we can apply the same argument in reverse by saying $A = F^(-1) B$. This forces equality. 
]

#theorem[The row-rank is equal to the column-rank.]
#proof[
  Since all standard row operations (swapping, scaling, adding) can be represented as an invertible matrix applied on the left, we can row-reduce the matrix until it is in reduced #link("https://en.wikipedia.org/wiki/Row_echelon_form")[row-echelon] form.
  $
    mat(
      1, a, 0, d, 0, 0;
      0, 0, 1, 0, 0, 0;
      0, 0, 0, 0, 1, 0;
      0, 0, 0, 0, 0, 1;
    )
  $

  From here, it is clear the row-rank is equal to the column-rank as only columns / rows with pivots (leading ones) affect the rank, and there are an equal number of those.
]

This has some interesting implications, like $"rank"(A) = "rank"(A^top)$.

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

== Triangular Matrices
#theorem[
  The determinant of a triangular matrix is the product of its diagonal entries.
]
#proof[
  The determinant is invariant to column addition (think about a parallelogram), hence you can just zero out all the entries not in the diagonals, and the claim becomes plainly true.
]
#theorem[
  The Triangular matrix equation $T x = b$ can be solved in $n^2$ time.
]
#proof[
  Use back-substitution.
]

== Similar Matrices
#definition[
  $A$ and $B$ are similar if $A = P^(-1)B P$ for some matrix $P$
]

Similar matrices have a lot of nice properties.
$
  det(A) = det(P^(-1))det(B)det(P) = det(B)
$

Using Taylor expansions…

$
 f(A) = "poly"(A) = "poly"(P^(-1)Q P) = P^(-1)"poly"(Q) P = P^(-1)f(B)P
$

Crucially, every square matric is similar to an upper-triangular matrix. You can see this with the Schur or Jordan Decompositions. By the two properties above, we have
$
  det(f(A) - lambda I) = det(f(T) - lambda I)
$

This leads to the Spectral Mapping Theorem, which states that the eigenvalues of $f(A)$ are $f(T_(i i))$. To see the Spectral Mapping theorem, observe that for a triangular matrix $T$ its determinant is equal to the product of its diagonal entries.

This immediately implies the Cayley-Hamilton theorem, which states that every matrix satisfies its own characteristic equation.


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

== Norms
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

#theorem[$
  ||A||_(l_2 arrow l_2) = max_i sigma_i
$]
#proof[
  Observe that $A$ can be written as $U Sigma V^T$ using the SVD. Since $U$ and $V^T$ are orthonormal, $Sigma$ controls the scaling. Hence, the operator norm is equal to the largest entry of $Sigma$. 
]

#definition[
  The Frobenius norm of a matrix is the L2-norm of its singular value vector.
  $
    ||A||_F = sqrt(sum sigma_i^2)
  $
]

This is also equivalent to the sum of the matrice's entries squared (just look at the SVD and observe orthonormal matrices don't change vector norms).
This is algebraically powerful because you can express it in terms of traces.
$
  ||A||_F = sqrt("Tr"(A^top A))
$ 


#definition[
  The Nuclear or Trace norm is the L1-norm of its singular value vector.
  $
    ||A||_* = sum sigma_i
  $
]
Traces have some very nice algebraic properties, so this is probably the easiest norm from an algebraic standpoint. Furthermore, the Nuclear norm has the nice property that the corresponding norm ball has its extreme points at rank 1 matrices. Hence, it shows up in convex optimization contexts when you want low-rank results.

== Projection
#definition[
  A projector $P$ is a matrix which satisfies $P^2 = P$.
]
#lemma[
  If $P$ is a projector, then $I - P$ is also a projector, which projects onto the null space of $P$.
]
#proof[$
  (I - P)^2 v = (I^2 - 2 I P + P^2)v = (I - P)v \
  P(I - P)v = (P - P^2)v = 0
$]
#theorem[
  Let $S_1 = "range"(P)$ and $S_2 = "range"(I - P)$. Then the unique solution to 
  $
    v_1 + v_2 = v quad v_1 in S_1, v_2 in S_2
  $

  is $v_1 = P v, v_2 = (I - P) v$.
]
#proof[
  The choice of $v_1$ and $v_2$ above clearly produces a valid solution. However, perhaps there is some vector $v_3$, such that $v_1 - v_3 in S_1$, and $v_2 + v_3 in S_2$, which yields another solution? This requires $v_3 in S_1 inter S_2$. As $"range"(P) inter "null"(P) = 0$, the only vector which satisfies this is zero.
]

#definition[
  A projector whose null space is orthogonal to its range is an orthogonal projector.
]
#theorem[
  Orthogonal projectors must satisfy $P = P^*$.
]
#proof[
  For the forward direction we have
  $
    "dot"(P v, (I - P)v) = v P^* (I - P) v = v (P - P^2) v = 0         
  $

  For the backwards, let $q_1, ..., q_n$ be a basis for $"range"(P)$ and let $q_(n + 1), ... q_m$ be a basis for $"null"(P)$. Since we are assuming $P$ is an orthogonal projector, these two sets of vectors are mutually independent and thus form a basis for $R^m$. Define the $i$th column of $Q$ to be $q_i$. We immediately have,
  $
    P Q = mat(q_1, ..., q_n, 0, ..., 0)
  $

  And thus, 
  $
    Q^* P Q = mat(
      1, , , ;
      , 1, , ;
      , , 1, ;
      , , , 0...
    ) = Sigma
  $

  Hence, we've shown $P = Q Sigma Q^*$, and it's easy to see that $P = P^*$.
]

From the last proof, we also can say any orthogonal projector can be written as $P = hat(Q) hat(Q)^*$ where $hat(Q) = mat(u_1, ..., u_n)$. You can check that the reverse also holds. If I have some subspace defined the orthonormal basis encoded in $hat(Q)$, then $hat(Q) hat(Q)^*$ defines a projector onto that subspace. 

You can also do this trick even when given a non-orthogonal basis $A$. Let $v$ be in the input vector and let $y$ be the projection. Since $y in "range"(A)$, let $y = A x$. Then
$
  a_i^*(v - y) = 0 quad forall i \
  A^*(v - A x) = 0 arrow x = (A^* A)^(-1)A^* v \
  y = A (A^* A)^(-1)A^* v
$

So we get the new projector, $A (A^* A)^(-1)A^*$. This is familiar to anyone who's seen linear regression. Essentially, the matrix of data values is $A$, $y$ are the target values, and $b arrow x$ is the optimal set of coefficients.

== Kronecker Product
#definition[
  The Kronecker product $A times.o B$ is a block-matrix of the form
  $
    mat(A_11 B, ..., A_(1 n) B; ..., ..., ...; A_(n 1) B, ..., A_(n n) B; )
  $
]
#definition[
  $"vec"(X)$ is the vector obtained by stacking the columns of $X$.
]
#theorem[$
  "vec"(A X B) = (B^top times.o A) "vec"(X)
$]
#proof[
  Observe that
  $
    A X B_i = sum_j B_(i j) A X_j
  $
  If you do this for every $i$, you get the appropriate Kronecker product.
]
This is a useful tool when you are solving for matrices, for example
$
  A X B + X = C arrow (B^top times.o A + I)"vec"(X) = "vec"(C)
$


== Definite and Indefinite
#definition[
  A matrix $A$ is positive-definite if
  $
    x^top A x > 0, forall x
  $

  You can similarly definite negative definite and the semi variants which allow $x^top A x = 0$. If it doesn't fit into any of these categories, it's called indefinite.
]

The best way to think about these matrices is in terms of the $x^top A x$ object. This object is literally a quadratic equation in high dimensions. For a definite matrix, all choices of $x$ decrease $x^top A x$, or all directions increase $x^top A x$. Hence, you have a nice bowl shaped quadratic and this makes optimization easy. On the other hand, if some directions move you up and some move you down, you end up with a saddle. This can mess up gradient-descent based optimization methods.

#theorem[
  Positive definite matrices have positive diagonal entries.
]
#proof[
  $
    e_i^top A e_i = e_i A_i = A_(i i) > 0
  $ 
]

== Companion Matrix
A companion matrix is just a construction whose eigenvalue equation is exactly some polynomial. For the polynomial $c_1 + c_2 x + ... + c_n x^n + x^(n + 1)$. It can be constructed as follows.
$
  mat(
    0, 0, 0, ..., 0, c_1;
    1, 0, 0, ..., 0, c_2;
    0, 1, 0, ..., 0, c_3;
    0, 0, 1, ..., 0, c_4;
    dots.v, dots.v, dots.v, dots.down, dots.v, dots.v;
    0, 0, 0, ..., 1, c_n;
  )
$

This is useful to know because it means every root finding problem can be formulated as an eigenvalue problem. Since there is no formula for polynomials of degree five and greater, it implies there is no finite sequence of operations which can diagonalize an arbitrary matrix.

== Stability
/ Forward-Stable: An algorithm that gives almost the right answer (within epsilon relative error) to almost the right problem (inputs within epsilon relative error).
/ Backward-Stable: An algorithm which can be interpreted to give the exact right answer to a perturbed problem (within epsilon relative error of the original problem).

Inner products are forward and backward stable. Outer products are not backwards stable, because you cannot usually interpret the output matrix as the outer product of two perturbed input vectors (the perturbation to the output matrix doesn't factor).

If you have backwards stability, you can bound the error of the computation as follows.
+ Compute the maximum a local perturbation can affect the output (e.g. a $epsilon$ difference causes at most a $k epsilon$ change in the output). The size of this difference is known as the _condition_ of the problem.
+ Use step 1 to bound the error of the algorithm by bounding how different the output to the approximate problem is versus the original problem.

This is known as backwards error analysis is much simpler than the naive approach, where you try to compute the aggregate errors of individual floating point operations in an algorithm.


#definition[
  The condition number of a matrix is how sensitive it is to small perturbations. Suppose I have the equation $A x = b$, and there is some error $epsilon$, in $b$. The condition number tells me the maximum ratio of relative error in $b$ to relative error in $x$.
  $
   max_(epsilon, b != 0) frac((||A^(-1) epsilon||) / (||A^(-1) b||), (||epsilon||) / (||b||), style: "horizontal") = 
   max_(epsilon != 0) ((||A^(-1) epsilon||) / (||epsilon||)) max_(b != 0) ((||b||) / (||A^(-1) b||)) = \
   max_(epsilon != 0) ((||A^(-1) epsilon||) / (||epsilon||)) max_(gamma != 0) ((||A gamma||) / (||gamma||)) =\
   ||A^(-1)||||A||
  $

  Where the last step came from choosing $b = A gamma$.
]

*TODO*: Discretizing differential equations...