%%%%parameters set
global nnconfig;
nnconfig.ImageSize = [256, 256] ;
nnconfig.filter_size1 =[5, 5, 1, 128];
nnconfig.filter_size2 = [5, 5, 128, 1];
nnconfig.LinearLabel = double(-1:0.02:1);


nnconfig.StageNum = 10;
nnconfig.EnableGPU =1;
nnconfig.TrainNumber = 1;
%nnconfig.Operator = 'Walsh-Hadamard';
nnconfig.Operator = 'Coded-diffraction';













