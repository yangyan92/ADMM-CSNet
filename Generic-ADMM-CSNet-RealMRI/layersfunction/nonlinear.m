function [ O, DzDw ] = nonlinear ( LL, I, r , DzDy )
%% Nonlinear transform layer(cpu)

config;
gg = nnconfig.EnableGPU;


if nargin == 3   
    
if gg

    O = nnlinecu_double(LL ,r , I);
      
else
    
    O = nnlinemex( LL, r , I);
    
end 
    
              
end

if nargin ==4


   if gg

   [O, DzDw] = nnlinecu_double(LL, r, I, DzDy);
  
   else 
       
   [O, DzDw] = nnlinemex( LL, r, I, DzDy);  
   end
       
end
end

