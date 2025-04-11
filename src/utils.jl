using ControlSystemsBase: StateSpace, Continuous, c2d, delay
using LinearAlgebra: eigvals

"""
  closed_loop_poles(sys, K, p)

Compute the poles of the closed loop system `sys` with feedback gain `K`,
discretized with sampling period `h = p` and one-sample delay.
"""
function closed_loop_poles(sys::StateSpace{Continuous}, K::AbstractMatrix, p::Float64)
    sys_d = c2d(sys * delay(p), p)
    A_cl = sys_d.A - sys_d.B * K
    eigvals(A_cl)
end

"""
  dominant_pole(sys, K, p)

Compute the dominant pole of the closed loop system `sys` with feedback gain `K`,
discretized with sampling period `h = p` and one-sample delay.
"""
dominant_pole(sys::StateSpace{Continuous}, K::AbstractMatrix, p::Float64) = dominant_pole(closed_loop_poles(sys, K, p))
function dominant_pole(poles::Vector{<:Complex})
    argmax(abs, poles)
end

"""
  is_stable(sys, K, p)

Check if the closed loop system `sys` with feedback gain `K`,
discretized with sampling period `h = p` and one-sample delay,
is stable (poles lie within unit-circle) or not.
"""
function is_stable(sys::StateSpace{Continuous}, K::AbstractMatrix, p::Float64)
    poles = closed_loop_poles(sys, K, p)
    all(abs.(poles) .< 1)
end

