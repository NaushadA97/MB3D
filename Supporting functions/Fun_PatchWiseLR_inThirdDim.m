%% Function to perform low rank in the third dimension of the reconstructed 
% set of images (patchwise)
% created: 5 October 2018
function recPatch_mb = Fun_PatchWiseLR_inThirdDim(patchMat,blkLen,b,r)

recPatchMat = Fun_LowRank_onPatchInThirdDim(patchMat,r);
recPatch_mb = reshape(recPatchMat,[blkLen,blkLen,b]);

