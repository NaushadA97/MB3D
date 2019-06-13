function op = opMyRestriction_SR(n1,n2,factSR)

op = @(x,mode) opMyRestriction_SR_intrnl(n1,n2,factSR,x,mode);

function y = opMyRestriction_SR_intrnl(n1,n2,factSR,x,mode)

% checkDimensions(m,n,x,mode);
if mode == 0
   y = {n1*n2/(factSR*factSR),n1*n2,[0,1,0,1],{'Restriction'}};
elseif mode == 2
%    y1 = zeros(n1,n2);
%    y1(1:factSR:n1,1:factSR:n2) = reshape(x,n1/factSR,n2/factSR);
%    y = y1(:); 
    y1 = imresize(reshape(x,n1/factSR,n2/factSR),[n1,n2]);
    y = y1(:);
else
%    x1 = reshape(x,n1,n2);
%    y1 = x1(1:factSR:n1,1:factSR:n2);
%    y = y1(:);
    y1 = imresize(reshape(x,n1,n2),[n1/factSR,n2/factSR]);
    y = y1(:);
end