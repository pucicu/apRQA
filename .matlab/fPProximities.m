function pp = fPProximities(x)
%FPPROXIMITIES pairwise proximities
%   x ..    time series [nx-times-d]
%   pp ..   pairwise proximities

    [~,~,ix] = unique(x,'rows');
    hx = hist(ix,min(ix)-1:max(ix)+1);
    pp = dot(hx,hx);
end
