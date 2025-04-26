abstract type PeriodAdjustmentAlgorithm end

"""
    adjust_periods(objective::Function, T::Vector{TaskSet}; alg::PeriodAdjustmentAlgorithm=LocalSearch, kwargs...)

Debug the timing of the task set `T` by suggesting adjusted periods that render `T`
schedulable while minimizing the given `objective` function.

`alg` is an object of some `PeriodAdjustmentAlgorithm` type, specifying the optimization
approach to use.  Additional keyword arguments are optional for each
`PeriodAdjustmentAlgorithm`.

See also the (presently only) algorithm, [`LocalSearch`](@ref).
"""
function adjust_periods(objective::Function, T::Vector{TaskSet}; alg::PeriodAdjustmentAlgorithm=LocalSearch, kwargs...)
    _adjust_periods(objective, T, alg; kwargs...)
end


struct LocalSearchAlg <: PeriodAdjustmentAlgorithm end

"""
    LocalSearch

Use the local search heuristic for period adjustment, based on Roy et al., "Timing
Debugging for Cyber-Physical Systems."
DOI: [10.23919/DATE51398.2021.9474012](https://doi.org/10.23919/DATE51398.2021.9474012)

The `LocalSearch` algorithm takes discrete samples of the period space in a grid of
step size specified by the keyword argument `step` (defaulting to `5e-3`).
"""
const LocalSearch = LocalSearchAlg()

mutable struct Omega
  P::Vector{Float64} # Periods
  U::Float64         # Utilizations
  F::Float64         # Objective values
end

function _adjust_periods(objective::Function, T::Vector{TaskSet}, ::LocalSearchAlg; step::Float64=5e-3)
    Ω = Omega[]
    push!(Ω, Omega([τᵢ.p for τᵢ in T], sum((τᵢ.e / τᵢ.p) for τᵢ in T), 0.0))
    while any(Ωᵢ -> Ωᵢ.U > 1, Ω)
        Ω′ = Omega[]
        for Ωᵢ in Ω
            if Ωᵢ.U ≤ 1
                push!(Ω′, Ωᵢ)
            else
                for j in eachindex(T)
                    Ω✶ = deepcopy(Ωᵢ)
                    Ω✶.P[j] += step
                    if is_stable(T[j].sys, T[j].K, Ω✶.P[j]) && Ω✶.P[j] ≤ period_ub(T[j].sys, T[j].K, T[j].p)
                        Ω✶.U = sum((T[k].e / Ω✶.P[k]) for k in eachindex(T))
                        Ω✶.F = objective(T, Ω✶.P)
                        push!(Ω′, Ω✶)
                    end
                end
            end
        end
        Ω = Omega[]
        for i in eachindex(Ω′)
            if !any(Ω′ⱼ -> Ω′ⱼ.U ≤ Ω′[i].U &&
                           Ω′ⱼ.F ≤ Ω′[i].F &&
                           Ω′ⱼ ≠ Ω′[i], Ω′)
                push!(Ω, Ω′[i])
            end
        end
    end
    argmin(Ωⱼ -> Ωⱼ.F, Ω).P
end


struct ExhaustiveSearchAlg <: PeriodAdjustmentAlgorithm end

"""
    ExhaustiveSearch

Use an exhaustive search to optimally adjust periods over the assignments specified
by an iterator `itr`.
"""
const ExhaustiveSearch = ExhaustiveSearchAlg()

function _adjust_periods(objective::Function, T::Vector{TaskSet}, ::ExhaustiveSearchAlg; itr)
    P = argmin(itr) do P
        # Check that all systems are stable with periods P
        all(splat((t, p) -> is_stable(t.sys, t.K, p)), zip(T, P)) || return Inf
        # Check that the task system is schedulable with periods P
        sum(splat(/), Iterators.zip((t.e for t in T), P)) ≤ 1 || return Inf
        objective(T, P)
    end
    # Double check that P is not spurious before returning
    all(splat((t, p) -> is_stable(t.sys, t.K, p)), zip(T, P)) || throw(ErrorException("No safe periods found"))
    sum(splat(/), Iterators.zip((t.e for t in T), P)) ≤ 1 || throw(ErrorException("No safe periods found"))
    P
end
