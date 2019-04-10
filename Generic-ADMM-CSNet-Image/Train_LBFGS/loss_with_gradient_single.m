function [ loss, grad ] = loss_with_gradient_single(noisy, clean , net, picks, perm)

config;
TN=nnconfig.TrainNumber;
gp = nnconfig.EnableGPU;
size = nnconfig.ImageSize;


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
opts.train.derOutputs = {'L2', 1};
s = 1; 


if nargout == 1

%%%%%%%% forward
net.mode = 'test' ;
net.eval(inputs) ;

loss = net.vars(end).value;
if gp
   loss = gather(loss); 
end
loss = double(loss);
end

if nargout == 2
    
%%%%%%%% back

    
net.mode = 'normal' ;
net.accumulateParamDers = (s ~= 1) ;
net.eval(inputs, opts.train.derOutputs, 'holdOn', s < TN) ;   
   
loss = net.vars(end).value;
loss = double(loss);

grad = [];
for p=1:numel(net.params)
   gradwei = net.params(p).der;   
   if gp
   gradwei = gather(gradwei);    
   end
   grad = [grad; gradwei(:)];
 end
    loss = double(loss);
    grad = double(grad);

end
end


    
            










