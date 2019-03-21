# Read more: https://docs.julialang.org/en/v1/manual/types/

# Types
# Everything has a type
typeof(1.0)
typeof(2)
typeof("Hello")

supertype(Int64)
supertype(supertype(Int64))
supertype(supertype(supertype(Int64)))
supertype(supertype(supertype(supertype(Int64))))
supertype(supertype(supertype(supertype(supertype(Int64)))))

isa(1.0, Number)
isa(1.0, Integer)

subtypes(Real)
subtypes(AbstractFloat)
subtypes(Float64)

isconcretetype(Float64)
isconcretetype(Number)

subtypes(Complex)
isconcretetype(Complex)

# Creating a point
struct Point2D
    x::Float64
    y::Float64
end

a = Point2D(1.0, 2.0)
a.x
a.y
projectx(p::Point2D) = Point2D(p.x, 0.0)
projectx(a)

a = Point2D(1, 2)


# Parametric Types:
typeof(1 + 2im)
typeof(1.0 + 2.0im)

struct BetterPoint2D{T}
    x::T
    y::T
end

BetterPoint2D{Int64}(1, 2)
function projectx(p::BetterPoint2D{T}) where T <: Number
    BetterPoint2D{T}(p.x, zero(T))
end

BetterPoint2D{Float64}(1, 2)
BetterPoint2D(1.0, 2.0)
BetterPoint2D(1, 2.0)
a = BetterPoint2D(1, 2)

projectx(a)
@code_typed projectx(a)

typeof(a)
typeof(1.0 + 2im)

isconcretetype(BetterPoint2D)
isconcretetype(BetterPoint2D{Float64})

function add_x_parts(v1, v2)
    v1.x + v2.x
end

v1 = BetterPoint2D(1.0, 2.0)
v2 = BetterPoint2D(1, 2)

add_x_parts(v1, v2)
@code_warntype add_x_parts(v1, v2)

v3 = BetterPoint2D{Number}(1.0, 1)

add_x_parts(v1, v3)

@code_warntype add_x_parts(v1, v3)


@code_native add_x_parts(v1, v2)
