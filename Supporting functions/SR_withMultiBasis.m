%% Function to perform SR with multiple basis, where following problem is
% solved using each wavelet
% ||y-R1*Rx||_p+lambda||W x||_q
% created: 18 October 2018
% _Fin: created for final results of ICASSP 2019.

function [recImg_mb,psnr_mb,ssim_mb] =...
    SR_withMultiBasis(orgImg,y,R,basis,n1,n2,lambda,mu1,mu2,p,q,maxIter)

parfor b = 1:length(basis)
    
    fprintf('Wavelet Number %d \n',b);
    [Wc,Wr] = SelectWavelet(n1,n2,basis(b,:));
    
    D = opDCT2(n1,n2,1,1);
    W = opRWT_Forward(Wc,Wr,D,n1,n2);
    
    [recImg_mb(:,:,b),~] = Fun_Lp_Lq_usingSparsTrans(y,R,W,n1,n2,lambda,mu1,mu2,p,q,maxIter);
    psnr_mb(b) = calPSNR2(orgImg,recImg_mb(:,:,b),0);
    ssim_mb(b) = calSSIM2(orgImg,recImg_mb(:,:,b),0);
    
end
