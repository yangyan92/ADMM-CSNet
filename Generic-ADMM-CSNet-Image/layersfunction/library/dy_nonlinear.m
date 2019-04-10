function [ O, DzDw ] = dy_nonlinear ( I,  r , DzDy )
%% Nonlinear transform layer(cpu)

config;
gg = nnconfig.EnableGPU;
LL = nnconfig.LinearLabel;

if nargin == 2   
    

if gg
    LL = gpuArray( LL);
    O = nnlinecu_double(LL ,r , I);
else
    
    O = nnlinemex( LL, r , I);
    
end 
    
              
end

if nargin ==3


   if gg
     LL = gpuArray( LL); 
   [O, DzDw] = nnlinecu_double(LL, r, I, DzDy);
  
   else 
      
   [O, DzDw] = nnlinemex( LL, r, I, DzDy);  
   end
       
end
end

