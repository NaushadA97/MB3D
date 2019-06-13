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
clc;
clear;
close all;

FileSetup;     % Adding folders to the path

%% Paremeters Initializations
lambda = 1; mu1 = 10; mu2 = 10; p = 2; q = 1;
maxIter = 50;   
noiseRat = 5:5:25;
factSR = 2;   % upsampling factor
blkLen = 16;  % to apply 3D filtering 
CropSize = 16; 

allBasis = {'E' 'db1';'E' 'db2';'E' 'db4';'E' 'db10';'E' 'sym6';'E'...
    'sym8';'E' 'sym10';'E' 'bior2.2';'E' 'bior4.4';'E' 'coif4';'E' 'coif5'};
    % All wavelet basis to be used
basisNum = randperm(length(allBasis));  % permuting all bases
basis = allBasis(basisNum,:);

caseType = 'nonIdeal'; % 'Ideal' scenarior or 'nonIdeal'

IPS = @(inp,T,p) sign(inp).*max(0,abs(inp)-T.^(2-p)*abs(inp).^(p-1));  % Iterative p-shrinkage

%% Main processing
strt = tic;
for imNo = 2
    
    rng(1,'twister');
    
    % Set5 Images
    imId = sprintf('Dataset/Set5/img%d.png',imNo);
    
%     % Set10 Images
%     imId = sprintf('Dataset/Set10/img%d.png',imNo);
    
%     % Set14 Images
%     imId = sprintf('Dataset/Set14/img%d.png',imNo);

    % Read image and obtain low resolution image
    inImg = im2double(imread(imId));   % read image and convert to [0,1]
    [n1,n2,~] = size(inImg); 
    if mod(n1,CropSize)~=0 || mod(n2,CropSize)~=0
        orgImg = CropImg(inImg,CropSize);  % crop the image 
    else
        orgImg = inImg;
    end
    
    if size(orgImg,3) == 3
        img = rgb2gray(orgImg);   % Convert to gray image
    else
        img = orgImg;
    end
    
    [n1,n2] = size(img);
    
    % Low resolution image
    n1_lr = n1/factSR;  n2_lr = n2/factSR;  % size for lr image
    R = opMyRestriction_SR(n1,n2,factSR);   % operator DH in the paper
    lr = reshape(R(img(:),1),n1_lr,n2_lr);  % LR image

    % Run for all noise ratios
    for j = 1:length(noiseRat)    
        
        fprintf('Noise ratio %d of image %d is in is process now\n',noiseRat(j),imNo);
        
        %% SR using LpLq
        % For non-ideal case, with ACWMF detector
        if strcmp(caseType,'nonIdeal')
            noisy_lr = addRVImpulseNoise(lr,noiseRat(j));
            idx = ImpulseNoiseDetector_usingACWMF(noisy_lr); % index for corrupted pixels
        elseif strcmp(caseType,'Ideal')
            [noisy_lr,idx] = addRVImpulseNoise_v3(lr,noiseRat(j));
        end
        % For idea case, with ideal detector
        
      
        idx1 = setdiff(1:n1_lr*n2_lr,idx);    % index for non-corrupted pixels
        R1 = opMyRestriction(n1_lr*n2_lr,idx1); % operator to pick non-corrupted pixels
        y = R1(noisy_lr(:),1);    % non-corrupted pixels
        
        R2 = opFoG(R1,R);   % Combination of R1 and R. Download sparco for this.
        
        [recImg_mb_befProc{j,imNo},psnr_mb_befProc(:,j,imNo),ssim_mb_befProc(:,j,imNo)] =...
            SR_withMultiBasis(img,y,R2,basis,n1,n2,lambda,mu1,mu2,p,q,maxIter);

        %% Patch wise filtering on the above reconstructed images
        %% Applying 3D DCT
        b = length(basis);
        r = 1;
        
        lambda_3D = 0.04;
        D = opDCT3(blkLen,blkLen,b);
        
        for i1 = 1:n1/blkLen
            for i2 = 1:n2/blkLen

                patch_mb = recImg_mb_befProc{j,imNo}((i1-1)*blkLen+1:i1*blkLen,(i2-1)*blkLen+1:i2*blkLen,:);
                
                
                % 3-D filtering of patches
                patch_mb_d = D(patch_mb(:),1);  % 3D DCT of the 3D patch
                patch_mb_d_thres = IPS(patch_mb_d,lambda_3D,1);  % thresholding of the 3D patch
                recPatch_mb = reshape(D(patch_mb_d_thres,2),blkLen,blkLen,b); 
                
                % Low rank along the third dimension
                patchMat = reshape(recPatch_mb,[blkLen*blkLen,b]);
                [recPatch_mb,] = Fun_PatchWiseLR_inThirdDim(patchMat,blkLen,b,r);
                
                
                recImg_mb_afterProc{j,imNo}((i1-1)*blkLen+1:i1*blkLen,(i2-1)*blkLen+1:i2*blkLen,:) = recPatch_mb;
            end
        end
       
        % Calculate PSNR and SSIM of the reconstructed images
        for b1 = 1:b
            psnr_mb_afterProc(b1,j,imNo) = calPSNR2(img,recImg_mb_afterProc{j,imNo}(:,:,b1),0);
            ssim_mb_afterProc(b1,j,imNo) = calSSIM2(img,recImg_mb_afterProc{j,imNo}(:,:,b1),0);
            
        end
      
    end
end

tim = toc(strt);

%% This ends the code