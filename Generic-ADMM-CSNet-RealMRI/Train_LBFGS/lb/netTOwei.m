function  wei = netTOwei( net)

%net = gather(net);
wei=[];
N=length(net.layers);
for n=1:N
   if isfield(net.layers{n}, 'weights')
       for i=1:length(net.layers{n}.weights)  
           dd = net.layers{n}.weights{i};
           weight= dd;
           if 0
           weight=gather(dd);
           
           end
            wei=[wei;weight(:)];           %∞¥¡–≈≈
       end
   end  
    
end


end

