function [ loss, grad ] = loss_with_gradient_total( weights, data_dir )
%--------------------Hyper-Parameters---------------------
config;
TN = nnconfig.TrainNumber;
gp = nnconfig.EnableGPU;


net = weiTOnet(weights);
loss=0;

if nargout == 1
    for i=1:TN
        data = getMData_train(i); 
        train = data.train;
        label = data.label;
        if gp
            train = gpuArray(train);
            label = gpuArray(label);
        end
        l = loss_with_gradient_single(train, label , net);
        loss = loss + l;
    end
    loss = loss / TN;
    if gp
        loss = gather(loss);
    end
    
elseif nargout == 2
    grad_length = length(weights);
    grad = zeros(grad_length,1);
    for i=1:TN
        data = getMData_train(i);
        train = data.train;
        label = data.label;
       if gp 
           train = gpuArray(train);
           label = gpuArray(label);
        end
        [l, g] = loss_with_gradient_single(train, label, net);
        loss = loss + l;
        grad = grad + g;
    end
    loss = loss / TN;
    grad = grad / TN;
    
    if gp
        loss = gather(loss);
        grad = gather(grad);
    end
else
    error('Invalid out put number.');
end

end

