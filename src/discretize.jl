"""
    discretize(x, eps)

Discretize time series.

# Arguments
- `x`: time series (n × d) matrix or vector
- `eps`: similarity threshold (scalar or vector)

# Returns
- Discretized time series
"""
function discretize(x::AbstractVector, eps::Real)
    if eps > 0
        scale = 1.0 / (2 * eps)
        return floor.(x .* scale)
    else
        return x
    end
end

function discretize(x::AbstractMatrix, eps::Real)
    if eps > 0
        scale = 1.0 / (2 * eps)
        return floor.(x .* scale)
    else
        return x
    end
end

function discretize(x::AbstractMatrix, eps::AbstractVector)
    if any(eps .> 0)
        return floor.(x .* (1.0 ./ (2.0 .* eps')'))
    else
        return x
    end
end
