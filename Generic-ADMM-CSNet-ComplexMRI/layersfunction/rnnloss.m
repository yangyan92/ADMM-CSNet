function Y = rnnloss(X, I, DzDy )
%   X: restored image of size MxM
%   I: original image of size MxM

B=norm(I,'fro');

if nargin == 2
 S = X - I ;
 Y = norm(S,'fro') / B ;
 
elseif nargin ==3
 S = X - I ;
 Y1 = norm(S,'fro') ;   
 Y = S /(B*Y1);
else
    error('Input arguments number not proper.');
end
end