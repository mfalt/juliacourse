using Pkg
Pkg.activate(@__DIR__())
##

using Symbolics

@syms a b

ex = a + b

typeof(ex)

typeof((a+b)^2)

istree(a+b)

# TODO: walktree example

fun(x::Number) = x^2
try
    fun(a)
catch err
    display(err)
end
a isa Number


@variables a b

a isa Number
fun(a)


typeof(a+b)
typeof((a+b)^2)

typeof(a.val)

Symbolics.unwrap(a)
Symbolics.unwrap(a) |> typeof


## Equations

eq = b ~ 2a

typeof(eq)

eq.lhs

typeof(b)
typeof(eq.lhs)


eq.lhs == b

isequal(eq.lhs, b)

@parameters k [tunable=true, bounds=(0, Inf)]

@named pid = LimPID(k = 2, Ti = 3, Td = 4)