using LinearAlgebra

"""
    pairwise_proximities(x)

Calculate histogram of pairwise proximities.

# Arguments
- `x`: time series (n × d)

# Returns
- Histogram of pairwise proximities (scalar)
"""
function pairwise_proximities(x::AbstractMatrix)
    # find unique rows and their indices
    # Julia's unique return (unique_rows, indices)
    unique_rows = unique(eachrow(x))
    
    # count appearances in each unique row
    counts = zeros(Int, length(unique_rows))
    for row in eachrow(x)
        idx = findfirst(r -> all(r .== row), unique_rows)
        counts[idx] += 1
    end
    
    # get dot product
    pp = dot(counts, counts)
    
    return pp
end
