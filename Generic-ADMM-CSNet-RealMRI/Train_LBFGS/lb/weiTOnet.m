function net = weiTOnet(wei)
 net = InitNet ();
N=length(net.layers);
id=0;
for n=1:N
l = net.layers{n};
if isfield(l, 'weights')
    for i=1:length(l.weights)
            idp = id + numel(l.weights{i});
            weitemp = wei(id+1:idp);
            aa =  reshape(weitemp, size(l.weights{i}));
            %net.layers{n}.weights{i} = gpuArray(aa) ;
            net.layers{n}.weights{i} = aa;
            id = idp;  
        
       
        
    end
        


end
end



end