# Example of outline for lab using the Beam Process

P    = LabProcesses.Beam(bias = 0.)  # Replace for BeamSimulator() to run simulations
h    = sampletime(P)
prbs     = PRBSGenerator()

function prbs_experiment(P, prbs; amplitude = 1, duration = 10)
    y = zeros(length(0:h:duration))
    u = zeros(length(0:h:duration))
    LabProcesses.initialize(P)
    for (i,t) = enumerate(0:h:duration)
        @periodically h begin
            y[i]  = measure(P)
            u[i]  = amplitude*(prbs()-0.5)
            control(P, u[i])
        end
    end
    LabProcesses.finalize(P)
    y,u
end

y, u = prbs_experiment(P, prbs)
