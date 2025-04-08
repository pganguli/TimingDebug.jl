push!(LOAD_PATH, ".")

using TimingDebug

τ = [
  TimingDebug.Task(models[1]..., 5, 15),
  TimingDebug.Task(models[2]..., 3, 10),
  TimingDebug.Task(models[3]..., 6, 20),
  TimingDebug.Task(models[4]..., 8, 30),
  TimingDebug.Task(models[5]..., 7, 25),
]

optimalTimingDebugging(τ, F₁)
