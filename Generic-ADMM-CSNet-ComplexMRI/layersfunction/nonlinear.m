function [ O, DzDw ] = nonlinear ( LL, I, r , DzDy )
%% Nonlinear transform layer(cpu)

config;
gp = nnconfig.EnableGPU;


if nargin == 3    
    RI = real(I);
    II = imag(I);    
    if gp 
       RO = nnlinecu_double( LL ,r , RI);
       IO = nnlinecu_double( LL ,r , II);
    else
       RO = nnlinemex( LL, r , RI);
       IO = nnlinemex( LL, r , II); 
    end 
    O = complex(RO,IO);              
end


if nargin ==4
    
   RI = real(I);
   II = imag(I);
   DzDy_R = real(DzDy);
   DzDy_I = imag(DzDy);
   if gp
       
      [RO, RDzDw] = nnlinecu_double(LL, r, RI, DzDy_R);
      [IO, IDzDw] = nnlinecu_double(LL, r, II, DzDy_I);
   else      
      [RO, RDzDw] = nnlinemex( LL, r, RI, DzDy_R);  
      [IO,IDzDw] = nnlinemex( LL, r, II, DzDy_I);  
   end
   O = complex(RO,IO);
   DzDw =  RDzDw + IDzDw;
end
end

