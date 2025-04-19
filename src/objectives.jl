using ControlSystemsBase: StateSpace, Continuous

"""
  F₁(τ, p′)

Compute the objective function `F₁` for system `sys` with feedback gain `K`.
Original closed loop poles are `ρ` and new periods are `p′`.
"""
function F₁(τ::Vector{TaskSet}, p′::Vector{Float64})
    sum(
        begin
            ρᵢ₁ = dominant_pole(τ[i].ρ)
            ρ′ᵢ₁ = dominant_pole(τ[i].sys, τ[i].K, p′[i])
            abs(abs(ρᵢ₁) - abs(ρ′ᵢ₁))
        end
        for i in eachindex(τ)
    )
end

"""
  F₂(τ, p′)

Compute the objective function `F₂` for system `sys` with feedback gain `K`.
Original closed loop poles are `ρ` and new periods are `p′`.
"""
function F₂(τ::Vector{TaskSet}, p′::Vector{Float64})
    sum(
        begin
            ρᵢ = τ[i].ρ
            ρ′ᵢ = poles(closed_loop_system(τ[i].sys, τ[i].K, p′[i]))
            sum(abs.(ρᵢ - ρ′ᵢ)) / length(ρᵢ)
        end
        for i in eachindex(τ)
    )
end

"""
  F₃(τ, p′)

Compute the objective function `F₃` for system `sys` with feedback gain `K`.
Original closed loop poles are `ρ` and new periods are `p′`.
"""
function F₃(τ::Vector{TaskSet}, p′::Vector{Float64})
    sum(
        begin
            ρᵢ₁ = dominant_pole(τ[i].ρ)
            ρ′ᵢ₁ = dominant_pole(τ[i].sys, τ[i].K, p′[i])
            D✶ᵢ = abs(abs(ρᵢ₁) - abs(ρ′ᵢ₁))
            (D✶ᵢ * abs(ρᵢ₁)) ^ 2
        end
        for i in eachindex(τ)
    )
end
