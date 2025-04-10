using ControlSystemsBase: StateSpace, Continuous

"""
  F₁(sys, K, ρ, p′)

Compute the objective function `F₁` for system `sys` with feedback gain `K`.
Original closed loop poles are `ρ` and new periods are `p′`.
"""
function F₁(sys::StateSpace{Continuous}, K::AbstractMatrix, ρ::Vector{Float64}, p′::Vector{Float64})
  ρ′ = [closedLoopPoles(sys, K, p′ᵢ) for p′ᵢ in p′]
  return sum(abs(abs(ρ[end]) - abs(ρ′ᵢ[end])) for ρ′ᵢ in ρ′)
end

"""
  F₂(sys, K, ρ, p′)

Compute the objective function `F₂` for system `sys` with feedback gain `K`.
Original closed loop poles are `ρ` and new periods are `p′`.
"""
function F₂(sys::StateSpace{Continuous}, K::AbstractMatrix, ρ::Vector{Float64}, p′::Vector{Float64})
  ρ′ = [closedLoopPoles(sys, K, p′ᵢ) for p′ᵢ in p′]
  return sum(abs(ρ - ρ′ᵢ) / length(ρ) for ρ′ᵢ in ρ′)
end

"""
  F₃(sys, K, ρ, p′)

Compute the objective function `F₃` for system `sys` with feedback gain `K`.
Original closed loop poles are `ρ` and new periods are `p′`.
"""
function F₃(sys::StateSpace{Continuous}, K::AbstractMatrix, ρ::Vector{Float64}, p′::Vector{Float64})
  ρ′ = [closedLoopPoles(sys, K, p′ᵢ) for p′ᵢ in p′]
  return sum((abs(abs(ρ[end]) - abs(ρ′ᵢ))*abs(ρ[end]))^2 for ρ′ᵢ in ρ′)
end
