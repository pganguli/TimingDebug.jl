"""
Table 1: Case Study Specification
"""

using ControlSystemsBase: ss

sys₁ = let
    A = [-10 1; -0.02 -2]
    B = [0 2]'
    C = [1 0]
    D = 0
    ss(A, B, C, D)
end
ρ₁ = [0.5 + 0im, 0.5 + 0im, 0.5 + 0im]
K₁ = [122.8023 16.7514 0.3311]
e₁ = 5e-3
p₁ = 15e-3

sys₂ = let
    A = [-0.2 0.67; -10 -100]
    B = [0 37000]'
    C = [1 0]
    D = 0
    ss(A, B, C, D)
end
ρ₂ = [0.4 + 0im, 0.4 + 0im, 0.4 + 0im]
K₂ = [0.1365 0.0009 0.1655]
e₂ = 3e-3
p₂ = 10e-3

sys₃ = let
    A = [-10 1; -0.2 -15]
    B = [0 20]'
    C = [1 0]
    D = 0
    ss(A, B, C, D)
end
ρ₃ = [0.7 + 0im, 0.7 + 0im, 0.7 + 0im]
K₃ = [0.2938 0.0566 -0.5405]
e₃ = 6e-3
p₃ = 20e-3

sys₄ = let
    A = [0 1 0; 0 -1.0865 8.4872e3; 0 -9.9636e3 -1.4545e6]
    B = [0 0 3.6364e5]'
    C = [1 0 0]
    D = 0
    ss(A, B, C, D)
end
ρ₄ = [0.7 + 0im, 0.7 + 0im, 0.7 + 0im, 0.7 + 0im]
K₄ = [0.0091 0.0201 5.6765 -1.6308]
e₄ = 8e-3
p₄ = 30e-3

sys₅ = let
    A = [0 1 0; 0 -0.0227 54.5455; 0 -35.2857 -70]
    B = [0 0 28.1754]'
    C = [1 0 0]
    D = 0
    ss(A, B, C, D)
end
ρ₅ = [0.3 + 0im, 0.3 + 0im, 0.3 + 0im, 0.3 + 0im]
K₅ = [23.3252 0.8360 0.6791 0.4576]
e₅ = 7e-3
p₅ = 25e-3

τ = [
    TaskSet(sys₁, ρ₁, K₁, e₁, p₁),
    TaskSet(sys₂, ρ₂, K₂, e₂, p₂),
    TaskSet(sys₃, ρ₃, K₃, e₃, p₃),
    TaskSet(sys₄, ρ₄, K₄, e₄, p₄),
    TaskSet(sys₅, ρ₅, K₅, e₅, p₅),
]
