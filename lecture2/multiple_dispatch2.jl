# Examample for multiple dispatch
# Idea (and code) stolen from talk by Stefan Karpinski, see https://youtu.be/S6Wx_J4Mk7U
using LinearAlgebra

function innersum(A, vs)
    t = zero(eltype(A))
    for v in vs
        t += inner(v, A, v)
    end
    return t
end

inner(v, A, w) = dot(v, A*w)

A = rand(3,3)
vs = [rand(3) for _ = 1:10]

innersum(A, vs)
# Tip for writing generic code: Don't specify types

# Lets try using some other types!

using StaticArrays

A = @SMatrix rand(3,3)

vs = [@SVector rand(3) for _ in 1:10]

innersum(A, vs)

# Now we define our own type!



# One-hot vector
# v = (0, ..., 0, 1, 0, .., 0)

import Base: size, getindex, *

struct OneHotVector <: AbstractVector{Bool}
    len::Int
    ind::Int
end

size(v::OneHotVector) = (v.len,)

getindex(v::OneHotVector, i::Integer) = i == v.ind

vs = [OneHotVector(3, rand(1:3)) for _ in 1:10]

vs[1]

dump(vs[1])

# So does it work?

innersum(A, vs)


# Lets try to be more efficent!
*(A::AbstractMatrix, v::OneHotVector) where T = A[:, v.ind]
# This now works
randn(3,3)*vs[1]
# But we get ambiguity here:
A*vs[1]

#Lets fix that
*(A::StaticArray{Tuple{N,M},T,2}, v::OneHotVector) where {N,M,T} = A[:, v.ind]
A*vs[1] #Should work here!

innersum(A, vs)
@time innersum(A, vs)


# We can do even better!

inner(v::OneHotVector, A::AbstractMatrix, w::OneHotVector) = A[v.ind, w.ind]

@time innersum(A, vs)

# Lets try something bigger!
A  = randn(1000,1000)


vs_one_hot = [OneHotVector(1000, rand(1:1000)) for _ in 1:100]

# Lets make a vector of standard Vectors to compare to 
vs = Vector.(vs_one_hot)

using BenchmarkTools

@btime innersum(A, vs)

@btime innersum(A, vs_one_hot)
