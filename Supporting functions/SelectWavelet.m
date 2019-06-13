function [Wc,Wr] = SelectWavelet(n1,n2,basis)
% TType- type of transform
% varargin: for EW, it should be: varargin={wavelet name}
TType = basis(1);
if strcmp(TType,'E')==1
    Wc = WaveletMatrix_nL(n1,4,basis{2});
    Wr = WaveletMatrix_nL(n2,4,basis{2});
else
    print('Sorry ! Wavelet name not recognized');
    exit()
end
