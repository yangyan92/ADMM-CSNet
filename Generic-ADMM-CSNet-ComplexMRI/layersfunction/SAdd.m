function [ O, O2 ] = SAdd( I1, I2, DzDy1, DzDy2 )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%前向传播
if nargin == 2  
     O = I1 + I2  ;
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%反向传播
if nargin ==4
    DzDy = DzDy1 + DzDy2 ;
    O = DzDy;
    O2 = DzDy ;
    
    
end


end

