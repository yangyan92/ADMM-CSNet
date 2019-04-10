function [ O  ] = crelu( I ,  DzDy )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%前向传播
if nargin == 1 
     RI = real(I);
     II = imag(I);
     RO = vl_nnrelu( RI ) ; 
     IO = vl_nnrelu( II ) ; 
     %O = RO + iIO;   
        O = complex(RO,IO);
     
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%反向传播
if nargin == 2
    RI = real(I);
    II = imag(I);
    DzDy_R = real(DzDy);
    DzDy_I = imag(DzDy);
    RO = vl_nnrelu(RI, DzDy_R) ;
    IO = vl_nnrelu(II, DzDy_I) ; 
       O = complex(RO,IO);
   % O = RO + iIO;
end


end

