using ControlSystemsBase: Continuous

function F₁(sys::Continuous, K::AbstractMatrix, p::Float64, p′::Float64)
  poles = closedLoopPoles(sys, K, p)
  poles′ = closedLoopPoles(sys, K, p′)
  return abs(abs(poles[1]) - abs(poles′[1]))
end

function F₂(sys::Continuous, K::AbstractMatrix, p::Float64, p′::Float64)
  poles = closedLoopPoles(sys, K, p)
  poles′ = closedLoopPoles(sys, K, p′)
  return abs(abs(poles[1]) - abs(poles′[1]))
end

function F₃(sys::Continuous, K::AbstractMatrix, p::Float64, p′::Float64)
  poles = closedLoopPoles(sys, K, p)
  poles′ = closedLoopPoles(sys, K, p′)
  return abs(abs(poles[1]) - abs(poles′[1]))
end
