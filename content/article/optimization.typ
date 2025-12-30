#import "/typ/templates/blog.typ": *
#show: main.with(
  title: "Optimization",
  desc: "",
  date: "2025-12-30T13:39:22-05:00",
  tags: ("notes",),
)

#show: body => note_page(body, should_outline: false)

#definition(name: "Shubert-Piyavskii Method")[If you have a Lipschitz-continuous function with maximal slope $L$, every-time you sample a point lower-bound the function by lines of slope $plus.minus L$. Find the minimum of the lower-bound and use that to sample the next point. This is guaranteed to converge to the global minimum, and can definitively eliminate candidate parameter spaces.]

For convex functions you can use ternary search, fibonacci search, fit a quadratic to three points find the minimum and repeat, there's a lot of ways.

#definition(name: "Local Descent + Line Search")[
  So the idea is first come up with a direction you want to move in, then, treat it like a uni-variant optimization problem, where the step size controls how much you move in that direction. Then use one of the above techniques to arrive at a good step size.
]

#definition(name: "Trust Region Optimization")[
  The idea of this approach is to assume the Hessian is Lipschitz-continuous. Some math tells you that the error between a quadratic taylor expansion and the true objective function is at most cubic in the distance between the center of approximation and the target point. Decide on some maximum acceptable error $delta$.
  
  Now, start with some initial guess $R$ at the radius in which your model has error less then $delta$. If the error is much larger then $delta$, shrink $R$, if the error is much smaller then delta increase $R$ (error smaller then $delta$ means we are being more conservative then we need too).

  This is an interesting approach, being it chooses a step size and then the direction, rather then the direction and then the step size.
]

#definition(name: "Conjugate Gradient Descent")[
  Imagine you have a quadratic function of many variables: $ 1/2  x^top A x + b^top x + c$. Let $x in bb(R)^n$ and let $A$ be positive semi-definite.
  
  Then the idea is to choose $n$ optimization directions such that $d_i^top A d_j = 0, forall i, j$, these vectors are referred to as mutually conjugate. This property is nice because that means none of the directions "interfere" with each other.
  $
    (d_1 + ... + d_n)^top A(d_1 + ... + d_n) = d_1 A^top d_1 + ... + d_n A^top d_n 
  $

  The cross-terms all vanish. Another property is that it ensures all the vectors are linearly independent. 
  
  Now choose $d_1$ to be the gradient and choose the step size via line search. We choose $d_2 = g_2 + beta d_1$, where $g_2$ is the gradient at our new location. $beta$ is chosen to ensure our directions are mutually conjugate. We generate the other vectors in a similar fashion. 

  It's relatively straightforward to show the $n$ vectors form a basis, and the gradient with respect to each vector is zero, hence we have arrived at an optimum. 
]

#definition(name: "HyperGradient Descent")[
  Take the gradient with respect to the step size, and use that to adjust the step size dynamically throughout optimization. 
]

#definition(name: "Evolutionary Methods")[
  This includes CMA-ES, Natural Selection, and the Cross-Entropy method. Maintain some distribution over the parameter space. Sample a bunch of candidates, see how they do, and then update the proposal distribution to make it more likely to propose the best performing candidates.
]