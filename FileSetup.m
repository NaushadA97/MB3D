% Code to add folders in the path
root = fileparts(which(mfilename));
fprintf('Adding folder: ''%s'' to the path \n ','Supporting functions')
addpath([root filesep 'Supporting functions']);

fprintf('Adding folder: ''%s'' to the path \n ','Dataset')
addpath([root filesep 'Dataset']);