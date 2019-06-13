function op = opMyRestriction(n,idx)

if (min(idx) < 1) || (max(idx) > n)
   error('Index parameter must be integer and match dimensions of the operator');
end

op = @(x,mode) opMyRestriction_intrnl(n,idx,x,mode);

function y = opMyRestriction_intrnl(n,idx,x,mode)
m = length(idx);    

% checkDimensions(m,n,x,mode);
if mode == 0
   y = {m,n,[0,1,0,1],{'Restriction'}};
elseif mode == 2
   y = zeros(n,1);
   y(idx) = x;
    
else
   y = x(idx);
end