using ControlSystemsBase: StateSpace, Continuous

mutable struct Omega
  P::Vector{Float64}
  U::Float64
  F::Float64
end

struct Task
  sys::StateSpace{Continuous}
  K::AbstractMatrix
  e::Float64
  p::Float64
end
