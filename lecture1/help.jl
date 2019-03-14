?
"""https://docs.julialang.org/en/v1/"""

using StaticArrays
apropos("svd")
A = @SMatrix randn(3,3)
@which A+A
@which svd(A)
@edit inv(A)
methods(println)

names(Threads)
"""https://discourse.julialang.org"""
