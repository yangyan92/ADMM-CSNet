function [ loss, grad ] = loss_with_gradient_single( train ,label , net )
%--------------------Hyper-Parameters---------------------
config;
LL = nnconfig.LinearLabel;
theta = nnconfig.Theta;
Modee = nnconfig.Modee;
gp = nnconfig.EnableGPU;
clipif = nnconfig.Clipif;


 
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


if nargout == 1
     
    loss = res(end).x;
    loss = double(loss);
   
   
% The backward propagation
elseif  nargout == 2
   res(end).dzdx{1}=1;   
   for i = N : -1 : 1
        l = net.layers{i};
        switch l.type
            case 'rLoss'
                 res(i).dzdx{1} = rnnloss(res(i).x, label , res(i+1).dzdx) ;
            case 'Refinal'      
                 [res(i).dzdx{1}, res(i).dzdx{2},res(i).dzdw{1}] = xfinal( res(i-1).x , res(i).x , train  , l.weights{1} ,  res(i+1).dzdx{1});
            case 'Multi_final'  
                 [res(i).dzdx{1}, res(i).dzdx{2}, res(i).dzdx{3}, res(i).dzdw{1}]  =  betafinal(res(i-6).x , res(i-5).x , res(i).x, l.weights{1}, res(i+1).dzdx{2} );
            case 'MIN'
                 [res(i).dzdx{1}, res(i).dzdx{2}] = Minus (res(i-3).x , res(i).x, res(i+1).dzdx{3},  res(i+2).dzdx{1}      );
            case 'conv'
                 w1 = l.weights{1} ;
                 w2 = l.weights{2} ; 
                 if gp   
                     w1 = gpuArray(w1) ;
                     w2 = gpuArray(w2) ;
                 end
                 [res(i).dzdx, res(i).dzdw{1},res(i).dzdw{2}] = ...
                 vl_nnconv(res(i).x, w1 , w2, res(i+1).dzdx{1}, ...
                'pad', l.pad, ...
                'stride', l.stride, ...
                'dilate', 1) ;    
            case 'Non_linear'
                 r = l.weights{1} ; 
                 if gp
                     r = gpuArray(r)   ;     
                     LL = gpuArray(LL);      
                 end        
                 [res(i).dzdx{1}, res(i).dzdw{1}] = nonlinear( LL , res(i).x , r, res(i+1).dzdx{1});
            case 'relu'
                 if l.leak > 0, leak = {'leak', l.leak} ; else leak = {} ; end
                 if ~isempty(res(i).x)
                    res(i).dzdx{1} = vl_nnrelu(res(i).x, res(i+1).dzdx, leak{:}) ;
                 else
                    res(i).dzdx = vl_nnrelu(res(i+1).x, res(i+1).dzdx, leak{:}) ;
            end
      
        case 'bnorm'
             [res(i).dzdx{1}, res(i).dzdw{1}, res(i).dzdw{2}, res(i).dzdw{3}] = ...
             vl_nnbnorm(res(i).x, l.weights{1}, l.weights{2}, res(i+1).dzdx{1}, ...
                     'epsilon', l.epsilon) ;
             % multiply the moments update by the number of images in the batch
             % this is required to make the update additive for subbatches
             % and will eventually be normalized away
             res(i).dzdw{3} = res(i).dzdw{3} * size(res(i).x,4) ;
        case 'ADD'
             [res(i).dzdx{1}, res(i).dzdx{2}] = Add (res(i).x, res(i-1).x,  res(i+1).dzdx{1},   res(i+4).dzdx{2}    ) ;
        case 'Remid'
             [res(i).dzdx{1}, res(i).dzdx{2}, res(i).dzdw{1}] = xmid (res(i-1).x ,res(i).x, train , l.weights{1} , res(i+1).dzdx{1}, res(i+6).dzdx{2}   );
        case 'Multi_mid'
             [res(i).dzdx{1}, res(i).dzdx{2}, res(i).dzdx{3},res(i).dzdw{1}] = betamid(res(i-6).x , res(i-5).x , res(i).x ,l.weights{1}, res(i+1).dzdx{2}, res(i+2).dzdx{2},res(i+7).dzdx{1} );
        case 'Multi_org'
             [res(i).dzdx{1},  res(i).dzdx{3}, res(i).dzdw{1}] = betaorg(res(i-4).x , res(i).x , l.weights{1},   res(i+1).dzdx{2},  res(i+2).dzdx{2}, res(i+7).dzdx{1} );
        case 'Reorg'
             [ res(i).dzdx, res(i).dzdw{1}] = xorg (res(i).x , l.weights{1}, res(i+1).dzdx{1} ,res(i+4).dzdx{2},res(i+5).dzdx{1});
        case 'c_conv'
             w1 = l.weights{1} ;
             w2 = l.weights{2} ; 
             if gp    
                 w1 = gpuArray(w1) ;
                 w2 = gpuArray(w2) ;
             end
             [res(i).dzdx{1}, res(i).dzdw{1},res(i).dzdw{2}] = ...
             comconv(res(i).x, w1 , w2, res(i+1).dzdx{1}) ; 
            otherwise
                error('No such layers type.');
        end
   end  
    loss=res(end).x;
    grad= [];
    for n=1:N
        if isfield(res(n), 'dzdw')
            for d =1:length(res(n).dzdw)
                gradwei=res(n).dzdw{d};
                if clipif                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%clip
                    sum_diff = sum(abs(gradwei(:)));                                                         
                    if sum_diff > theta
                    gradwei = theta/sum_diff *  gradwei;
                    end   
                 end 
                grad = [grad;gradwei(:)];
            end
        end
    end
    loss = double(loss);
    grad=double(grad);
    else
        error('Invalid output numbers.\n');
end
    

end

    
            










