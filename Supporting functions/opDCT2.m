% m,n --> size of the fulll image
% mD,nD --> size of the protion of the image, where DCT needs to be aplied
function op = opDCT2(m,n,mD,nD)

op = @(x,mode) opDCT2_intrnl(m,n,mD,nD,x,mode);

function y = opDCT2_intrnl(m,n,mD,nD,x,mode)
if mode == 0
   y = {n*m,n*m,[0,1,0,1]};
elseif  mode == 1
    y = reshape(x,m,n);
    d2 = dct2(y(1:mD,1:nD));
    y(1:mD,1:nD) = d2;
    y = y(:);
else
    y = reshape(x,m,n);
    id2 = idct2(y(1:mD,1:nD));
    y(1:mD,1:nD) = id2;
    y = y(:);
end
