# Read more at https://docs.julialang.org/en/v1/manual/variables-and-scoping/

# In REPL, values are in Global scope
x = "Hello"

# "Functions", "for", "while", "try-catch-finally", "let"
# all introduce new scopes ("if" does not)

# Functions do not change variables in global scope
function f1()
    x = 3 # equivalent to "local x = 3"
    return x
end

f1()
x

function f2()
    return x
end

f2()

# If a function has assigns a variable, that variable is never refering to a global variable implicitly
function f3()
    if randn() > 0
        x = 3
    end
    return x
end

# Never says "Hello", x is always local
f3()

# Use global to explicitly use global variables
function f4()
    global x
    x = "Hello There"
end

f4()
x

# Variables are inherited from non-global scope!
function g1()
    function ginner()
        j = 2 # Try with and without "local"
        k = j + 1
    end
    j = 0
    k = 0
    return ginner(), j, k
end

g1()

# The scope is set by where the function or scope is introduced
function gouter()
    j = 2
    k = j + 1
end

function g2()
    j = 0
    k = 0
    return gouter(), j, k
end

g2()

# But the order does not matter!
even(n) = (n == 0) ? true : odd(n - 1)
even(10) # Odd is not defined at call time

odd(n) = (n == 0) ? false : even(n - 1)
# But here it is
@time even(10000)
