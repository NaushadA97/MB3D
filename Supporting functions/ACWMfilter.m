function [I,Flag]=ACWMfilter(I,Flag,delta)

s=0.1;
% Expand I
II = padarray(I,[1 1],'symmetric');

% Find out what output type to make.
rows = [0:2]; cols = [0:2];
[m,n]=size(I);

% Apply m-file to each neighborhood of I
%f = waitbar(0,'Applying neighborhood operation...');
for i=1:m,
  for j=1:n,
    x = II(i+rows,j+cols);
    center=x(5);
    
    x = sort(x(:));
    med=x(5);
    d1=abs(med-center);
    
    cwm1=median([x(4),x(6),center]);
    d2=abs(cwm1-center);

    cwm2=median([x(3),x(7),center]);
    d3=abs(cwm2-center);

    cwm3=median([x(2),x(8),center]);
    d4=abs(cwm3-center);

    MAD=median(abs(x-med));
    temp=s*MAD;
    d1=d1-temp;
    d2=d2-temp;
    d3=d3-temp;
    d4=d4-temp;
    
    flag=d1>delta(1)|d2>delta(2)|d3>delta(3)|d4>delta(4);

    if flag==1
        I(i,j) = x(5);
        Flag(i,j) = 0;
        II(i+1,j+1)=I(i,j);
    end
  end
%  waitbar(i/n)
end
%close(f)
