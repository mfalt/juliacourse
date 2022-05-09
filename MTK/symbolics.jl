using Symbolics

@syms a b

ex = a + b

typeof(ex)

typeof((a+b)^2)

istree(a+b)

# TODO: walktree example

fun(x::Number) = x^2
fun(a)
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

