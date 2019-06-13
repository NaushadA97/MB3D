
%% Robust SR (in the presence of impulse noise) with multiple bases followed 
% by 3-D filtering (MB3D). 
% Please see the following paper for more details
% N. Ansari, and W. Lin, "Robust Super-resolution using Multiple Bases 
% and 3D Filtering," in IEEE International Conference on Acoustic Speech 
% and Signal Processing (ICASSP), 2019.

% SR is performed using L2+L1, 
% ||y-R1*Rx||_p+lambda||W x||_q
% where R1 is the detector containing the locations of all non corrupted
% pixels detected by ACWM filter, and R is the downsampling operator.

% After reconstruction with several basis, the image patches are stacked as vectors 
% in a matrix and finally, 3-D filtering is applied.
% 3-D filtering is applied by taking 3-D transform, applying soft or hard
% thresholding and then applying inverse 3-D transform.
% Following parameters are used: lambda = 1, mu1 = 10, mu2 = 10 as they are
% found optimal.
% created: 18 October 2018.

% _real: Experiments performed on real images
% Best value = 2.8 for lena512_my4
% Best value = 2.6 for House_scratched2
% Best value = 1.8 for House_scratched3
clc;
clear;
close all;

FileSetup;     % Adding folders to the path

%% Paremeters Initializations
% lambda = 1.5;
allLambda = 1.8:0.2:4;
mu1 = 10;
mu2 = 10;
p = 2;
q = 1;
maxIter = 50;
factSR = 2;
blkLen = 16;
CropSize = 16;

allBasis = {'E' 'db1';'E' 'db2';'E' 'db4';'E' 'db10';'E' 'sym6';'E'...
    'sym8';'E' 'sym10';'E' 'bior2.2';'E' 'bior Khu4.4';'E' 'coif4';'E' 'coif5'};
basisNum = randperm(length(allBasis));
% basisNum = 1:length(allBasis);
basis = allBasis(basisNum,:);

IPS = @(inp,T,p) sign(inp).*max(0,abs(inp)-T.^(2-p)*abs(inp).^(p-1));

%% Main processing
strt = tic;
for imNo = 1
    
    rng(1,'twister');
    
    % Real images
    imId = sprintf('Dataset/RealImages/img%d.png',imNo);
    noisyImg = im2double(imread((imId)));
    
    [n1_lr,n2_lr] = size(noisy_lr);
    n1 = n1_lr*factSR; n2 = n2_lr*factSR;
    
    % Low resolution image
    R = opMyRestriction_SR(n1,n2,factSR);
    
    idx = ImpulseNoiseDetector_usingACWMF(noisy_lr);
    idx1 = setdiff(1:n1_lr*n2_lr,idx);
    R1 = opRestriction(n1_lr*n2_lr,idx1);
    y = R1(noisy_lr(:),1);
    
    R2 = opFoG(R1,R);
    
    for j = 1:length(allLambda)
        lambda = allLambda(j);
        [recImg_mb_befProc{j,imNo}] = SR_withMultiBasis_Fin_realImg(y,R2,basis,n1,n2,...
            lambda,mu1,mu2,p,q,maxIter);
        
        %% Patch wise filtering
        %% Applying 3D DCT
        r = 1;
        b = length(basis);
        lambda_3D = 0.04;
        D = opDCT3(blkLen,blkLen,b);
        
        for i1 = 1:n1/blkLen
            for i2 = 1:n2/blkLen
                patch_mb = recImg_mb_befProc{j,imNo}((i1-1)*blkLen+1:i1*blkLen,(i2-1)*blkLen+1:i2*blkLen,:);
                
                
                % 3-D filtering of patches
                patch_mb_d = D(patch_mb(:),1);
                patch_mb_d_thres = IPS(patch_mb_d,lambda_3D,1);
                recPatch_mb = reshape(D(patch_mb_d_thres,2),blkLen,blkLen,b);
                
                % Low rank along the third dimension
                patchMat = reshape(recPatch_mb,[blkLen*blkLen,b]);
                [recPatch_mb]...
                    = Fun_PatchWiseLR_inThirdDim(patchMat,blkLen,b,r);
                
                
                recImg_mb_afterProc{j,imNo}((i1-1)*blkLen+1:i1*blkLen,(i2-1)*blkLen+1:i2*blkLen,:) = recPatch_mb;
            end
        end
        figure; imshow(recImg_mb_afterProc{j,imNo}(:,:,3));
    end
    
end

tim = toc(strt);

%% This ends the code