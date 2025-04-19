using ControlSystemsBase: Continuous, Discrete, StateSpace, c2d, damp, delay, poles, ss
using LinearAlgebra: eigvals, π

"""
  closed_loop_system(sys, K, p)

Construct the closed loop system of `sys` with feedback gain `K`,
discretized with sampling period `h = p` and one-sample delay.
"""
function closed_loop_system(sys::StateSpace{Continuous}, K::AbstractMatrix, p::Float64)
    sys_d = c2d(sys * delay(p), p)
    ss(sys_d.A - sys_d.B * K, sys_d.B, sys_d.C, sys_d.D, p)
end

"""
  dominant_pole(sys, K, p)

Find the dominant pole of the closed loop system `sys` with feedback gain `K`,
discretized with sampling period `h = p` and one-sample delay.
"""
dominant_pole(sys::StateSpace{Continuous}, K::AbstractMatrix, p::Float64) = dominant_pole(poles(closed_loop_system(sys, K, p)))
"""
  dominant_pole(poles)

Find the dominant pole out of poles `ps`.
"""
dominant_pole(ps::Vector{<:Complex}) = argmax(abs, ps)

"""
  is_stable(sys, K, p)

Check if the closed loop system `sys` with feedback gain `K`,
discretized with sampling period `h = p` and one-sample delay,
is stable (poles lie within unit-circle) or not.
"""
is_stable(sys::StateSpace{Continuous}, K::AbstractMatrix, p::Float64) = all(abs.(poles(closed_loop_system(sys, K, p))) .< 1)

"""
  nyquist_freq(sys, K, p)

Compute the Nyquist frequency (2 * Natrual frequency) of the poles of the
closed loop system `sys` with feedback gain `K`, discretized with
sampling period `h = p` and one-sample delay, in Hz.
"""
nyquist_freq(sys::StateSpace{Continuous}, K::AbstractMatrix, p::Float64) = nyquist_freq(closed_loop_system(sys, K, p))
"""
  nyquist_freq(poles)

Compute the Nyquist frequency (2 * Natrual frequency) of the poles of the
closed loop system `sys_cl` in Hz.
"""
function nyquist_freq(sys_cl::StateSpace{Discrete{Float64}, Float64})
    Wn, _, _ = damp(sys_cl)
    Wn ./= (2 * π)
    return 2 .* Wn
end

"""
  period_ub(sys, K, p)

Compute the Nyquist period upper bound for the closed loop system `sys`
with feedback gain `K`, discretized with sampling period `h = p`
and one-sample delay.
"""
function period_ub(sys::StateSpace{Continuous}, K::AbstractMatrix, p::Float64)
    W = nyquist_freq(sys, K, p)
    maximum(W)^-1
end
