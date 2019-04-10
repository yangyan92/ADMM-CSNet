
function [O1, O2, O3,  DzDw ] = dy_reconMID(Y, Z, M, Rho, DzDy)

config;
m = nnconfig.ImageSize ;
gg = nnconfig.EnableGPU; 
global perdata;
A = perdata.A;
At = perdata.At;

if gg
   Y = gather(Y); 
   Z = gather(Z); 
   M = gather(M); 
end   
v = 1/(  1+Rho);
C= Y + Rho * ( Z - M );
 B = (1/Rho) * C;

if nargin == 4 
    
    Or = B(:) - v*(At(A((B(:)))));  
    O1 = reshape(Or,m,m);
    if gg
       O1 = gpuArray(real(O1)); 
    end   
    
    
    
    
end

if nargin == 5 
  
    if gg
        DzDy = gather(DzDy); 
    end
    Or = B(:) - v*(At(A(B(:))));
    
    B1 = (1/Rho) * (Z(:) - M(:) - Or);
    AA = B1(:) - v*(At(A(B1(:)))); 
   
    DzDw =  DzDy(:)' * real(AA);     
    Ow =  DzDy(:) - v*(At(A(DzDy(:)))); 
    O2 = reshape(Ow,m,m);
    O1 = O2 ./ Rho;
    if gg
       O2 = gpuArray(real(O2));
    end
    O3 = - O2;
    
    
    
end

  
 end
 
     

