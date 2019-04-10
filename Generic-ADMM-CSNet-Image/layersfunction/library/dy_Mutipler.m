
function [O1, O2, O3, DzDw] = dy_Mutipler(B, X, Z, eta, DzDy)


if nargin == 4 
 O1 =  eta*B + (X - Z); 
end

if nargin == 5 
    
  DzDw =  DzDy(:)' *  B(:);    
  O1 = eta * (DzDy); 
  O2 = DzDy; 
  O3 = -O2; 
  
 
end

  
 end
 
     

