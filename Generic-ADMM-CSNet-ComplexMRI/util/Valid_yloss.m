function loss = Valid_yloss( net)

loss=0;
config;
VN=nnconfig.ValidNumber;


    for i=1:VN
        data=getMData_valid(i);  
        train = data.train;
        label = data.label;
        train = gpuArray(train);
        label = gpuArray(label);
       
         l = loss_with_gradient_single(train,label, net);
        loss = loss + l;
    end
    loss = loss / VN;
    loss = gather(loss);
    
    

end



