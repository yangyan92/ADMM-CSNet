function loss = Valid_yloss( net)

loss=0;
config;
VN=nnconfig.ValidNumber;


    for i=1:VN
        data=getMData_valid(i);  %%%%%%%%%%%
        train = real(data.train(:));
        label = data.label;
         picks = data.picks;
         perm = data. perm;
         l = yloss_with_gradient_single(train,label, net, picks, perm);
        loss = loss + l;
    end
    
    loss = loss / VN;
    loss = gather(loss);
    
    

end



