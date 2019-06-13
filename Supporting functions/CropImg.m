%% Function to crop the image to the nearest integer multiple of 'mult', so that 
% WaveletMatrix can be applied
function outImg = CropImg(inImg,mult)

[n1,n2,~] = size(inImg);
n12 = floor(n1/mult)*mult;
n22 = floor(n2/mult)*mult;
outImg = inImg(1:n12,1:n22,:);