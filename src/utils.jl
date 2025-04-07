using ControlSystemsBase: Continuous, c2d
using LinearAlgebra: eigvals

function closedLoopPoles(sys::Continuous, K::AbstractMatrix, p::Float64)
  sys_d = c2d(sys, p)
  A_cl = sys_d.A - sys_d.B * K
  return eigvals(A_cl)
end

function isStable(sys::Continuous, K::AbstractMatrix, p::Float64)
  poles = closedLoopPoles(sys, K, p)
  return all(abs.(poles) .< 1)
end

