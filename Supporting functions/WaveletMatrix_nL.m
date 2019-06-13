function W=WaveletMatrix_nL(N,level,varargin)

if ischar(varargin{1})
    [h,h1,~,~]=wfilters(varargin{1});
else
    h=varargin{1};    h1=varargin{2};
end

W = eye(N);
for i = 1:level
    temp = eye(N);
    temp(1:N/2^(i-1),1:N/2^(i-1)) = WaveletMatrix1L_v2(N/2^(i-1),h,h1);
    W = temp*W;
end
