using ControlSystemsBase: StateSpace, Continuous

struct TaskSet
    sys::StateSpace{Continuous} # State-Space System
    ρ::Vector{ComplexF64}       # Original poles
    K::AbstractMatrix           # Feedback gain
    e::Float64                  # Execution time
    p::Float64                  # Period
end
