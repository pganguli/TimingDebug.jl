using Test
using TimingDebug: adjust_periods, LocalSearch, ExhaustiveSearch, F₁, F₂, F₃

include("tasks.jl")

@testset "LocalSearch" begin
    @test adjust_periods(F₁, τ, alg=LocalSearch) ≈ [25e-3, 10e-3, 105e-3, 30e-3, 40e-3] atol = 1e-5
    @test adjust_periods(F₂, τ, alg=LocalSearch) ≈ [15e-3, 15e-3,  70e-3, 85e-3, 25e-3] atol = 1e-5
    @test adjust_periods(F₃, τ, alg=LocalSearch) ≈ [20e-3, 15e-3,  75e-3, 30e-3, 35e-3] atol = 1e-5
end


@testset "ExhaustiveSearch" begin
    itr = Iterators.product(
      0.015:0.005:0.050,
      0.010:0.005:0.025,
      0.020:0.005:0.100,
      0.030:0.005:0.100,
      0.025:0.005:0.050,
    )
    @test adjust_periods(F₁, τ, alg=ExhaustiveSearch, itr=map(x -> collect(x), itr)) ≈ [20e-3, 10e-3, 80e-3, 85e-3, 25e-3] atol = 1e-5
    @test adjust_periods(F₂, τ, alg=ExhaustiveSearch, itr=map(x -> collect(x), itr)) ≈ [15e-3, 15e-3, 65e-3, 85e-3, 25e-3] atol = 1e-5
    @test adjust_periods(F₃, τ, alg=ExhaustiveSearch, itr=map(x -> collect(x), itr)) ≈ [20e-3, 15e-3, 60e-3, 30e-3, 40e-3] atol = 1e-5
end
