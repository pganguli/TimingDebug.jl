module TimingDebug

include("types.jl")
export TaskSet

include("utils.jl")
export closed_loop_system, dominant_pole, is_stable, period_ub

include("objectives.jl")
export F₁, F₂, F₃

include("optimization.jl")
export optimal_timing_debugging

end # module TimingDebug
