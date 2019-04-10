function varargout = rnnloss(X, I, DzDy )

B=norm(I,'fro');

if nargin == 2
 S = X - I ;
 Y = norm(S,'fro') / B ;
  varargout = {Y};
elseif nargin ==3
 S = X - I ;
Y1 = norm(S,'fro') ;   
 Y = DzDy * S /(B*Y1);
 varargout = {Y, 0, 0};

end
end