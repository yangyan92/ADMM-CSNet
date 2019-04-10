function net = ADMM_CSNet_init( )
config;
ImageSize = nnconfig.ImageSize;
filter_size1 = nnconfig.filter_size1;
filter_size2 = nnconfig.filter_size2;
Positions = nnconfig.LinearLabel;
stage = nnconfig.StageNum;




net = dagnn.DagNN() ;
NameL = @(x, n) strcat( x,'_', saveName(n, 2));
NameP = @(x, n, p) strcat( x,'_', saveName(n, 2), '_', saveName(p, 1));        



net.addLayer( NameL('Recon',1), ...
                   dagnn.Recon('gp', nnconfig.EnableGPU), ...
                   {'ME', 'noisy'},  NameL('Recon',1), ...
                   {NameP('Recon',1,1)}) ;  
               
               
net.addLayer( NameL('ADD',1), ...
                   dagnn.ADD('ImageSize', ImageSize), ...
                   NameL('Recon',1), NameL('ADD',1)) ; 

net =  ADD_DenoiseNet( net, 1, filter_size1,  Positions,   filter_size2 );
               
               
net.addLayer( NameL('Minus',1), ...
                    dagnn.Minus( ), ...
                    {NameL('ADD',1),   NameL('conv2',1)  },  NameL('Minus',1)) ;    
                           

net.addLayer( NameL('Muliper',1) , ...
                   dagnn.Muliper( ), ...
                   {  NameL('Recon',1)   ,NameL('Minus',1)},  NameL('Muliper',1) , ...
                   {NameP('Muliper',1,1),NameP('Muliper',1,2), NameP('Muliper',1,3)}) ;               

for  s =2 : stage-2 
    
net.addLayer( NameL('Recon',s), ...
                   dagnn.Recon('gp', nnconfig.EnableGPU), ...
                   { 'ME',  'noisy', NameL('Minus',s-1),  NameL('Muliper',s-1) },  NameL('Recon',s), ...
                   {NameP('Recon',s,1)}) ;  
               
               
net.addLayer( NameL('ADD',s), ...
                   dagnn.ADD('ImageSize', ImageSize), ...
                   {NameL('Recon',s),  NameL('Muliper',s-1) }, NameL('ADD',s)) ; 

net =  ADD_DenoiseNet( net, s , filter_size1,  Positions,   filter_size2 );
               
               
net.addLayer( NameL('Minus',s), ...
                    dagnn.Minus( ), ...
                    {NameL('ADD',s),   NameL('conv2',s)  },  NameL('Minus',s)) ;    
                           

 net.addLayer(  NameL('Muliper',s) , ...
                   dagnn.Muliper( ), ...
                   { NameL('Muliper',s-1),  NameL('Recon',s)   ,NameL('Minus',s) },  NameL('Muliper',s) , ...
                   { NameP('Muliper',s,1), NameP('Muliper',s,2), NameP('Muliper',s,3)} );      
    
       
end


s=s+1;
net.addLayer( NameL('Recon',s), ...
                   dagnn.Recon('gp', nnconfig.EnableGPU), ...
                   { 'ME', 'noisy', NameL('Minus',s-1),  NameL('Muliper',s-1) },  NameL('Recon',s), ...
                   {NameP('Recon',s,1)}) ;  
                
               
               
               

               

% loss function
net.addLayer('L2', ...
                   dagnn.NMSE( ), ...
                   { NameL('Recon',s) , 'clean'}, 'L2');
               
 net.initParams() ;
 net.conserveMemory=0;
end 