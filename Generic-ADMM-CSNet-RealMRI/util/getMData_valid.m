function data = getMData_valid (n)
config;
ImageSize = nnconfig.ImageSize ;


data.train = double(zeros(ImageSize));
data.label = double (zeros(ImageSize));
dir = './DATA-0.4-2D-complex-brain/vaid/';

ma = load (strcat(dir , saveName(n, 2)));
data.label = double(ma.data.label);
data.train = double(ma.data.train);
end