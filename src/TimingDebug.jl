module TimingDebug

struct Omega
  P::Vector{Float64}
  U::Float64
  F::Float64
end

function optimal_timing_debugging(A::Vector, B::Vector, C::Vector, K::Vector, e::Vector, p::Vector, ∆ₚ::Float64)
  Ω = Omega[]
  push!(Ω, Omega(p, sum((e[i] / p[i]) for i in eachindex(p)), 0.0))
  while any(Ωᵢ -> Ωᵢ.U > 1, Ω)
    Ω′ = Omega[]
    for Ωᵢ in Ω
      if Ωᵢ.U ≤ 1
        push!(Ω′, Ωᵢ)
      else
        for j in eachindex(p)
          Ω✶ = copy(Ωᵢ)
          Ω✶.P[j] += ∆ₚ
          if stable(Ω✶.P[j], A[j], B[j], C[j], K[j])
            Ω✶.U = sum((e[k] / Ω✶.P[k]) for k in 1:n)
            Ω✶.F = calculateF(Ω✶.P)
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
  i✶ = argmin(Ωⱼ -> Ωⱼ.F, Ω)
  return Ω[i✶].P
end

end # module TimingDebug
