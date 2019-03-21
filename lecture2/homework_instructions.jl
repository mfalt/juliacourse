# These instructions might be long, it it contains many examples and some hints.
# Although the instructions might seem complicated, you don't need any complicated code,
# it is possible to solve part 1 in 20 quite simple lines of code
# If you can run the code below, you have probably done verything needed

##################### Specification part 1
# Define your own type
# TrackingFloat <: AbstractFloat
# that keeps track of the largest value it has interacted with.
# This can be used as as rough way of tracking how numerically problematic an algorithm is.
#
# It should keep two fields, one Float64 that acts as normal float under all the
# specified operations below. And one field that keeps track of the largest number
# (in absolute value) that has been involved in generating this TrackingFloat.
#
# Example: v = TrackingFloat(1) + TrackingFloat(3) should generate a
# TrackingFloat v, with value 4, that remembers that 3 is the largest value
# used to generate it so far, we write this as
# v = TrackingFloat(4, 3), i.e value 4, memory 3
# Some examples:
# v + TrackingFloat(2), results in TrackingFloat(6, 4)
# v + TrackingFloat(5), results in TrackingFloat(9, 5)
# v + TrackingFloat(-5), results in TrackingFloat(-1, 5)
# v - TrackingFloat(5), results in TrackingFloat(-1, 5)
# TrackingFloat(4, 5) - TrackingFloat(1, 3), results in TrackingFloat(3, 5)

##################### Specification Part 1:
# It should work with operations such as +, -, *, /
# For +, -, * the output should be as described above.
# However for /, we want to be wary of dividing by small numbers instead, so
# TrackingFloat(3.0)/TrackingFloat(0.1) should result in TrackingFloat(30, 10)
# i.e as if we had the equations 3.0*(1/0.1) instead.

# Define constructor that works as:
# TrackingFloat(1.0), generating TrackingFloat(1.0, 0.0)

# Define simple getters `getval` and `getmax` that gets the corresponding fileds.

# Note:
# Don't forget to `import Base: +, *, -, /`
# before trying to add methods to these functions


##################### Specification Part 2:
# We now want to be able to do more complicated calculations,
# such as cholesky and qr factorization

# Start by defining a `promote_rule` so that you can write for example
# TrackingFloat(1.0, 0) + 1.0
# You can look at the documentation on promote_rule to figure out how to do it.
# One example of promote_rule from Base is
# promote_rule(::Type{Bool}, ::Type{T}) where {T<:Number} = T
# Which says that whenever you want to make a Bool and a Number to be of the same type,
# they should become the type of that Number.

# You will also need to define the following functions:
# sqrt, -, <

# Lastly, if you have problems that the qr or cholesky functions fail in
# promoting properly, try to define the function below to make sure julia is not trying
# to put a TrackingFloat inside another TrackingFloat, i.e.
# TrackingFloat(v::TrackingFloat) = v

#################### Part 1 simple operations
# Test your type
v = TrackingFloat(1.0) + TrackingFloat(3.0) # We expect TrackingFloat(4, 3)
v*v                                         # We expect TrackingFloat(16, 4)
v - v                                       # We expect TrackingFloat(0, 4)
v/TrackingFloat(0.1, 0)                     # We expect TrackingFloat(40, 10)

# Try working with matrices
A = randn(10,10)
b = randn(10)

# Convert using broadcast
At = TrackingFloat.(A)
bt = TrackingFloat.(b)

# Try some operations
v = A*b
vt = At*bt
# Did we calculate correctly? Using getval to convert back to float
maximum(abs, v - getval.(vt))

# Get the max fields using our function getmax
getmax.(vt)



#################### Part 2: Lets try something more complicated
using LinearAlgebra

# Is promotion working?
TrackingFloat(1.0, 0) + 2.0 # Expect TrackingFloat(3, 2)

# Create Positive definite matrix
AA = A*A'
# Convert to TrackingFloat matrix
AAt = TrackingFloat.(AA)

sol1 = AAt\bt # Uses qr
# Did we get the correct answer?
maximum(abs, getval.(sol1) - AA\b)

# Try cholesky factorization
F = cholesky(AAt)

sol2 = F\bt
maximum(abs, getval.(sol2) - AA\b)

# Which method was able to work with smallest elements?
maximum(getmax.(sol1))
maximum(getmax.(sol2))


####### Optional part
# This can be a bit trickier, so it is completely optional:
# Make TrackingFloat parametric, e.g
# TrackingFloat{T<:Real}, so that
# TrackingFloat{Int64} + TrackingFloat{Int64} isa TrackingFloat{Int64}
# Can you make the following work too?
# TrackingFloat{Int64} + TrackingFloat{Float64} isa TrackingFloat{Float64}
