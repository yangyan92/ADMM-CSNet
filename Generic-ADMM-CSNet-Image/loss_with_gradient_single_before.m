function [ loss, ps , sm, rex    ] = loss_with_gradient_single_before(noisy, clean , net, picks, perm)
config;
gp = nnconfig.EnableGPU;
size = nnconfig.ImageSize;
noisy = real(noisy);
%H
if strcmp(nnconfig.Operator, 'Walsh-Hadamard')
    A = @(x) dfA(x,picks,perm,1);
    At = @(x) dfA(x,picks,perm,2);
end

%P
if strcmp(nnconfig.Operator, 'Coded-diffraction') 
    n=size(1) * size(2);
    A=@(x) perm*reshape(fft2(reshape(bsxfun(@times,picks,x(:)),[sqrt(n),sqrt(n)])),[n,1])*(1/sqrt(n));
    At=@(x) bsxfun(@times,conj(picks),reshape(ifft2(reshape(perm'*x(:),[sqrt(n),sqrt(n)])),[n,1]))*sqrt(n);
end



M.A = A;
M.At = At;

if gp
    net.move('gpu') ;
    noisy = gpuArray(noisy);
    clean = gpuArray(clean);
end

 

inputs = {'noisy', noisy, 'clean', clean, 'ME', M};

net.conserveMemory = 0;




%%%%%%%% forward
net.mode = 'test' ;
net.eval(inputs) ;
loss = net.vars(end).value;
rex1 = net.vars(end-2).value;
rex = reshape(rex1,size);
% imshow(rex,[]);
ps = PSNR(abs(rex), abs(clean));
sm = ssim(abs(rex), abs(clean));

loss = gather(loss); 

loss = double(loss);



end


    
            










