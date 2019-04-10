%Hyper-Parameters set
global nnconfig;

nnconfig.StageNum = 10;
nnconfig.w_f = 5;
nnconfig.L = 128;
nnconfig.LinearLabel = double(-1:0.02:1);


nnconfig.ImageSize = [256, 256] ;
nnconfig.DataNumber = 100;
nnconfig.TrainNumber = 1;
nnconfig.DataNumber_valid = 50;
nnconfig.ValidNumber = 25;
nnconfig.TestNumber = 50;


nnconfig.EnableGPU = 1;
nnconfig.WeightDecay = 0.0001;
nnconfig.Theta = 100;              
nnconfig.Clipif = 0;
nnconfig.Modee = 0;




