

function [ O, O2 ] = Minus( I1, I2, DzDy1 ,DzDy2 )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ǰ�򴫲�
if nargin == 2  
     O = I1 - I2  ;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���򴫲�
if nargin ==4
    DzDy = DzDy1 + DzDy2 ;
    
    O = (-1)* DzDy;    %%%%I2
    O2 = DzDy;
    
    
end


end

