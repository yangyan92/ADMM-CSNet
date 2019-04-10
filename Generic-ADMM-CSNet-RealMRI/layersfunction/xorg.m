function  [O, DzDw ] = xorg( Y, Rho , DzDy1 , DzDy2 ,DzDy3)

load('mask.mat')
Ni1 = logical( ifftshift(mask) );
config;
gg = nnconfig.EnableGPU;
if gg
 Ni1 = gpuArray(Ni1);   
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ǰ�򴫲�
if nargin == 2  
  
    Ni= Ni1 + Rho;
    Ni( find(Ni == 0)) = 1e-6;
    Q= 1./Ni;  
    O = real(ifft2( Y .* Q ));     
    
end
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���򴫲�
  if nargin == 5 
    DzDy = DzDy1 + DzDy2 + DzDy3;  
    
    Ni= Ni1 + Rho;
    Ni( find(Ni == 0)) = 1e-6;
    Q= 1./Ni;  
    
  
    AA = real(ifft2 (Q.* Q.* Y));
    DzDw = (-1) * DzDy(:)' * AA(:);
    DzDw = real(DzDw); 
    
    
    
  O = DzDy ;
  end
  
  
end
          
          
          
          
          
          
          
          



