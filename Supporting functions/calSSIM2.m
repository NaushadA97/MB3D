%% This function calculates the ssim of the image "recImg" with reference to
% the original image "img". boun is the boundary left at the corners for the 
% psnr calculation. "boun" can be taken as 0 in general case.
function ssim = calSSIM2(img,recImg,boun)

img = img(boun+1:end-boun,boun+1:end-boun);
recImg = recImg(boun+1:end-boun,boun+1:end-boun);

ssim = calSSIM(im2uint8(img),im2uint8(recImg));
