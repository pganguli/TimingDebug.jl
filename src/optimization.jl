mutable struct Omega
  P::Vector{Float64} # Periods
  U::Float64         # Utilizations
  F::Float64         # Objective values
end

"Algorithm 1: Optimal Timing Debugging"
function optimal_timing_debugging(objective::Function, τ::Vector{TaskSet}, ∆ₚ::Float64=5e-3)
    Ω = Omega[]
    push!(Ω, Omega([τᵢ.p for τᵢ in τ], sum((τᵢ.e / τᵢ.p) for τᵢ in τ), 0.0))
    while any(Ωᵢ -> Ωᵢ.U > 1, Ω)
        Ω′ = Omega[]
        for Ωᵢ in Ω
            if Ωᵢ.U ≤ 1
                push!(Ω′, Ωᵢ)
            else
                for j in eachindex(τ)
                    Ω✶ = deepcopy(Ωᵢ)
                    Ω✶.P[j] += ∆ₚ
                    if is_stable(τ[j].sys, τ[j].K, Ω✶.P[j])
                        Ω✶.U = sum((τ[k].e / Ω✶.P[k]) for k in eachindex(τ))
                        Ω✶.F = objective(τ, Ω✶.P)
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
