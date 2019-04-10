function  [O, DzDw ] = xorg( Y, Rho , DzDy1 , DzDy2 ,DzDy3)
%%%����
load('mask.mat')
Ni1 = logical( ifftshift(mask) );
config;
gp = nnconfig.EnableGPU;

if gp
    Ni1 = gpuArray(Ni1);   
end


 if nargin == 2    
    Ni= Ni1 + Rho;
    Ni( find(Ni == 0)) = 1e-6;
    Q= 1./Ni;  
    O = ifft2( Y .* Q );     
 end
   

 if nargin == 5 
    DzDy = DzDy1 + DzDy2 + DzDy3;  
    Ni= Ni1 + Rho;
    Ni( find(Ni == 0)) = 1e-6;
    Q= 1./Ni;  
    AA = ifft2 (Q.* Q.* Y);
    RAA = real(AA);
    IAA = imag(AA);
    
    DzDy_R = real(DzDy);
    DzDy_I = imag(DzDy);
    RDzDw =  (-1) *DzDy_R(:)' * RAA(:);
    IDzDw =  (-1) *DzDy_I(:)' * IAA(:);
    DzDw = RDzDw + IDzDw;

    O = DzDy ;
  end
  
  
end
          
          
          
          
          
          
          
          



