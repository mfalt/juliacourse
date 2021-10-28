?
"""https://docs.julialang.org/en/v1/"""

using LinearAlgebra
using StaticArrays
apropos("svd")
A = @SMatrix randn(3,3)
@which A+A
@which svd(A)

ENV["EDITOR"] = "vim"

@edit inv(A)

@enter inv(A)

methods(println)

names(Threads)

"""https://discourse.julialang.org"""
