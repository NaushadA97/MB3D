%% This function calculates the psnr of the image "recImg" with reference to
% the original image "img". boun is the boundary left at the corners for the 
% psnr calculation. "boun" can be taken as 0 in general case.
% PSNR is calculated as per the Gonzalez book.
% max values of the original image is used for calculating the PSNR

% This function should not be used with an image of uint8 or uint16 as in
% that case, mse will have an upper bound of 255 and 65536 respectively.

% Please note that in MATLAB, getrangefromclass(img) = [0,1], for double
% datadype

% Observation on 16 May 2018: This function is only for the case when the
% image is in the range [0,1]
function psnr=calPSNR2(img,recImg,boun)

img = img(boun+1:end-boun,boun+1:end-boun);
recImg = recImg(boun+1:end-boun,boun+1:end-boun);

mse = sum((double(img(:))-double(recImg(:))).^2)/length(img(:));
% mse=sum(abs((img(:)-recImg(:)).^2))/length(img(:));
maxval = diff(getrangefromclass(img));
% maxval = 255;
% maxval=max(abs(img(:)));
psnr = 10*log10((maxval^2)/mse);
