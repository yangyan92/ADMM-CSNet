%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% At_fWH
%
% Written by: Chengbo Li
% CAAM, Rice University
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x = At_fWH(b, OMEGA, P)

N = length(P);
fx = zeros(N,1);
fx(OMEGA) = b/sqrt(N);
x = zeros(N,1);
tmp = ifWHtrans(fx);
x(P) = tmp(1:N);