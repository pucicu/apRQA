using StatsBase
using LinearAlgebra

"""
    stationary_states(x, y)

Calculate histogram of stationary states.

# Arguments
- `x`: time series (nx × d1)
- `y`: time series (ny × d2)

# Returns
- Histogram of stationary states (scalar)
"""
function stationary_states(x::AbstractMatrix, y::AbstractMatrix)
    _, d1 = size(x)
    _, d2 = size(y)
    
    # filter rows based on condition
    # use vec() to convert n×1 matrix to vector for indexing
    filter_x = vec(mod.(sqrt.(sum(x.^2, dims=2) ./ d1), 1) .== 0)
    filter_y = vec(mod.(sqrt.(sum(y.^2, dims=2) ./ d2), 1) .== 0)
    
    x_filtered = x[filter_x, 1]
    y_filtered = y[filter_y, 1]
    
    # check if filtered arrays are empty
    if isempty(x_filtered) || isempty(y_filtered)
        return 0
    end
    
    # find min and max
    minA = min(minimum(x_filtered), minimum(y_filtered))
    maxA = max(maximum(x_filtered), maximum(y_filtered))
    
    # create histogram
    bins = (minA - 1):(maxA + 1)
    hx = fit(Histogram, x_filtered, bins, closed=:left).weights
    hy = fit(Histogram, y_filtered, bins, closed=:left).weights
    
    # calculate dot product
    ss = dot(hx, hy)
    
    return ss
end
