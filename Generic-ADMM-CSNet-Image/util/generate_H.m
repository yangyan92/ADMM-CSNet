function [ M,Mt  ] = generate_H (picks, perm)

% generate measurement matrix HHHHH


 M = @(x) dfA(x,picks,perm,1);
 Mt = @(x) dfA(x,picks,perm,2);

end