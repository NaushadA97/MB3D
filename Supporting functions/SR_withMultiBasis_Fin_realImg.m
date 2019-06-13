%% Function to perform SR with multiple basis, where following problem is
% solved using each wavelet
% ||y-R1*Rx||_p+lambda||W x||_q
% created: 18 October 2018
% _Fin: created for final nresults of ICASSP 2019. Weighted average image
% is also generated to compare the results.
% _RealImg: Experiments are performed on real images and hence, no psnr can be returned
% created: 25 October 2018

function [recImg_mb] =...
    SR_withMultiBasis_Fin_realImg(y,R,basis,n1,n2,lambda,mu1,mu2,p,q,maxIter)

parfor b = 1:length(basis)
    
    fprintf('Wavelet Number %d \n',b);
    [Wc,Wr] = SelectWavelet(n1,n2,basis(b,:));
    
    D = opDCT2(n1,n2,1,1);
    W = opRWT_Forward(Wc,Wr,D,n1,n2);
    
    [recImg_mb(:,:,b),~] = Fun_Lp_Lq_usingSparsTrans(y,R,W,n1,n2,lambda,mu1,mu2,p,q,maxIter);
    
end
