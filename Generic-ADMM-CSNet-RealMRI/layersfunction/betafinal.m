function [ O, O2, O3 ,DzDw] = betafinal( I1, I2, I3, gamma, DzDy )


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ǰ�򴫲�
if nargin == 4  
     O = I1 + gamma * (I2 - I3 ) ;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���򴫲�
if nargin ==5
    O = DzDy;
    O2 = gamma * DzDy ;
    O3 = -O ;
    temp = I2 - I3;
    DzDw  =DzDy(:)'* temp(:) ;
    
end


end

