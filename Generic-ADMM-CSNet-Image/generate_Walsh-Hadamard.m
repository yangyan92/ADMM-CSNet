function [ A ,At,picks, perm ] = generate_Walsh-Hadamard (N, m)

% generate measurement matrix HHHHH

p = randperm(N);
   picks = p(1:m);
 for ii = 1:m
     if picks(ii) == 1
         picks(ii) = p(m+1);
         break;
     end
 end
  perm = randperm(N); % column permutations allowable
 A = @(x) dfA(x,picks,perm,1);
 At = @(x) dfA(x,picks,perm,2);

end