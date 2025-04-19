using Test
using TimingDebug: optimal_timing_debugging, F₁, F₂, F₃

include("tasks.jl")

@test optimal_timing_debugging(F₁, τ) ≈ [ 25e-3,  10e-3, 105e-3,  30e-3,  40e-3] atol=1e-5
@test optimal_timing_debugging(F₂, τ) ≈ [ 15e-3,  15e-3,  70e-3,  85e-3,  25e-3] atol=1e-5
@test optimal_timing_debugging(F₃, τ) ≈ [ 20e-3,  15e-3,  75e-3,  30e-3,  35e-3] atol=1e-5
