module aRQA

export approximate_rqa, embed, discretize, pairwise_proximities, stationary_states

include("approximate_rqa.jl")
include("embed.jl")
include("discretize.jl")
include("pairwise_proximities.jl")
include("stationary_states.jl")

end # module
