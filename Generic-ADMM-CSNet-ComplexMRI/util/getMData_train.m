function data = getMData_train(n)
config;
ImageSize = nnconfig.ImageSize ;


data.train = double(zeros(ImageSize));
data.label = double(zeros(ImageSize));
%dir = './data/BrainTrain_sampling/';
load('data_dir.mat');
ma = load (strcat(data_dir , saveName(n, 2)));
data.label = double(ma.data.label);
data.train = double(ma.data.train);
end