function [ O, O2, O3,DzDw ] = betamid( I1, I2, I3, gamma, DzDy1,DzDy2, DzDy3  )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%前向传播
if nargin == 4  
    
      O = I1 + gamma * (I2 - I3 ) ;
     
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%反向传播
if nargin == 7
    DzDy = DzDy1 + DzDy2 +DzDy3;
    
  
    O = DzDy;
    O2 = gamma * DzDy ;
    O3 = -O ;
    temp = I2 - I3;
    
    Rtemp = real(temp);
    Itemp = imag(temp);
    
    DzDy_R = real(DzDy);
    DzDy_I = imag(DzDy);
    RDzDw =  DzDy_R(:)' * Rtemp(:);
    IDzDw =  DzDy_I(:)' * Itemp(:);
    DzDw = RDzDw + IDzDw;
    
    
   
    
   
end


end

