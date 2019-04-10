function [O, O2 , DzDw ] = xfinal(I1, I2, Y, Rho, DzDy)
%%%����
config;
gp = nnconfig.EnableGPU; 
load('mask.mat')
Ni1 = logical( ifftshift(mask) );
if gp
 Ni1 = gpuArray(Ni1);   
end


%%%%%%%%%%%%%%%%%%%%%%%ǰ�򴫲�
if nargin == 4 
    number = Y + Rho * fft2( I1 - I2 );
    Ni= Ni1 + Rho;
    Ni( find(Ni == 0)) = 1e-6;
    Q= 1./Ni;  
    O =ifft2( number .* Q );   
   
end
    
    
 %%%%%%%%%%%%%%���򴫲�    
 if nargin == 5
 
   
    Ni= Ni1 + Rho;
    Ni( find (Ni == 0)) = 1e-6;
    Q= 1./Ni;     
    A = fft2( I1 - I2 );
    AB = A.* Q ;
    AC = Y + Rho * A;
    AA = ifft2 (AB - Q.* Q.* AC);
    RAA = real(AA);
    IAA = imag(AA);
    
    DzDy_R = real(DzDy);
    DzDy_I = imag(DzDy);
    RDzDw =  DzDy_R(:)' * RAA(:);
    IDzDw =  DzDy_I(:)' * IAA(:);
    DzDw = RDzDw + IDzDw;

    
    %%%%%%%%%%%%O
    
    O = Rho * ifft2( Q .* fft2( DzDy) );
    O2 = - O;
    
    
 end
 
 
end
     
     
     
     
     
     
     
     
     
     
     
     
     
     
 
