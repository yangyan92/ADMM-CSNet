
function [ O, O2 , O3 , DzDw1, DzDw2 ] = Add3( I1, I2, I3 , eta1 , eta2,  DzDy1 ,DzDy2 )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%前向传播
if nargin == 5  
     O = eta1 * I2 + eta2 * I3 + I1 ;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%反向传播
if nargin ==7
    DzDy = DzDy1 + DzDy2 ;
    
    O =  DzDy;    
    O2 = eta1 * DzDy;
    O3 = eta2 * DzDy;
    
    
   
    
    
   
    DzDy_R = real(DzDy);
    DzDy_I = imag(DzDy);
    
     Rtemp1 = real(I2);
    Itemp1 = imag(I2);
    
    RDzDw1 =  DzDy_R(:)' * Rtemp1(:);
    IDzDw1 =  DzDy_I(:)' * Itemp1(:);
    DzDw1 = RDzDw1 + IDzDw1;
    
    Rtemp2 = real(I3);
    Itemp2 = imag(I3);
    
    RDzDw2 =  DzDy_R(:)' * Rtemp2(:);
    IDzDw2 =  DzDy_I(:)' * Itemp2(:);
    DzDw2 = RDzDw2 + IDzDw2;
    
end


end

