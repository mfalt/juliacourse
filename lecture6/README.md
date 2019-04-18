# Optimization and Learning
- Automatic differentiation
  - ForwardDiff.jl
  - ReverseDiff.jl
  - TaylorSeries.jl
  - Zygote.jl
  - Flux.Tracker
- JuMP.jl: Modeling language for all kinds of optimization problems.
- Optim.jl: Native julia solvers, supports AD
- ProximalOperators.jl:
- Convex.jl: Modeling language for convex optimization problems.
- Flux.jl: Native Julia Deep learning
- TensorFlow.jl: What you would expect

Why DL in Julia? 
When coding in julia, you machine learning library is likely written in julia (e.g., Flux). You can inspect the code, understand it, modify it, debug it. You do not have to write your code in a DSL using a subset of the host language (every python DL-framework), you can write pretty much any valid julia code and use it together with AD. This holds to such an extent that learning works even if it’s an afterthought, using a model that was originally built for simulation only.
