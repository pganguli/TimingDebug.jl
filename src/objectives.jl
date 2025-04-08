using ControlSystemsBase: StateSpace, Continuous

function F₁(sys::StateSpace{Continuous}, K::AbstractMatrix, p::Vector{Float64}, p′::Vector{Float64})
  poles = [closedLoopPoles(sys, K, pᵢ) for pᵢ in p]
  poles′ = [closedLoopPoles(sys, K, p′ᵢ) for p′ᵢ in p′]
  return sum(abs(abs(poles[i][1]) - abs(poles′[i][1])) for i in eachindex(poles))
end

function F₂(sys::StateSpace{Continuous}, K::AbstractMatrix, p::Vector{Float64}, p′::Vector{Float64})
  poles = [closedLoopPoles(sys, K, pᵢ) for pᵢ in p]
  poles′ = [closedLoopPoles(sys, K, p′ᵢ) for p′ᵢ in p′]
  return sum(abs(poles - poles′) / length(poles) for i in eachindex(poles))
end

function F₃(sys::StateSpace{Continuous}, K::AbstractMatrix, p::Vector{Float64}, p′::Vector{Float64})
  poles = [closedLoopPoles(sys, K, pᵢ) for pᵢ in p]
  poles′ = [closedLoopPoles(sys, K, p′ᵢ) for p′ᵢ in p′]
  return sum((abs(abs(poles[i][1]) - abs(poles′[i][1]))*abs(poles[i][1]))^2 for i in eachindex(poles))
end
