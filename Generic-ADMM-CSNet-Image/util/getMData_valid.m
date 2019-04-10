function data = getMData_valid (n)
% config;
% m = nnconfig.ImageSize ;
% 
% 
% data.train = double(zeros(m,m));
% data.label = double (zeros(m,m));
 dir = './newdata_H_0.2/vaild/';

 load (strcat(dir , saveName(n,5)));
% data.label = double(ma.data.label);
% data.train = double(ma.data.train(:));
end