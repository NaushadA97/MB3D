function W=WaveletMatrix1L_v2(N,varargin)

% N=128;
% wavName='db2';
U=zeros(N/2,N);
V=zeros(N/2,N);
u=zeros(1,N);
v=zeros(1,N);

if ischar(varargin{1})
    [h,h1,~,~]=wfilters(varargin{1});
else
    h=varargin{1};    h1=varargin{2};
end
[mlp,dlp]=max(abs(h));
[mhp,dhp]=max(abs(h1));
p=1+(mod(dlp,N));
q=1+(mod(dhp,N));
hrev=wrev(h);
h1rev=wrev(h1);

% u(1,mod(N-mod(N-p+length(hrev),N)+1,N)+1:mod(p,N)+1)=hrev;
% v(1,mod(N-mod(N-q+length(h1rev),N)+1,N)+1:mod(N+q,N)+1)=h1rev;
u(1:length(hrev))=hrev;
% u=circshift(u',N-mod(N-p+length(hrev),N)+1)';
v(1:length(h1rev))=h1rev;
% v=circshift(v',N-mod(N-p+length(hrev),N)+1)';
if size(U,2)<length(h)           % This may happen when W size is 8 by 8 and
                                 % filter length is more, e.g. bior4.4 (LPF
                                 % of length 9
    U(1,:)=u(1:size(U,2));
    V(1,:)=v(1:size(V,2));
else
    U(1,:)=u;
    V(1,:)=v;
end

for i=2:N/2
      
    U(i,:)=circshift(U(i-1,:)',2)';
    V(i,:)=circshift(V(i-1,:)',2)';
end

W=[U;V];