# Heat diffusion

## Introduction

```math
\nabla \cdot (k \nabla T) + Q_h = ρ c \dot{T}
```

## Variational formulation


## Finite-element formulation

## One-dimensional example

Consider the one-dimensional heat equation, $\partial_t T(x, t) = \alpha \partial^2_{xx}T(x, t)$. Note that $\alpha := k / \rho c$ is assumed constant on this example such that the solution is easy to obtain using analytic means. We take $Q_h = 0$ and Dirichlet boundary conditions, $T(0) = T(1)=0$ and initial temperature distribution given by

```math
T(x, t=0) = \phi(x) := \sin \pi x + \frac{1}{2}\sin 3\pi x
```

```@eval
using Plots, LaTeXStrings

ϕ(x) = sin(π*x) + sin(3π*x)/2

ne = 50 # number of elements
xdom = 0:1/ne:1
T0 = ϕ.(xdom)

plot(0:1e-3:1, ϕ, seriestype=:line, lab=L"\phi(x)",
     xlab=L"x", ylab=L"T", legend=:bottomright, title="Initial temperature profile")
plot!(xdom, T0, seriestype = :scatter, lab=L"T(x=x_e, 0)")
```

The analytic solution in this case is

```math
T(x, t) = e^{-(\pi \alpha)^2 t}\sin \pi x + \frac{1}{2}e^{-(3\pi \alpha)^2 t}\sin 3\pi x,\qquad 0 \leq x \leq 1, t \geq 0.
```
