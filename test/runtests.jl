using Test
using apRQA

@testset "apRQA Tests" begin
    include("test_embed.jl")
    include("test_discretize.jl")
    include("test_pairwise_proximities.jl")
    include("test_stationary_states.jl")
    include("test_aprqa.jl")
end
