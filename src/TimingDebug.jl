module TimingDebug

include("types.jl")
export TaskSet

include("utils.jl")
export closed_loop_poles, dominant_pole, is_stable

include("objectives.jl")
export F₁, F₂, F₃

include("optimization.jl")
export optimal_timing_debugging

end # module TimingDebug
