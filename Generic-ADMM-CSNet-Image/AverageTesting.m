%% This is a testing code of Generic-ADMM-CSNet for a natural image testing dataset by L-BFGS optimizing.
%% If you use this code, please cite our paper:
%% [1] Yan Yang, Jian Sun, Huibin Li, Zongben Xu. ADMM-CSNet: A Deep Learning Approach for Image Compressive Sensing, TPAMI(2019).
%% Copyright (c) 2019 Yan Yang
%% All rights reserved.


clear;
%clc;
vl_setupnn();
NRMSE = 0;
Psnr = 0;
Ssim = 0;

config;
gp = nnconfig.EnableGPU;

TN = 10;

%------------------loading net and data--------------------------------
load('./net/Net-Diffraction-0.1-S10.mat');
data_dir = './data/Testingdata/Sdata10/D/D_0.1_1/';
%data_dir = './data/Testingdata/Sdata10/H/H_0.3_1/';

for i=1:TN  
     data=getMData_test(i, data_dir);  
     train = real(data.train(:));
     label = data.label;
     picks = data.picks;
     perm = data. perm;
     [nmse, ps , sm, rex ]= loss_with_gradient_single_before(train,label, net, picks, perm);
 
   
     Psnr = Psnr + ps;
     NRMSE = NRMSE + nmse;
     Ssim = Ssim + sm;
            
end
    
  Psnr = Psnr / TN;
  NRMSE = NRMSE / TN;
  Ssim =  Ssim/TN;


fprintf('Average NRMSE is : %f; Average PSNR is: %f, Average SSIM is: %f', NRMSE, Psnr, Ssim)



