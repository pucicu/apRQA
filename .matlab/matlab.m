%% fApproxRQA
% by Stephan Spiegel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('../../rp')


%% data
x = load('../data/roessler.csv');
x = x(1:10000);

%% parameter
eps = .5; m = 2; tau = 6; minL = 2;
        
%% reference
R = rp(x, eps, 'max');
Q = rqa(R, 2, 1, 'non');
rr0 = Q(1); det0 = Q(2); l0 = Q(3); lam0 = Q(6);
   
%% approximation
tic;
eps = .5;
Q = aprqa(x,eps/2,minL);  
t = toc;
rr = Q(1); det = Q(2); l = Q(3); lam = Q(4);
    
%% results
fprintf('RR:\t%0.3f (%0.3f)\nDET:\t%0.3f (%0.3f) \nL:\t%0.3f (%0.3f)\nLAM:\t%0.3f (%0.3f)\n',rr, rr0, det, det0, l, l0, lam, lam0);

fprintf('Time:\t%2.2f (sec) \n \n',t);


%% create tests
x = load('../data/roessler.csv');
x = x(1:2000);
n = length(x);
x1 = fDiscrete(x,0.5);
x1a = fDiscrete(x,1);
ex = [x x1 x1a]
save('../test/data/timeseries_raw.csv', 'x', '-ascii', '-tabs')
save('../test/data/discretized_e05_expected.csv', 'x1', '-ascii', '-tabs')
save('../test/data/discretized_e1_expected.csv', 'x1a', '-ascii', '-tabs')

x2 = embed(x1,2,1);
x3 = embed(x1,3,1);
save('../test/data/embed_m2_tau1_expected.csv', 'x2', '-ascii', '-tabs')
save('../test/data/embed_m3_tau1_expected.csv', 'x3', '-ascii', '-tabs')
   
pp1 = fPProximities(x1);
pp2 = fPProximities(x2);
pp3 = fPProximities(x3);
ex = [pp1 pp2 pp3]
save('../test/data/proximities_expected.csv', 'ex', '-ascii', '-tabs')
  
ss1 = pp1;
ss2 = fSStates(x1,x2);
ss3 = fSStates(x1,x3);
ex = [ss1 ss2 ss3]
save('../test/data/stationary_states_expected.csv', 'ex', '-ascii', '-tabs')


RR = pp1/(n*n);
DET = (minL*pp2 - (minL-1)*pp3) / (pp1 + 10^-10);
L = (minL*pp2 - (minL-1)*pp3) / (pp2 - pp3);
LAM = (minL*ss2 - (minL-1)*ss3) / (ss1 + 10^-10);
ex = [n RR DET L LAM]
save('../test/data/rqa_expected.csv', 'ex', '-ascii', '-tabs')
