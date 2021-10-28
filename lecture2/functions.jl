# THIS IS A ROUGH COPY OF THE JUPYTER NOTEBOOK functions.ipynb
# TO RUN THE NOTEBOOK INSTEAD, DO:
using Pkg
Pkg.add("IJulia")
using IJulia
notebook()

# Functions in Julia: A quick intoduction
### For more details: https://docs.julialang.org/en/v1/manual/functions/
##### A function can be defined in two standard ways

##
function f(x,y)
    x + y
end

f(x,y) = x + y
##

##
f(1,2)
##

#Or as anonymous functions

##
(x,y) -> x + y
##


##
((x,y) -> x + y)(1,2)
##

### Optional and Keyword Arguments


##
opt1(x, y=2, z=2y) = x*y*z
@show opt1(1)
@show opt1(1, 2)
@show opt1(1, 2, 4);
##


##
function arraystring(a=[3,2,1]; space=' ', delim=',', brackets=('[',']'))
    s = ""
    s *= brackets[1]
    for i in 1:length(a)
        post = (i == length(a) ? "" : delim*space)
        s *= string(a[i])*post
    end
    s *= brackets[2]
    println(s)
end


arraystring()
arraystring(space="    ")
##

a = 1:5
##
arraystring(a)
arraystring(a, space="    ")
arraystring(a, delim=';', brackets=( '(', ')' ))
##


##

##

#### Arguments are passed by reference


##
# Change A at index inds to x
setvalue(A, x, inds...) = A[inds...] = x
v = randn(2,2)
setvalue(v, 1.0, 1, 2)
v
##

#### This looks a lot like A[inds...] = x
##### Some functions have special names:


#| Syntax      | Name         |
#|-------------|--------------|
#| `[A B C D]` | hcat         |
#| `[A;B;C;D]` | vcat         |
#| `[A B;C D]` | hvcat        |
#| `A'`        | adjoint      |
#| `A[i]`      | getindex     |
#| `A[i] = x`  | setindex!    |
#| `A.p`       | getproperty  |
#| `A.p = x`   | setproperty! |


### Functions are "first class citizens"
##### They can be passed around as any other variable


##
funsquare(fun, x, y) = fun(x, y)^2

funsquare(f, 1, 2)
##

#####  Let's define a function `funroot` that takes a function `f` and an arbitrary number or arguments `args...`


##
funroot(fun, args...) = sqrt(fun(args...))

@show funroot(sin, 2);
@show sqrt(sin(2))
##

#### We can keep going...


##
@show funsquare(f, 2, 3)
@show funroot(funsquare, f, 2, 3);
##

## Taking functions as arguments is built into many standard functions


##
using Statistics
a = randn(5) + im*randn(5)

@time mean(real, a)
##


##
filter(v -> real(v) > 0, a)
##


##
lt(x,y) = real(x)*imag(x) < real(y)*imag(y)
b = sort(a, lt=lt)
real(b) .* imag(b)
##


##
map(round, [1.2,3.5,1.7])
##

## Broadcasting: A fancy version of "elementwise"


##
a = randn(1000)
b = randn(1000);
##

#####  We are used to "elementwise" operators from "languages" such as MATLAB

#####  Like: `.+, .*, ./`


##
a .^ 2
a .+ 3
sum(a .+ 3), sum(a) + 3*length(a)
##

#####  And in those languages, we expect simple functions to be able to automatically work on vectors, for example:
#####  `sin, +, *, exp`
#### But in Julia, they are not defined for vector-scalar operations


##
sin(a)
##


##
a + 3
##

#### Instead, Julia uses explicit broadcasting


##
methods(+) # 163 methods, more on this in "Multiple dispatch" section
##

#####  So are there methods for `.+` too?


##
methods(.+)
##

#### The dot `.` is part of the syntax, and can be applied to any function!


##
sin.(a)
sum(f.(a,a)), 2sum(a)
##

#### And, when applied multiple times, the loops are automatically, and guaranteed to be fused!


##
fuse1(a,b) = sin.(cos.(2 .*(a .+ b)))
##


##
fuse1(a, b); # Run twice to not count compilation
@time fuse1(a,b)
sizeof(a)
##

#### Rougly equivalent to


##
function fuse2(a,b)
    y = similar(a)
    for i = 1:length(a)
        y[i] = sin(cos(2*(a[i] + b[i])))
    end
    return y
end
##


##
fuse2(a,b)
@time fuse2(a,b);
##
