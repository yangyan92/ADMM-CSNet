
%% This is a testing code demo for ADMM-CSNet reconstruction.
%% Input: a sampled k-space data from a real-valued MR image.
%% Output: a reconstructed MR image, the NRMSE and PSNR over the test images.
%% If you use this code, please cite our paper:
%% [1] Yan Yang, Jian Sun, Huibin Li, Zongben Xu. ADMM-CSNet: A Deep Learning Approach for Image Compressive Sensing, TPAMI(2019).
%% Copyright (c) 2019 Yan Yang
%% All rights reserved.

clc;
clear all;
addpath('./layersfunction/')
addpath('./util')
 
%% Load trained network
load('./net/NET-Pseudo-radial-0.2-real-S11.mat');
%% Load data 
load('./data/Brain_real_data/Brain_rdata1.mat');
load('./mask/Pseudo-radial-0.2.mat');
save('mask.mat', 'mask');
%% Undersampling in the k-space
kspace_full = fft2(im_ori); 
y = (double(kspace_full)) .* (ifftshift(mask));


%% reconstrction by ADMM_CSNet
%tic
[re_LOss, re_PSnr, rec_image] = before_yloss_with_gradient_single(y, im_ori, net);
%Time_Net_rec = toc
Zero_filling_rec = ifft2(y);
figure;
subplot(1,2,1); imshow(abs(Zero_filling_rec)); xlabel('Zero-filling reconstructon result' );
subplot(1,2,2); imshow(abs(rec_image)); xlabel(sprintf('ADMM-CSNet: \n NRMSE=%f', gather(re_LOss)));
imwrite(abs(rec_image),'rec_image.png')


