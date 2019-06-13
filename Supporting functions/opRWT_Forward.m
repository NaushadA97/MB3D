% RWT along with DCT. Here, DCT is applied as the operator not as a separable wavelet
% multiplication. opDCT2 is used to implement D
% Forward operation is performed unlike opRWT_CS_Gen2D_v2
% First created: 11 July 2018
function op = opRWT_Forward(Wc,Wr,D,m,n)

op = @(z,mode) opRWT_Forward_intrnl(Wc,Wr,D,m,n,z,mode);


function y = opRWT_Forward_intrnl(Wc,Wr,D,m,n,z,mode)
if mode == 0
    y = {m*n,m*n,[0,1,0,1],{'Restriction'}};
elseif mode==1
    y = Wc*reshape(z,m,n)*Wr';
    y = D(y,1);
else
    y = Wc'*reshape(D(z,2),m,n)*Wr;
    y = y(:);
end
