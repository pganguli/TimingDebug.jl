"""
Table 1: Case Study Specification
"""

using ControlSystemsBase: c2d, place, ss, delay

sys₁ = let
    A = [-10 1; -0.02 -2]
    B = [0 2]'
    C = [1 0]
    D = 0
    ss(A, B, C, D)
end
e₁ = 5e-3
p₁ = 15e-3
ρ₁ = [0.5, 0.5, 0.5]
K₁ = place(c2d(sys₁ * delay(p₁), p₁), ρ₁)

sys₂ = let
    A = [-0.2 0.67; -10 -100]
    B = [0 37000]'
    C = [1 0]
    D = 0
    ss(A, B, C, D)
end
e₂ = 3e-3
p₂ = 10e-3
ρ₂ = [0.4, 0.4, 0.4]
K₂ = place(c2d(sys₂ * delay(p₂), p₂), ρ₂)

sys₃ = let
    A = [-10 1; -0.2 -15]
    B = [0 20]'
    C = [1 0]
    D = 0
    ss(A, B, C, D)
end
e₃ = 6e-3
p₃ = 20e-3
ρ₃ = [0.7, 0.7, 0.7]
K₃ = place(c2d(sys₃ * delay(p₃), p₃), ρ₃)

sys₄ = let
    A = [0 1 0; 0 -1.0865 8.4872e3; 0 -9.9636e3 -1.4545e6]
    B = [0 0 3.6364e5]'
    C = [1 0 0]
    D = 0
    ss(A, B, C, D)
end
e₄ = 8e-3
p₄ = 30e-3
ρ₄ = [0.7, 0.7, 0.7, 0.7]
K₄ = place(c2d(sys₄ * delay(p₄), p₄), ρ₄)

sys₅ = let
    A = [0 1 0; 0 -0.0227 54.5455; 0 -35.2857 -70]
    B = [0 0 28.1754]'
    C = [1 0 0]
    D = 0
    ss(A, B, C, D)
end
e₅ = 7e-3
p₅ = 25e-3
ρ₅ = [0.3, 0.3, 0.3, 0.3]
K₅ = place(c2d(sys₅ * delay(p₅), p₅), ρ₅)

τ = [
    TaskSet(sys₁, ρ₁, K₁, e₁, p₁),
    TaskSet(sys₂, ρ₂, K₂, e₂, p₂),
    TaskSet(sys₃, ρ₃, K₃, e₃, p₃),
    TaskSet(sys₄, ρ₄, K₄, e₄, p₄),
    TaskSet(sys₅, ρ₅, K₅, e₅, p₅),
]
