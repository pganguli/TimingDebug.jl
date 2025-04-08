using ControlSystemsBase: StateSpace, Continuous

mutable struct Omega
  P::Vector{Float64} # Periods
  U::Float64         # Utilizations
  F::Float64         # Objective values
end

struct TaskSet
  sys::StateSpace{Continuous} # State-Space System
  ρ::Vector{Float64}          # Original poles
  K::AbstractMatrix           # Feedback gain
  e::Float64                  # Execution time
  p::Float64                  # Period
end
