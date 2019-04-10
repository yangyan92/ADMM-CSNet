function net1 = addlayer(  )
%ADDLAYER Summary of this function goes here
%   Detailed explanation goes here
net1 = InitNet( );
% n=669;
%  dir='D:\matconvnet-1.0-beta23\examples\ADMMnet_eazy\speedn\L_BFGS\output_9five\net\net-';
%  load (strcat(dir , saveName(n,5)));
n=124;
 dir='/home/jian/yangyan/matconvnet-1.0-beta23/examples/ADMMnet_eazy/speedn/L_BFGS/output_13_five/net/net-';
 load (strcat(dir , saveName(n,5)));
 N = numel(net.layers);
 for n=1:N-1
        
            for d =1:length(net.layers{n}.weights)
       
     net1.layers{n}.weights{d} =   net.layers{n}.weights{d};
        end
 end
    
 
end

