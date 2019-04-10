function [ A ,At,signvec, SubsampM ] = generate_Coded-diffraction (n, m)

% generate measurement matrix PPPPP
a= 256;
b = 256;
signvec = exp(1i*2*pi*rand(n,1));
inds=[1;randsample(n-1,m-1)+1];
I=speye(n);
SubsampM=I(inds,:);

 A=@(x) SubsampM*reshape(fft2(reshape(bsxfun(@times,signvec,x(:)),[a ,b])),[n,1])*(1/sqrt(n));
 At=@(x) bsxfun(@times,conj(signvec),reshape(ifft2(reshape(SubsampM'*x(:),[a ,b])),[n,1]))*sqrt(n);
 


end