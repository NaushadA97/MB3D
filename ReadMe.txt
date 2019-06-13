MB3D_ICASSP2019: ROBUST SUPER-RESOLUTION USING MULTIPLE BASES AND 3D FILTERING
=========================================================================
—————————————————————————————————————————————————————————————————————————
% %% Copyright Naushad Ansari and Weisi Lin, 2019.
% %% Please feel free to use this open-source code for research purposes 
% %% only. 
% %%
% %% Please cite the following paper while using the results:
% %%
% %% N. Ansari, and W. Lin, "Robust Super-resolution using Multiple Bases % %% and 3D Filtering," in IEEE International Conference on Acoustic Speech 
% %% and Signal Processing (ICASSP), 2019. 
—————————————————————————————————————————————————————————————————————————

How to run:
First run the function ‘FileSetup’ that adds all the folders to path 
and then run any of the functions discussed in section (c) in this ReadMe
file.

a. Introduction
---------------

Thank you for downloading MB3D_ICASSP2019. This code is for robust SR using multiple bases and 3D filtering, as presented in [1]. In case of help, please feel free to contact me at: naushadansari09797@gmail.com

b. Description of folders
-------------------------

1. Supporting functions ==> contains supporting functions to be used in 
codes. For example, functions to calculate PSNR, to design sensing matrices,
to perform downsampling etc. 

2. Data ==> this folder contains all the images used in the experiments.

c. Description of functions
---------------------------

1. RobustSR_MB3D: Function for robust SR using MB3D
2. RobustSR_MB3D_foRealrealImages: robust SR using MB3D on real scratched images

d. Supporting code to download:
-------------------------------
This function uses some of the operators from sparco toolbox. Please download:
1. sparco ==> sparco toolbox [3] is used for the some of the operators
like, ‘opWavelet’, ‘opGaussian’. This toolbox can be downloaded from
“http://www.cs.ubc.ca/labs/scl/sparco/“.

e. References:
--------------

[1]. N. Ansari, and W. Lin, "Robust Super-resolution using Multiple Bases and 3D Filtering," in IEEE International Conference on Acoustic Speech and Signal Processing (ICASSP), 2019. 

[2]. E. v. Berg, M. P. Friedlander, G. Hennenfent, F. Herrmann, R. Saab, and
O. Y?lmaz, “Sparco: A testing framework for sparse reconstruction,”
Dept. Computer Science, University of British Columbia, Vancouver,
Tech. Rep. TR-2007-20, October 2007.




