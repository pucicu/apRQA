using StatsBase
using LinearAlgebra

"""
    stationary_states(x, y)

Calculate histogram of stationary states.

# Arguments
- `x`: time series (nx × d1) matrix or vector
- `y`: time series (ny × d2) matrix or vector

# Returns
- Number of stationary states (scalar)
"""
function stationary_states(x::AbstractVector, y::AbstractVector)
    # For vectors, d1 = d2 = 1
    
    # filter based on condition
    filter_x = mod.(sqrt.(x.^2), 1) .== 0
    filter_y = mod.(sqrt.(y.^2), 1) .== 0
    
    x_filtered = x[filter_x]
    y_filtered = y[filter_y]
    
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

function stationary_states(x::AbstractVector, y::AbstractMatrix)
    # x is vector (d1=1), y is matrix
    _, d2 = size(y)
    
    # filter based on condition
    filter_x = mod.(sqrt.(x.^2), 1) .== 0
    filter_y = vec(mod.(sqrt.(sum(y.^2, dims=2) ./ d2), 1) .== 0)
    
    x_filtered = x[filter_x]
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

function stationary_states(x::AbstractMatrix, y::AbstractVector)
    # x is matrix, y is vector
    _, d1 = size(x)
    
    # filter based on condition
    filter_x = vec(mod.(sqrt.(sum(x.^2, dims=2) ./ d1), 1) .== 0)
    filter_y = mod.(sqrt.(y.^2), 1) .== 0
    
    x_filtered = x[filter_x, 1]
    y_filtered = y[filter_y]
    
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
