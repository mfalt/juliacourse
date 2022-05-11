using Pkg
Pkg.activate(@__DIR__())
##

using Symbolics

@syms a b

ex = a + b
typeof(ex)

eq = a ~ b
typeof(eq)

typeof((a+b)^2)


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

typeof(a)

typeof(a+b)
typeof((a+b)^2)

typeof(a.val)

Symbolics.unwrap(a)
Symbolics.unwrap(a) |> typeof

ex = sin(a)^2 + cos(a)^2
Symbolics.simplify(ex)


## Equations 

eq = b ~ 2a

typeof(eq)

eq.lhs
eq.rhs

typeof(b)
typeof(eq.lhs)


eq.lhs == b

if eq.lhs == b
    "🐶, 🐱, 🍨"
else
    "🌽, 🧀, 🧴⟹💵, 🧅"
end

isequal(eq.lhs, b)

if isequal(eq.lhs, b)
    "🐶, 🐱, 🍨"
else
    "🌽, 🧀, 🧴⟹💵, 🧅"
end
