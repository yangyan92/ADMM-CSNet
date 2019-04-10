function [O, O2 , DzDw ] = xmid(I1, I2, Y, Rho, DzDy1 , DzDy2)
%%%����
config;



gg = nnconfig.EnableGPU; 
load('mask.mat')
Ni1 = logical( ifftshift(mask) );
if gg
 Ni1 = gpuArray(Ni1);   
end

 
 

%%%%%%%%%%%%%%%%%%%%%%%ǰ�򴫲�
if nargin == 4 
   
    
    number = Y + Rho * fft2( I1 - I2 );
    Ni= Ni1 + Rho;
    Ni( find(Ni == 0)) = 1e-6;
    Q= 1./Ni;  
    O = real(ifft2( number .* Q ));   
   
end
    
    
 %%%%%%%%%%%%%%���򴫲�    
 if nargin == 6
    DzDy = DzDy1 + DzDy2;
    Ni= Ni1 + Rho;
    Ni( find (Ni == 0)) = 1e-6;
    Q= 1./Ni;     
    A = fft2( I1 - I2 );
    AB = A.* Q ;
    AC = Y + Rho * A;
    AA = real(ifft2 (AB - Q.* Q.* AC));
    DzDw = DzDy(:)' * AA(:);
    DzDw = real(DzDw);
    
    %%%%%%%%%%%%O
    
    O =real( Rho * ifft2( Q .* fft2( DzDy)) );
    O2 = - O;
    
    
 end
 
 
end
     
     
     
     
     
     
     
     
     
     
     
     
     
     
 
