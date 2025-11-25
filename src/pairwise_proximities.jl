"""
    pairwise_proximities(x)

Calculate pairwise proximities.

# Arguments
- `x`: time series (n × d) matrix or vector

# Returns
- Number of pairwise proximities (scalar)
"""
function pairwise_proximities(x::AbstractVector)
    # Count occurrences of each unique value
    unique_vals = unique(x)
    counts = zeros(Int, length(unique_vals))
    
    for val in x
        idx = findfirst(==(val), unique_vals)
        counts[idx] += 1
    end
    
    # Calculate dot product
    pp = dot(counts, counts)
    
    return pp
end

function pairwise_proximities(x::AbstractMatrix)
    # Find unique rows and their indices
    unique_rows = unique(eachrow(x))
    
    # Count occurrences of each unique row
    counts = zeros(Int, length(unique_rows))
    for row in eachrow(x)
        idx = findfirst(r -> all(r .== row), unique_rows)
        counts[idx] += 1
    end
    
    # Calculate dot product
    pp = dot(counts, counts)
    
    return pp
end
