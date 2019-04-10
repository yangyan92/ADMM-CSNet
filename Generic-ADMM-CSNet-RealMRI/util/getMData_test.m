function data = getMData_test (n, data_dir)
config;
ImageSize = nnconfig.ImageSize ;


data.train = double(zeros(ImageSize));
data.label = double (zeros(ImageSize));
%data_dir = './data/DATA-1D-Cartesian-0.2-complex-brain/test/';

ma = load (strcat(data_dir , saveName(n, 2)));
data.label = double(ma.data.label);
data.train = double(ma.data.train);
end