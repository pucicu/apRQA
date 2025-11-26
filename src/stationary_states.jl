using StatsBase
using LinearAlgebra

"""
    _filter_condition(z::AbstractVector)
    _filter_condition(z::AbstractMatrix, dim::Int)

Helper function to compute the filter condition for vectors or matrices.
Checks if the Euclidean norm (scaled) is an integer.
"""
_filter_condition(z::AbstractVector) = isinteger.(abs.(z))
function _filter_condition(z::AbstractMatrix, dim::Int)
    d = size(z, 2)
    return vec(isinteger.(sqrt.(sum(z.^2, dims=2) ./ d)))
end

"""
    _stationary_states_impl(x_filtered, y_filtered)

Calculates the similarity measure for filtered stationary states.
"""
function _stationary_states_impl(x_filtered, y_filtered)
    if isempty(x_filtered) || isempty(y_filtered)
        return 0
    end

    minA = min(minimum(x_filtered), minimum(y_filtered))
    maxA = max(maximum(x_filtered), maximum(y_filtered))

    bins = (minA - 1):(maxA + 1)
    hx = fit(Histogram, x_filtered, bins, closed=:left).weights
    hy = fit(Histogram, y_filtered, bins, closed=:left).weights

    return dot(hx, hy)
end

"""
    stationary_states(x, y)

Calculates a similarity measure of stationary states between two time series `x` and `y`.
Time series can be vectors or matrices.

# Arguments
- `x`: Time series (vector or matrix)
- `y`: Time series (vector or matrix)

# Returns
- Scalar value representing the similarity of histograms of filtered stationary states.
"""
function stationary_states(x::AbstractVector, y::AbstractVector)
    filter_x = _filter_condition(x)
    filter_y = _filter_condition(y)

    x_filtered = x[filter_x]
    y_filtered = y[filter_y]

    return _stationary_states_impl(x_filtered, y_filtered)
end

function stationary_states(x::AbstractVector, y::AbstractMatrix)
    _, d2 = size(y)
    filter_x = _filter_condition(x)
    filter_y = _filter_condition(y, d2)

    x_filtered = x[filter_x]
    y_filtered = y[filter_y, 1]

    return _stationary_states_impl(x_filtered, y_filtered)
end

function stationary_states(x::AbstractMatrix, y::AbstractVector)
    d1, _ = size(x)
    filter_x = _filter_condition(x, d1)
    filter_y = _filter_condition(y)

    x_filtered = x[filter_x, 1]
    y_filtered = y[filter_y]

    return _stationary_states_impl(x_filtered, y_filtered)
end

function stationary_states(x::AbstractMatrix, y::AbstractMatrix)
    d1, _ = size(x)
    d2, _ = size(y)
    filter_x = _filter_condition(x, d1)
    filter_y = _filter_condition(y, d2)

    x_filtered = x[filter_x, 1]
    y_filtered = y[filter_y, 1]

    return _stationary_states_impl(x_filtered, y_filtered)
end
