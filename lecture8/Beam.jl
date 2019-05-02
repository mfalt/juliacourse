# Copy from parts of code for defining the Beam model in LabProcesses

struct Beam <: PhysicalProcess
    h::Float64
    bias::Float64
    stream::LabStream
    measure::AnalogInput10V
    control::AnalogOutput10V
end
function Beam(;
    h::Float64               = 0.01,
    bias::Float64            = 0.,
    stream::LabStream        = ComediStream(),
    measure::AnalogInput10V  = AnalogInput10V(0),
    control::AnalogOutput10V = AnalogOutput10V(1))
    p = Beam(Float64(h),Float64(bias),stream,measure,control)
    init_devices!(p.stream, p.measure, p.control)
    p
end

include("define_beam_system.jl")
const beam_system, nice_beam_controller = define_beam_system()
# nice_beam_controller gives ϕₘ=56°, Aₘ=4, Mₛ = 1.6. Don't forget to discretize it before use
struct BeamSimulator <: SimulatedProcess
    h::Float64
    s::SysFilter
    BeamSimulator(;h::Real = 0.01, bias=0) = new(Float64(h), SysFilter(beam_system, h))
end


const AbstractBeam              = Union{Beam, BeamSimulator}


num_outputs(p::AbstractBeam) = 1
num_inputs(p::AbstractBeam)  = 1
outputrange(p::AbstractBeam) = [(-10,10)]
inputrange(p::AbstractBeam)  = [(-10,10)]
isstable(p::AbstractBeam)    = true
isasstable(p::AbstractBeam)  = false
sampletime(p::AbstractBeam)  = p.h
bias(p::Beam)                = p.bias
bias(p::BeamSimulator)       = 0


function control(p::AbstractBeam, u::AbstractArray)
    length(u) == 1 || error("Process $(typeof(p)) only accepts one control signal, tried to send u=$u.")
    control(p,u[1])
end

control(p::Beam, u::Number)             = send(p.control,u)
control(p::BeamSimulator, u::Number)    = p.s(u)

measure(p::Beam)                        = read(p.measure)
measure(p::BeamSimulator)               = dot(p.s.sys.C,p.s.state)

initialize(p::Beam)                     = nothing
finalize(p::Beam)                       = foreach(close, p.stream.devices)
initialize(p::BeamSimulator)            = p.s.state .*= 0
finalize(p::BeamSimulator)              = nothing
