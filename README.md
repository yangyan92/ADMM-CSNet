# ADMM-CSNet
# Generic-ADMM-CSNet

***********************************************************************************************************

These are  testing and training codes for Generic-ADMM-CSNet in "ADMM-CSNet: A Deep Learning Approach for Image Compressive Sensing" (TPAMI 2019)
 
If you use thses codes, please cite our paper:

[1] Yan Yang, Jian Sun, Huibin Li, Zongben Xu. ADMM-CSNet: A Deep Learning Approach for Image Compressive Sensing (TPAMI 2019).

http://gr.xjtu.edu.cn/web/jiansun/publications

All rights are reserved by the authors.

Yan Yang -2019/04/10. For more detail or traning data, feel free to contact: yangyan92@stu.xjtu.edu.cn


***********************************************************************************************************



## Data link: 
https://pan.baidu.com/s/1nvf07g_OmMAnFAbhG1orIQ 
passwards：sdsq 


## Usage:

1. Three folders.
  
   1). 'Generic-ADMM-CSNet-ComplexMRI' are testing and training codes to reconstruct complex-valued MR images with 1D Cartesian masks and 2D random masks. <Br/>
   2). 'Generic-ADMM-CSNet-RealMRI' are testing and training codes to reconstruct real-valued MR images with the Pseudo radial mask. <Br/>
   3). 'Generic-ADMM-CSNet-Image' are testing and training codes to reconstruct natural images with the randomly permuted coded diffraction operators and Walsh-Hadamard operators. <Br/>
   
   ## Please do not add these three folders into the path at the same time, because they contain the functions with the same name. 

2. For testing the trained network for a single image.<Br/>
   ('./Generic-ADMM-CSNet-ComplexMRI/main_ADMM_CSNet_test.m')<Br/>
   ('./Generic-ADMM-CSNet-RealMRI/main_ADMM_CSNet_test.m')<Br/>
   ('./Generic-ADMM-CSNet-Image/main_ADMM_CSNet_test.m')<Br/>

	1). Load trained network with different stages in main_ADMM_CSNet_test.m.<Br/>
	    If you apply ADMM-CSNet to  reconstruct  other MR or natural images, it is best to re-train the models.<Br/>

	    E.g., The model './net/NET-1D-Cartesian-0.2-complex-S10.mat' is the ADMM-CSNet with 10 stages trained from 100 complex-valued MR images using 1D Cartesian mask with 20% sampling rate.
		      The model './net/NET-Pseudo-radial-0.2-real-S11.mat' is the network with 11 stages trained from 100 real-valued MR images using Pseudo radial mask with 20% sampling rate.
              The model './net/Net-Diffraction-0.05-S10.mat' is the network with 10 stages trained from 100 real-valued natural images using coded diffraction operator with 5% sampling rate.
 
    2). Load test image  in main_ADMM_CSNet_test.m <Br/>
        The images in './data/Brain_complex_data', './data/Brain_real_data', './data/Image'  are fully-sampled images.<Br/>
    
    3). Load  sampling mask or operator with different sampling ratios in main_ADMM_CSNet_test.m<Br/>

   		E.g., The mask './mask/1D-Cartesian-0.2.mat' is a 1D Cartesian mask with 20% sampling rate.
              The mask './mask/D-0.1.mat' is a coded diffraction operator with 10% sampling rate. 

	4). Network testing  setting (network structure or training setting) is in  'config.m '.<Br/>

	5). To test our ADMM-CSNet, run 'main_ADMM_CSNet_test.m'<Br/>


3. For testing the trained network for our testing dataset.<Br/>
   ('./Generic-ADMM-CSNet-ComplexMRI/AverageTesting.m')<Br/>
   ('./Generic-ADMM-CSNet-RealMRI/AverageTesting.m')<Br/>
   ('./Generic-ADMM-CSNet-Image/AverageTesting.m')<Br/>

	1). Load trained network with different stages in AverageTesting.m.<br>
	    If you apply ADMM-CSNet to  reconstruct  other MR or natural images, it is best to re-train the models.<Br/>

	    E.g., The model './net/NET-1D-Cartesian-0.2-complex-S10.mat' is the ADMM-CSNet with 10 stages trained from 100 complex-valued MR images using 1D Cartesian mask with 20% sampling rate.
		      The model './net/NET-Pseudo-radial-0.2-real-S11.mat' is the network with 11 stages trained from 100 real-valued MR images using Pseudo radial mask with 20% sampling rate.
              The model './net/Net-Diffraction-0.05-S10.mat' is the network with 10 stages trained from 100 real-valued natural images using coded diffraction operator with 5% sampling rate.
 
    2). Set the data_dir of testing dataset ans load the correspongding mask in AverageTesting.m <Br/>

        E.g., data_dir = './data/DATA-1D-Cartesian-0.2-complex-brain/test/' is the testing dataset including 100 complex-valued brain MR image with 20% 1D-Cartesian mask.  
              data_dir = './data/Testingdata/Sdata10/D/D_0.1_1/' is the first testing dataset including 10 standard image with 10% coded diffraction operator.  
              data_dir = './data/DATA-Pseudo-radial-0.2-real-brain/test/'is the testing dataset including 50 real-valued brain MR image with 20% Pseudo radial mask.  

	3). Network testing  setting (network structure or training setting) is in  'config.m '. <Br/>

	4). To test our ADMM-CSNet, run 'AverageTesting.m' <Br/>


4. For re-training the ADMM-CSNets <Br/>

	1). Set the data_dir of training dataset ans load the correspongding mask in L_BFGSnetTrain.m.<br>
    	    
	2). Modify the network setting and trainging setting in  'config.m '. <Br/>

	3). To train ADMM-CSNet by L-BFGS algorithm, run ' L_BFGSnetTrain.m' . <Br/>

	4). After training, the trained network and the training error are saved in './Train_output'.<Br/>



***********************************************************************************************************







