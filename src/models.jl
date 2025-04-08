using ControlSystemsBase: ss

sys₁ = let
  A = [-10 1; -0.02 -2]
  B = [0 2]'
  C = [1 0]
  D = 0
  ss(A, B, C, D)
end
K₁ = [122.8023 16.7514 0.3311]

sys₂ = let
  A = [-0.2 0.67; -10 -100]
  B = [0 37000]'
  C = [1 0]
  D = 0
  ss(A, B, C, D)
end
K₂ = [0.1365 0.0009 0.1655]

sys₃ = let
  A = [-10 1; -0.2 -15]
  B = [0 20]'
  C = [1 0]
  D = 0
  ss(A, B, C, D)
end
K₃ = [0.2938 0.0566 -0.5405]

sys₄ = let
  A = [0 1 0; 0 -1.0865 8.4872e3; 0 -9.9636e3 -1.4545e6]
  B = [0 0 3.6364e5]'
  C = [1 0 0]
  D = 0
  ss(A, B, C, D)
end
K₄ = [0.0091 0.0201 5.6765 -1.6308]

sys₅ = let
  A = [0 1 0; 0 -0.0227 54.5455; 0 -35.2857 -70]
  B = [0 0 28.1754]'
  C = [1 0 0]
  D = 0
  ss(A, B, C, D)
end
K₅ = [23.3252 0.8360 0.6791 0.4576]

models = [(sys₁, K₁), (sys₂, K₂), (sys₃, K₃), (sys₄, K₄), (sys₅, K₅)]
