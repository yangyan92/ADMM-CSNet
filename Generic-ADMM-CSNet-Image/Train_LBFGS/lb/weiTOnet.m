function net = weiTOnet(wei )



net = ADMM_CSNet_init( );
N = length(net.params);


id=0;
for n=1:N    
            idp = id + numel(net.params(n).value);
            weitemp = wei(id+1:idp);
            if 0
            weitemp = gpuArray(weitemp);    
            end
            aa =  reshape(weitemp, size(net.params(n).value));
            net.params(n).value = aa;
            id = idp;         
 end
        

end