using Test
using TimingDebug

include("tasks.jl")

@test optimal_timing_debugging(F₃, τ) ≈ [20e-3, 15e-3, 75e-3, 30e-3, 35e-3] atol=1e-5
