"""
    embed(x, m, t)

Time delay embedding.

# Arguments
- `x`: time series (n × d) or vector
- `m`: embedding dimension
- `t`: time delay

# Returns
- Embedded time series matrix ((n-(m-1)*t) × (d*m))
"""
function embed(x::AbstractVector, m::Int, t::Int)
    n = length(x)
    X = zeros(n - (m - 1) * t, m)
    
    for i in 1:m
        a = i + (t - 1) * (i - 1)
        b = a + n - 1 - (m - 1) * t
        X[:, i] = x[a:b]
    end
    
    return X
end

function embed(x::AbstractMatrix, m::Int, t::Int)
    n, d = size(x)
    X = zeros(n - (m - 1) * t, d * m)
    
    for i in 1:m
        a = i + (t - 1) * (i - 1)
        b = a + n - 1 - (m - 1) * t
        X[:, (d * (i - 1) + 1):(d * i)] = x[a:b, :]
    end
    
    return X
end
