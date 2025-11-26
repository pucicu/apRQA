"""
    discretize(x, eps)

Discretize time series.

# Arguments
- `x`: time series (n × d) matrix or vector
- `eps`: similarity threshold (scalar or vector)

# Returns
- Discretized time series
"""
function discretize(x::AbstractArray, eps::Real)
    if eps > 0
        scale = 1.0 / (2eps)
        return @. floor(x * scale)
    else
        return x
    end
end


function discretize(x::AbstractMatrix, eps::AbstractVector)
    @assert size(x, 2) == length(eps) "eps must match number of columns"

    # build column-wise scale vector
    scale = @. 1.0 / (2eps)

    # broadcasting handles row × column broadcasting
    return @. floor(x * scale)
end
