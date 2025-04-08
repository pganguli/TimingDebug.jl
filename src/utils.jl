using ControlSystemsBase: StateSpace, Continuous, c2d, delay
using LinearAlgebra: eigvals

"""
  closedLoopPoles(sys, K, p)

Compute the poles of the closed loop system `sys` with feedback gain `K`,
discretized with sampling period `h = p` and one-sample delay.
"""
function closedLoopPoles(sys::StateSpace{Continuous}, K::AbstractMatrix, p::Float64)
  sys_d = c2d(sys*delay(p), p)
  A_cl = sys_d.A - sys_d.B * K
  return eigvals(A_cl)
end

"""
  closedLoopPoles(sys, K, p)

Check if the closed loop system `sys` with feedback gain `K`,
discretized with sampling period `h = p` and one-sample delay,
is stable (poles lie within unit-circle) or not.
"""
function isStable(sys::StateSpace{Continuous}, K::AbstractMatrix, p::Float64)
  poles = closedLoopPoles(sys, K, p)
  return all(abs.(poles) .< 1)
end

