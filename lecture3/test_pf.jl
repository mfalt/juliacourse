using Random
Random.seed!(0)

function pf( y, N, g, f, σw )
    T = length(y)
    xp[1,:] = 2*σw*randn(1,N) # Initialize particles at time t=1 using 2σ as initial std
    w = log.(1/N*ones(T,N)) # Initialize weights (weights stored in logarithmic form)
    w0 = w[1,:]
    w[1,:] = w[1,:] + g(y[1] .- 0.05xp[1,:].^2) # Measurement update for first sample instant
    w[1,:] = w[1,:] .- log(sum(exp.(w[1,:]))) # Normalize weights
    for t = 2:T # Main loop
        # Resample (done every 5th sample to not spend too much time here, not based on effective sample sized to avoid introducing additional randomness)
        if t%5 == 0
            j = resample(w[t-1,:])
            xpT = xp[t-1,j]
            wT = copy(w0)
        else # Resample not needed
            xpT = xp[t-1,:]
            wT = w[t-1,:]
        end

        # Time update (propagate particles forward in time and add some state noise)
        xp[t,:] = f(xpT,t-1) + σw*randn(N)

        # Measurement update (evaluate particles using measurement equation and measurement nose density)
        w[t,:] = wT + g(y[t] .- 0.05xp[t,:].^2)

        # Normalize weights (so that they sum to 1, offset is for numerical stability)
        offset = maximum(w[t,:])
        normConstant = log(sum(exp.(w[t,:] .- offset)))+offset
        w[t,:] .-= normConstant
    end

    we = exp.(w)
    xh = sum(xp.*we,dims=2) # Form a weighted average of the particles as estimate of true the state
    return xh
end

function resample(w)
    # Samples new particles based on their weights. If you find algorithmic optimizations to this routine, please tell me /Bagge)
    N = length(w)
    bins = [0; cumsum(exp.(w))]
    s = collect((rand()/N+0):1/N:bins[end])
    j = zeros(Int64,N)
    bo = 1
    for i = 1:N
        for b = bo:N
            if bins[b] <= s[i] < bins[b+1]
                j[i] = b
                bo = b
                break
            end
        end
    end
    return j
end


## =========================================================================
## =========================================================================
## Monte Carlo simulation of a particle filter
# This script tests the particle filter for various number of particles and different experiment durations
# using the model (standard benchmark model in nonlinear filtering community)
# x(t+1) = 0.5x + 25x/(1+x^2) + 8cos(1.2(t-1))
# y(t) = 0.05x^2
# The number of Monte-Carlo simulations per particles×timesteps configuration is adapted such that each experiment will take approximately the same amount of time
# this way different aspects of the code is tested.
# Your task is to optimize this entire code file such that this simulation takes as short time as possible
# I have tried my best to make the particle filter implementation as fast as possible from an algorithmic point of view.
# The implementation is however poor from a Julia/performance point of view.
# You are allowed to modify the code in whatever way you see fit, as long as the simulation is equivalent (under the assumption that the Float64 datatype has infinite precision, contact me for details)
## =========================================================================
## =========================================================================

# State and measurement noise std
σw0 = 2
σw = 1
σv = 1

# State transition and measurement equations
f(x,t) = 0.5x + 25x./(1 .+ x.^2) .+ 8cos(1.2*(t-1))
g(x) = -0.5 * (x./σv).^2 # log-Gaussian, normalization constant removed (free performance tips ;) )
rms(x) = sqrt(mean(x.^2)) # To calculate RMS error


# Main test loop
@time begin
    particle_count = [5, 30, 100, 300, 1000, 10_000]
    time_steps = [20, 200, 2000]
    RMSE = zeros(length(particle_count),length(time_steps)) # Store the RMS errors
    propagated_particles = 0 # To count the number of particle propagations
    for (Ti,T) in enumerate(time_steps)
        for (Ni, N) in enumerate(particle_count)
            global propagated_particles
            montecarlo_runs = maximum(particle_count)*maximum(time_steps) ÷ T ÷ N # Calculate how many Monte-Carlo runs to perform for the current T,N configuration
            RMS = 0
            for mc_iter = 1:montecarlo_runs
                global xp = zeros(T,N) # Define particle matrix
                x = zeros(T)
                y = zeros(T)
                y[1] = σv*randn()
                x[1] = σw*randn()
                for t = 1:T-1 # Simulate one realization of the model
                    x[t+1] = f(x[t],t) + σw*randn()
                    y[t+1] = 0.05x[t+1]^2  + σv*randn()
                end # t
                xh = pf( y, N, g, f, σw0 ) # Run the particle filter
                RMS += rms(x-xh) # Store the error
            end # MC
            RMSE[Ni,Ti] = RMS/montecarlo_runs # Store the mean of the error for this T,N configuration
            propagated_particles += montecarlo_runs*N*T # Add the number of performed particle propagations
            @show N
        end # N
        @show T
    end # T
    println("Propagated $propagated_particles particles")
    #

end # begin @time


using Plots
"""This function performs some elementary visualization of the results"""
function plotting(RMSE)
    time_steps = [20, 200, 2000]
    particle_count = [5, 30, 100, 300, 1000, 10_000]
    legend_strings = ["$(time_steps[i]) time steps" for i = 1:length(time_steps)]
    legend_strings = reshape(legend_strings,1,:)
    scatter(particle_count,RMSE, title="RMS errors vs Number of particles", xscale=:log10, lab=legend_strings)
end
plotting(RMSE)
