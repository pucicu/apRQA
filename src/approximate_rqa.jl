"""
    approximate_rqa(x, ε, minL)

Approximate Recurrence Quantification Analysis (RQA).

# Arguments
- `x`: Embedded time series (vector or matrix)
- `ε`: Similarity threshold
- `minL`: Minimum line length

# Returns
- Vector with [RR, DET, L, LAM], where:
  - `RR`: Recurrence rate
  - `DET`: Determinism
  - `L`: Average diagonal line length
  - `LAM`: Laminarity
"""
function approximate_rqa(x::AbstractVector, ε::Real, minL::Int)
    # Convert vector to n×1 matrix
    return approximate_rqa(reshape(x, :, 1), ε, minL)
end

function approximate_rqa(x::AbstractMatrix, ε::Real, minL::Int)
    # Input validation
    if minL < 1
        throw(ArgumentError("minL must be >= 1"))
    end
    if ε <= 0
        throw(ArgumentError("ε must be > 0"))
    end

    n = size(x, 1)

    # Precompute intermediate results
    x1 = discretize(x, ε)
    x2 = embed(x1, minL, 1)
    x3 = embed(x1, minL + 1, 1)

    pp1 = pairwise_proximities(x1)
    pp2 = pairwise_proximities(x2)
    pp3 = pairwise_proximities(x3)

    ss1 = pp1
    ss2 = stationary_states(x1, x2)
    ss3 = stationary_states(x1, x3)

    # Safe division helper
    safe_divide(a, b) = a / (b + 1e-10)

    # Compute RQA measures
    RR = safe_divide(pp1, n * n)

    numerator_DET_L = minL * pp2 - (minL - 1) * pp3
    DET = safe_divide(numerator_DET_L, pp1)
    L = safe_divide(numerator_DET_L, pp2 - pp3)

    numerator_LAM = minL * ss2 - (minL - 1) * ss3
    LAM = safe_divide(numerator_LAM, ss1)

    return (RR=RR, DET=DET, L=L, LAM=LAM)::NamedTuple{(:RR, :DET, :L, :LAM), NTuple{4, Float64}}
end
