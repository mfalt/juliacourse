using Pkg
Pkg.activate(@__DIR__())

# Differential equations with inputs

## Using interpolations
using OrdinaryDiffEq, Plots, DataInterpolations, StaticArrays

function quadtank(h, p, t)
    u_int = p
    u = u_int(t)
    kc = 0.5
    k1, k2, g = 1.6, 1.6, 9.81
    A1 = A3 = A2 = A4 = 4.9
    a1, a3, a2, a4 = 0.03, 0.03, 0.03, 0.03
    γ1, γ2 = 0.1, 0.1

    ssqrt(x) = √(max(x, zero(x)) + 1e-3) # For numerical robustness at x = 0
    
    xd = SA[
        -a1/A1 * ssqrt(2g*h[1]) + a3/A1*ssqrt(2g*h[3]) +     γ1*k1/A1 * u[1]
        -a2/A2 * ssqrt(2g*h[2]) + a4/A2*ssqrt(2g*h[4]) +     γ2*k2/A2 * u[2]
        -a3/A3*ssqrt(2g*h[3])                          + (1-γ2)*k2/A3 * u[2]
        -a4/A4*ssqrt(2g*h[4])                          + (1-γ1)*k1/A4 * u[1]
    ]
end


Ts = 2
Tf = 100
t = 0:Ts:Tf
u = [rand(2) .< 0.26 for _ in 1:length(t)]
u_int = ConstantInterpolation(u, t)
h0 = [1,2,3,4]

prob = ODEProblem(quadtank, h0, (0, Tf), u_int)
sol = solve(prob, Tsit5(), tstops=Ts, dtmax=0.5)
plot(sol)







## trim the system =============================================================
using Optim, DiffEqCallbacks, ForwardDiff, ControlSystems

function quadtank_input(h, u, p, t)
    kc = 0.5
    k1, k2, g = 1.6, 1.6, 9.81
    A1 = A3 = A2 = A4 = 4.9
    a1, a3, a2, a4 = 0.03, 0.03, 0.03, 0.03
    γ1, γ2 = 0.1, 0.1

    ssqrt(x) = √(max(x, zero(x)) + 1e-3) # For numerical robustness at x = 0
    
    xd = SA[
        -a1/A1 * ssqrt(2g*h[1]) + a3/A1*ssqrt(2g*h[3]) +     γ1*k1/A1 * u[1]
        -a2/A2 * ssqrt(2g*h[2]) + a4/A2*ssqrt(2g*h[4]) +     γ2*k2/A2 * u[2]
        -a3/A3 * ssqrt(2g*h[3])                        + (1-γ2)*k2/A3 * u[2]
        -a4/A4 * ssqrt(2g*h[4])                        + (1-γ1)*k1/A4 * u[1]
    ]
end

hr0 = [10, 10, 6, 6]; # desired reference state

hr, ur = begin # control input at the operating opint
	optres = @views Optim.optimize(xu->sum(abs, quadtank_input(xu[1:4],xu[5:6],0,0)) + 0.0001sum(abs2, xu[1:4]-hr0), [hr0;.25;.25], BFGS(), Optim.Options(iterations=100, x_tol=1e-7))
	@info optres
	optres.minimizer[1:4], optres.minimizer[5:6]
end



##
const u_cache = zeros(2)
## ZoH feedback law ============================================================
Ts = 10
function quadtank(h, p, t)
    u = u_cache
    kc = 0.5
    k1, k2, g = 1.6, 1.6, 9.81
    A1 = A3 = A2 = A4 = 4.9
    a1, a3, a2, a4 = 0.03, 0.03, 0.03, 0.03
    γ1, γ2 = 0.1, 0.1

    ssqrt(x) = √(max(x, zero(x)) + 1e-3) # For numerical robustness at x = 0
    
    xd = SA[
        -a1/A1 * ssqrt(2g*h[1]) + a3/A1*ssqrt(2g*h[3]) +     γ1*k1/A1 * (u[1] + ur[1])
        -a2/A2 * ssqrt(2g*h[2]) + a4/A2*ssqrt(2g*h[4]) +     γ2*k2/A2 * (u[2] + ur[2])
        -a3/A3*ssqrt(2g*h[3])                          + (1-γ2)*k2/A3 * (u[2] + ur[2])
        -a4/A4*ssqrt(2g*h[4])                          + (1-γ1)*k1/A4 * (u[1] + ur[1])
    ]
end


function linearize(f, xi, ui)
    A = ForwardDiff.jacobian(x -> f(x, ui, 0, 0), xi)
    B = ForwardDiff.jacobian(u -> f(xi, u, 0, 0), ui)
    A, B
end

A,B = linearize(quadtank_input, hr, ur)
C = [I(2) zeros(2,2)]
sys = ss(A,B,C,0)
sysd = c2d(sys, Ts)
K = lqr(sysd, diagm([2,2,1,1]), Matrix(1I(2)))

function affect!(integrator)
    h = integrator.u
    mul!(u_cache, K, hr - h + 0.2randn(4))
end

cb = PeriodicCallback(affect!, Ts)

prob = ODEProblem(quadtank, h0, (0, 10Tf))
sol = solve(prob, Tsit5(), tstops=Ts, dtmax=0.5, callback=cb)
plot(sol); hline!(hr', l=(:dash, ), c=(1:4)', lab="hᵣ")