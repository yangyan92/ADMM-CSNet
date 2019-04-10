function [ loss, ps, xx ] = before_yloss_with_gradient_single( train ,label , net )
%--------------------Hyper-Parameters---------------------
config;
LL = nnconfig.LinearLabel;

Modee = nnconfig.Modee;
gp = nnconfig.EnableGPU;



 
N = numel(net.layers);
res = struct(...
            'x',cell(1,N+1),...
            'dzdx',cell(1,N+1),...
            'dzdw',cell(1,N+1));

res(1).x = train;

% The forward propagation
for i = 1 : N
    l = net.layers{i};
    switch  l.type
       case 'Reorg'
            res(i+1).x = xorg(res(i).x , l.weights{1});
       case 'MIN'
            res(i+1).x = Minus(res(i-3).x , res(i).x) ;
       case 'Multi_org'
            res(i+1).x = betaorg(res(i-4).x , res(i).x , l.weights{1});
       case 'Multi_mid'
            res(i+1).x = betamid(res(i-6).x , res(i-5).x , res(i).x ,l.weights{1});
       case 'Multi_final'
            res(i+1).x = betafinal(res(i-6).x , res(i-5).x , res(i).x, l.weights{1});          
       case 'ADD'
            res(i+1).x = Add (res(i).x, res(i-1).x) ;
       case 'Remid'
            res(i+1).x = xmid (res(i-1).x ,res(i).x,train, l.weights{1});
       case 'Refinal'
            res(i+1).x = xfinal (res(i-1).x ,res(i).x, train, l.weights{1});
       case 'c_conv'
            w1 = l.weights{1} ;
            w2 = l.weights{2} ; 
            if gp
                w1 = gpuArray(w1) ;
                w2 = gpuArray(w2) ;
            end
            res(i+1).x = comconv(res(i).x, w1, w2) ; 
       case 'conv'
            w1 = l.weights{1} ;
            w2 = l.weights{2} ; 
            if gp
                w1 = gpuArray(w1) ;
                w2 = gpuArray(w2) ;
            end
         
            res(i+1).x = vl_nnconv(res(i).x, w1, w2, ...
                                  'pad', l.pad, ...
                                  'stride', l.stride, ...
                                  'dilate', 1 ) ;
       case 'Non_linear'
            r = l.weights{1} ; 
            if gp
               r = gpuArray(r);     
               LL = gpuArray(LL);   
            end        
            res(i+1).x = nonlinear( LL , res(i).x , r);
       case 'relu'
             if l.leak > 0, leak = {'leak', l.leak} ; else leak = {} ; end
             res(i+1).x = vl_nnrelu(res(i).x,[],leak{:}) ;
       case 'bnorm'
             if Modee     %%%test mode
               res(i+1).x = vl_nnbnorm(res(i).x, l.weights{1}, l.weights{2}, ...
                                'moments', l.weights{3}, ...
                                'epsilon', l.epsilon) ;
             else
               res(i+1).x = vl_nnbnorm(res(i).x, l.weights{1}, l.weights{2}, ...
                                'epsilon', l.epsilon ) ;
              end

      case 'rLoss'
      res(i+1).x = rnnloss(res(i).x, label) ;

       otherwise
            error('No such layers type.');
    end
    
end


   loss = res(end).x;
   
    loss = double(loss);
    xx = res(end-1).x;
    xx = gather(xx);
    label = gather(label);
    ps = psnr(abs(xx), abs(label));
    

end

    
            










