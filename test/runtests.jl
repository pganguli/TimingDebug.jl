using Test
using TimingDebug

include("tasks.jl")

@test optimal_timing_debugging(F₃, τ) ≈ [0.020, 0.015, 0.075, 0.030, 0.035] atol=0.001
