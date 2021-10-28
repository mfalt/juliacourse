using LinearAlgebra # For norm
using Plots # Documentation available at http://docs.juliaplots.org/latest/
gr(size=(800,500))

plot(randn(10), lab="legend", xlabel="x", title="My title", m=(:blue, :star, 5), l=(:dash,:black, 3, 0.4))
plot!(randn(10))

##
plot(randn(10), layout=(2,2), subplot=1)
plot!(randn(10), subplot=2, c=:red)
##

x = y = range(-3, 3, length = 100)
f(x, y) = sinc(norm([x, y]))
surface!(x, y, f, subplot=3)
contour!(x, y, f, subplot=4)

# ##
# using ControlSystems, Interact # add WebIO#master to get sliders working in Atom
# gr(show = false, size=(800,600), legend=false)
# GR.inline("svg")
# setPlotScale("log10")

# logspace(args...) = exp10.(LinRange(args...))
# Ω = logspace(-2,2,100)
# @manipulate for ζ = LinRange(0,1.5,30), ω = LinRange(0.001,2,20), g = LinRange(0,8,20)
#     G   = tf([g*ω^2], [1, 2ζ*ω, ω^2])
#     bp  = bodeplot(G, Ω, l=(3,), ylims=(0.01,20), plotphase=false)
#     pzp = pzmap(G, xlims = (-2,0), ylims = (-√(2),√(2)))
#     hline!([0], l=(:dash,:black)); vline!([0], l=(:dash,:black))
#     sp  = stepplot(G, 20, l=(3,), ylims=(0,8))
#     plot(bp,sp,pzp)#, layout = @layout([[a c{0.6h}] b d]))
# end

# ##


plotly()
plot(randn(10))
