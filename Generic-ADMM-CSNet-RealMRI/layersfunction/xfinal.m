function [O, O2 , DzDw ] = xfinal(I1, I2, Y, Rho, DzDy)
%%%����
config;


gg = nnconfig.EnableGPU; 
load('mask.mat')
Ni1 = logical( ifftshift(mask) );
if gg
 Ni1 = gpuArray(Ni1);   
%  Rho = gpuArray(Rho);
end


 
 

%%%%%%%%%%%%%%%%%%%%%%%ǰ�򴫲�
if nargin == 4 
   
    
    number = Y + Rho * fft2( I1 - I2 );
    Ni= Ni1 + Rho;
    Ni( find(Ni == 0)) = 1e-6;
    Q= 1./Ni;  
    O =real(ifft2( number .* Q ));   
   
end
    
    
 %%%%%%%%%%%%%%���򴫲�    
 if nargin == 5
 
   
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
    
    O = Rho * ifft2( Q .* fft2( DzDy) );
     O = real(O);
    O2 = - O;
    
    
 end
 
 
end
     
     
     
     
     
     
     
     
     
     
     
     
     
     
 
