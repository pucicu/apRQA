function Q = aprqa(x, eps, minL)
% aprqa - Approximate RQA
%    Q = aprqa(X,EPS,MINL)

[n,~] = size(x);
    
x1 = fDiscrete(x,eps);
x2 = embed(x1,minL,1);
x3 = embed(x1,minL+1,1);
    
pp1 = fPProximities(x1);
pp2 = fPProximities(x2);
pp3 = fPProximities(x3);
    
ss1 = pp1;
ss2 = fSStates(x1,x2);
ss3 = fSStates(x1,x3);
    
RR = pp1/(n*n);
DET = (minL*pp2 - (minL-1)*pp3) / (pp1 + 10^-10);
L = (minL*pp2 - (minL-1)*pp3) / (pp2 - pp3);
LAM = (minL*ss2 - (minL-1)*ss3) / (ss1 + 10^-10);

Q = [RR, DET, L, LAM];
end

function X = embed(x,m,t)
%embed time delay embedding
%   x   ..  time series [n times d]
%   m   ..  embedding
%   t   ..  dalay
%   X   ..  time series [n-(m-1)*t times d*m]

    [n,d] = size(x);
    
    X = zeros(n-(m-1)*t,d*m);
    for i = 1:m
        a = i+(t-1)*(i-1);
        b = a+n-1-(m-1)*t;
        X(:,d*(i-1)+1:d*i) = x(a:b,:);
    end
end



