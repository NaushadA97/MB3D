% This code apply low rank on third dimension of the concatenated set of
% image patches. Following (analysis prior) problem is solved:
% min_{X} ||Y-X||_F s.t. rank(X) < k, where k can be 1,2,...
% On patches, created: 5 October 2018
function X = Fun_LowRank_onPatchInThirdDim(Y,r)

[mn,b] =size(Y);

% Low rank of the patches
[U,S,V] = svd(Y);
s = diag(S);
s1 = zeros(b,1);
s1(1:r) = s(1:r);
S1 = diag(s1);
S2 = [S1;zeros(mn-b,b)];
X = U*S2*V';