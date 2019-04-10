%% This is a testing code demo for ADMM-CSNet reconstruction.
%% Input: a sampled  data from a natural image.
%% Output: a reconstructed image, the NRMSE and PSNR over the test images.
%% If you use this code, please cite our paper:
%% [1] Yan Yang, Jian Sun, Huibin Li, Zongben Xu. ADMM-CSNet: A Deep Learning Approach for Image Compressive Sensing, TPAMI(2019).
%% Copyright (c) 2019 Yan Yang
%% All rights reserved.

clc;
clear all;
addpath('./layersfunction/')
addpath('./util')
 
%% Load trained network
load('./net/Net-Diffraction-0.1-S10.mat');
%load('./net/Net-Hadamard-0.1-S10.mat.mat');
%% Load data 
load('./data/Image/Image4.mat');
load('./mask/D-0.1.mat');
config;
size = nnconfig.ImageSize;
%% Undersampling 
[A, At] = generate_D (mask.picks, mask.perm);
y = A (im_ori(:));
x0 =  At(y); 

%% reconstrction by ADMM_CSNet
%tic
[re_LOss, re_PSnr , re_SSim, rec_image ]= loss_with_gradient_single_before(x0,  im_ori,  net, mask.picks, mask.perm);
%Time_Net_rec = toc
Zero_filling_rec = reshape(x0, size);
figure;
subplot(1,2,1); imshow(real(Zero_filling_rec),[]); xlabel('Zero-filling reconstructon result' );
subplot(1,2,2); imshow(abs(rec_image),[]); xlabel(sprintf('ADMM-CSNet: \n NRMSE=%f', gather(re_LOss)));
imwrite(abs(gather(rec_image)),'rec_image.png')


