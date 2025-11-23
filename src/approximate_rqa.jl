"""
    approximate_rqa(x, eps, minL)

Approximate Recurrence Quantification Analysis.

# Arguments
- `x`: embedded time series matrix (n × d)
- `eps`: similarity threshold
- `minL`: minimum line length

# Returns
- Vector with [RR, DET, L, LAM]
"""
function approximate_rqa(x::AbstractMatrix, eps::Real, minL::Int)
    n = size(x, 1)
    
    x1 = discretize(x, eps)
    x2 = embed(x1, minL, 1)
    x3 = embed(x1, minL + 1, 1)
    
    pp1 = pairwise_proximities(x1)
    pp2 = pairwise_proximities(x2)
    pp3 = pairwise_proximities(x3)
    
    ss1 = pp1
    ss2 = stationary_states(x1, x2)
    ss3 = stationary_states(x1, x3)
    
    RR = pp1 / (n * n)
    DET = (minL * pp2 - (minL - 1) * pp3) / (pp1 + 1e-10)
    L = (minL * pp2 - (minL - 1) * pp3) / (pp2 - pp3)
    LAM = (minL * ss2 - (minL - 1) * ss3) / (ss1 + 1e-10)
    
    return [RR, DET, L, LAM]
end
