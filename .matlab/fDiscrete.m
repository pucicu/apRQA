function x = fDiscrete(x,eps)
%FDISCRETE Discretize Time Series
%   x ..    time series [n-times-d]
%   eps ..  similarity thresholds [1-times-d]

    if eps>0
        x = floor(x*diag(1./(2*eps)));
    end    
end
