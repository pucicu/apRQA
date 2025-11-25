function ss = fSStates(x,y)
%FSSTATES stationary states
%   x ..    time series [nx-times-d1]
%   y ..    time series [ny-times-d2]
%   ss ..   stationary states

    [~,d1] = size(x);
    [~,d2] = size(y);

    x = x(mod(sqrt(sum(x.^2,2)/d1),1)==0,1);
    y = y(mod(sqrt(sum(y.^2,2)/d2),1)==0,1);

    minA = min([x;y]);
    maxA = max([x;y]);

    hx = hist(x,minA-1:maxA+1);
    hy = hist(y,minA-1:maxA+1);

    ss = dot(hx,hy);
end
