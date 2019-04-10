%function Y = nnloss_square(R, I, DzDy)
function Y = nnloss_square(R, I, X, DzDy)

% NNLOSS: calculate the square error of restored image and original image
%   X: restored image of size MxM
%   I: original image of size MxM

% if nargin ==2
%     
%     S = (R - I).^2;
%     Y = sum(S(:));
%     
% elseif nargin == 3
%     
%     Y = 2 * (R - I);
%     
% else
%     error('Input arguments number not proper.');
% end;



if nargin ==3
    
    S = (R - (X-I)).^2;
    Y = sum(S(:));
    
elseif nargin == 4
    
    Y = 2 * (R - (X-I));
    
else
    error('Input arguments number not proper.');
end;

end
