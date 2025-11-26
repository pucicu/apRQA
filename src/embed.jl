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
    new_n = n - (m - 1) * t
    X = similar(x, Float64, new_n, m)   # Tests erwarten Float64

    @inbounds for i in 1:m
        a = 1 + (i - 1) * t
        b = a + new_n - 1
        X[:, i] = @view x[a:b]
    end
    return X
end

function embed(x::AbstractMatrix, m::Int, t::Int)
    n, d = size(x)
    new_n = n - (m - 1) * t
    X = Array{Float64}(undef, new_n, d * m)   # Tests erwarten Float64

    @inbounds for i in 1:m
        a = 1 + (i - 1) * t
        b = a + new_n - 1
        X[:, (d*(i-1)+1):(d*i)] = @view x[a:b, :]
    end
    return X
end
