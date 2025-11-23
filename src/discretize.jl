"""
    discretize(x, eps)

Discretize time series.

# Arguments
- `x`: time series (n × d)
- `eps`: similarity threshold (scalar or vector)

# Returns
- Discretized time series
"""
function discretize(x::AbstractMatrix, eps::Real)
    if eps > 0
        n, d = size(x)
        # create diagonal matrix for scaling
        scale = 1.0 / (2 * eps)
        return floor.(x .* scale)
    else
        return x
    end
end

function discretize(x::AbstractMatrix, eps::AbstractVector)
    if any(eps .> 0)
        # for different eps per dimension
        return floor.(x .* (1.0 ./ (2.0 .* eps')'))
    else
        return x
    end
end
