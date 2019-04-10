function [ M, Mt ] = generate_D (signvec, SubsampM )

% generate measurement matrix
config;
size = nnconfig.ImageSize;

a=size(1);
b=size(2);
n=a*b;

 M=@(x) SubsampM*reshape(fft2(reshape(bsxfun(@times,signvec,x(:)),[a,b])),[n,1])*(1/sqrt(n));
 Mt=@(x) bsxfun(@times,conj(signvec),reshape(ifft2(reshape(SubsampM'*x(:),[a,b])),[n,1]))*sqrt(n);
 


end