function [ O , DzDw1 , DzDw2  ] = comconv( I ,w1, w2,  DzDy )


 
       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ǰ�򴫲�
if nargin == 3  
     RI = real(I);
     II = imag(I);
     RO = vl_nnconv( RI, w1, w2, ...
            'pad', 2, ...
            'stride', 1, ...
           'dilate', 1 ) ;
     IO = vl_nnconv( II, w1, w2, ...
            'pad', 2, ...
            'stride', 1, ...
           'dilate', 1 ) ; 
       
     O = complex(RO,IO);   
     
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���򴫲�


      
      
if nargin == 4
    RI = real(I);
    II = imag(I);
    DzDy_R = real(DzDy);
    DzDy_I = imag(DzDy);
    
    [RO , RDzDw1 , RDzDw2 ] = vl_nnconv(RI, w1 , w2,  DzDy_R , ...
          'pad', 2, ...
          'stride', 1, ...
          'dilate', 1) ; 
    [IO , IDzDw1 , IDzDw2 ] = vl_nnconv(II, w1 , w2,  DzDy_I , ...
          'pad', 2, ...
          'stride', 1, ...
          'dilate', 1) ;   
  
    O = complex(RO,IO);
    DzDw1 = RDzDw1 + IDzDw1;
    DzDw2 = RDzDw2 + IDzDw2;
end


end

