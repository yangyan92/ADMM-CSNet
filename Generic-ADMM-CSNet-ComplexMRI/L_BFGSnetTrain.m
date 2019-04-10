%% This is a training code of Generic-ADMM-CSNet for a complex-valued MR training dataset by L-BFGS optimizing.
%% If you use this code, please cite our paper:
%% [1] Yan Yang, Jian Sun, Huibin Li, Zongben Xu. ADMM-CSNet: A Deep Learning Approach for Image Compressive Sensing, TPAMI(2019).
%% Copyright (c) 2019 Yan Yang
%% All rights reserved.

clear all ;
clc;
addpath('./Train_LBFGS/')
addpath('./Train_LBFGS/lb')
addpath('./Train_LBFGS/Matlab')
addpath('./layersfunction/')
addpath('./util')
vl_setupnn();

%% Loading data
data_dir = './data/DATA-1D-Cartesian-0.2-complex-brain/train/';
save('data_dir.mat', 'data_dir');
load('./mask/1D-Cartesian-0.2.mat');
save('mask.mat', 'mask');
%% Network initialization
net = InitNet ( );

%% Initial lossconfig
wei0 = netTOwei(net);
l0 = loss_with_gradient_total(wei0)

%% L-BFGS optimiztion
fun = @loss_with_gradient_total;
%parameters in the L-BFGS algorithm
low = -inf*ones(length(wei0),1);
upp = inf*ones(length(wei0),1);
opts.x0 = double(gather(wei0));
opts.m = 5;
opts.maxIts = 7.2e4;
opts.maxTotalIts = 7.2e4;
opts.printEvery = 1;
opts.factr=1e-50;
opts.pgtol = 1e-50;
[wei1, l1, info] = lbfgsb(fun, low, upp, opts);
wei1=single(wei1);
net1 = weiTOnet(wei1);
fprintf('Before training, error is %f; after training, error is %f.\n', l0, l1);






 





