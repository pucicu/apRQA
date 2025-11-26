using StatsBase

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
    counts = values(countmap(x))

    # Calculate dot product
    pp = dot(counts, counts)

    return pp
end


function pairwise_proximities(x::AbstractMatrix)
    # Convert each row to a Tuple so countmap can hash it
    rows = Tuple.(eachrow(x))

    # Count occurrences of each unique row
    counts = values(countmap(rows))

    # Calculate dot product
    pp = dot(counts, counts)

    return pp
end
