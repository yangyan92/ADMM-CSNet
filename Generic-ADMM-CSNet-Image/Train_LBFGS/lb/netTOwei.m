function  wei = netTOwei( net)
config;
gp = nnconfig.EnableGPU;
%net = gather(net);
wei=[];
for n=1:numel(net.params)
    dd = net.params(n).value;
    weight= dd;
    if gp
        weight=gather(dd);
    end
    wei=[wei;weight(:)];           %∞¥¡–≈≈
end
end






