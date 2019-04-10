%% This is a testing code of Generic-ADMM-CSNet for a real-valued MR testing dataset by L-BFGS optimizing.
%% If you use this code, please cite our paper:
%% [1] Yan Yang, Jian Sun, Huibin Li, Zongben Xu. ADMM-CSNet: A Deep Learning Approach for Image Compressive Sensing, TPAMI(2019).
%% Copyright (c) 2019 Yan Yang
%% All rights reserved.


clear;
clc;
vl_setupnn();
loss=0;
psnr=0;
config;
gp = nnconfig.EnableGPU;

TN = 50;

%------------------loading net and data--------------------------------
load('./net/NET-Pseudo-radial-0.2-real-S11.mat');
load('./mask/Pseudo-radial-0.2.mat');
save('mask.mat', 'mask');
data_dir = './data/DATA-Pseudo-radial-0.2-real-brain/test/';



for i=1:TN
    data = getMData_test(i, data_dir);  
    train = data.train;
    label = data.label;
    if gp
        train = gpuArray(train);
        label = gpuArray(label);
    end
       
    [ l , p] = before_yloss_with_gradient_single(train, label , net);
    loss = loss + l;
    psnr = psnr + p;
end


loss = loss/TN;
psnr = psnr/TN;



fprintf('Average loss is : %f; Average psnr is: %f', loss, psnr)



