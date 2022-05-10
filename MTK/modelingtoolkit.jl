using ModelingToolkit, OrdinaryDiffEq, Plots
@parameters t
Dₜ = Differential(t)

@parameters u(t) [input=true]  # Indicate that this is a controlled input
@parameters y(t) [output=true] # Indicate that this is a measured output


## Build a component library ===================================================

function Mass(; name, m = 1.0, p = 0, v = 0)
    ps = @parameters m=m
    sts = @variables pos(t)=p vel(t)=v
    eqs = Dₜ(pos) ~ vel
    ODESystem(eqs, t, [pos, vel], ps; name)
end

function Spring(; name, k = 1e4)
    ps = @parameters k=k
    @variables x(t)=0 # Spring deflection
    ODESystem(Equation[], t, [x], ps; name)
end

function Damper(; name, c = 10)
    ps = @parameters c=c
    @variables vel(t)=0
    ODESystem(Equation[], t, [vel], ps; name)
end

function SpringDamper(; name, k=false, c=false)
    spring = Spring(; name=:spring, k)
    damper = Damper(; name=:damper, c)
    compose(
        ODESystem(Equation[], t; name),
        spring, damper)
end


connect_sd(sd, m1, m2) = [sd.spring.x ~ m1.pos - m2.pos, sd.damper.vel ~ m1.vel - m2.vel]
sd_force(sd) = -sd.spring.k * sd.spring.x - sd.damper.c * sd.damper.vel


## Instantiate components ======================================================

# Parameters
m1 = 1
m2 = 1
k = 1000 # Spring stiffness
c = 10   # Damping coefficient

@named mass1 = Mass(; m=m1)
@named mass2 = Mass(; m=m2)
@named sd = SpringDamper(; k, c)

function Model(u, d=0)
    eqs = [
        connect_sd(sd, mass1, mass2)
        Dₜ(mass1.vel) ~ ( sd_force(sd) + u) / mass1.m
        Dₜ(mass2.vel) ~ (-sd_force(sd) + d) / mass2.m
    ]
    @named _model = ODESystem(eqs, t; observed=[y~mass2.pos])
    @named model = compose(_model, mass1, mass2, sd)
end

## Solve =======================================================================

model = Model(sin(30t))
sys = structural_simplify(model)
prob = ODEProblem(sys, Pair[], (0., 1.))
sol = solve(prob, Rodas5())
plot(sol)


## Close the loop ==============================================================

using ModelingToolkitStandardLibrary.Blocks: LimPID, FirstOrder
@variables u(t)=0 [input=true]
model = Model(u)
@named pid = LimPID(k=400, Ti=1, Td=1)
@named filt = FirstOrder(T=0.1)
connections = [
    filt.u  ~ t >= 1 # a reference step at t = 1
    pid.reference.u ~ filt.y
    pid.measurement.u ~ model.mass1.pos
    pid.ctr_output.u  ~ model.u
]
closed_loop = structural_simplify(ODESystem(connections, t, systems=[model, pid, filt], name=:closed_loop))
prob = ODEProblem(closed_loop, Pair[], (0., 4.))
sol = solve(prob, Rodas5())#, dtmin=1e-15, force_dtmin=true);
plot(plot(sol, vars=[filt.y, model.mass1.pos, model.mass2.pos]), plot(sol, vars=[pid.ctr_output.u], title="Control signal"), legend=:bottomright)






## Using the standard library ==================================================
using ModelingToolkitStandardLibrary.Mechanical.Rotational

@named inertia1 = Inertia(; J=m1)
@named inertia2 = Inertia(; J=m2)

@named spring = Rotational.Spring(; c=k)
@named damper = Rotational.Damper(; d=c)

@named torque = Torque()


function StdlibModel(u, d=0)
    eqs = [
        torque.tau.u ~ u
        connect(torque.flange, inertia1.flange_a)
        connect(inertia1.flange_b, spring.flange_a, damper.flange_a)
        connect(inertia2.flange_a, spring.flange_b, damper.flange_b)
    ]
    @named model = ODESystem(eqs, t; systems=[torque, inertia1, inertia2, spring, damper])
end

model = StdlibModel(sin(30t))
sys = structural_simplify(model)
prob = ODEProblem(sys, Pair[], (0., 1.))
sol = solve(prob, Rodas5())
plot(sol)

## Close the loop with connect =================================================

using ModelingToolkitStandardLibrary.Blocks: LimPID, FirstOrder
using ModelingToolkitStandardLibrary.Mechanical.Rotational: AngleSensor
@variables u(t)=0 [input=true]
model = StdlibModel(u)
@named pid = LimPID(k=400, Ti=1, Td=1)
@named filt = FirstOrder(T=0.1)
@named sensor = AngleSensor()

connections = [
    filt.u ~ t >= 1 # a reference step at t = 1
    connect(filt.output, pid.reference)
    connect(pid.ctr_output, model.torque.tau)
    connect(model.inertia1.flange_b, sensor.flange)
    connect(pid.measurement, sensor.phi)
]
closed_loop = structural_simplify(ODESystem(connections, t, systems=[model, pid, filt, sensor], name=:closed_loop))
prob = ODEProblem(closed_loop, Pair[], (0., 4.))
sol = solve(prob, Rodas5())#, dtmin=1e-15, force_dtmin=true);
plot(plot(sol, vars=[filt.y, model.inertia1.phi, model.inertia2.phi]), plot(sol, vars=[pid.ctr_output.u], title="Control signal"), legend=:bottomright)

