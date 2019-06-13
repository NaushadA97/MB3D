% Function for Lp plus Lq (regularization) based SR using sparsifying transform 
% in the regularization. Following problem is solved:
% ||y-Rx||_p+lambda||W x||_q
function [recImg,loss] = Fun_Lp_Lq_usingSparsTrans(y,R,W,n1,n2,lambda,mu1,mu2,p,q,maxIter)

% y is the low resolution image
m = length(y);
n1n2 = n1*n2; % n1 * n2 is the size of the original image

%% Initializations
x = zeros(n1n2,1);
u = zeros(m,1);
v = zeros(n1n2,1);
b1 = zeros(m,1);
b2 = zeros(n1n2,1);

loss = zeros(maxIter,1);

% softThresh = @(inp,T) sign(inp).*max(0,abs(inp)-T);
IPS = @(inp,T,p) sign(inp).*max(0,abs(inp)-T.^(2-p)*abs(inp).^(p-1));

%% Solve iteratively
for iter = 1:maxIter
    
%     if mod(iter,10)==0
%         display(sprintf('------------Iteration#%d------------',iter));
%     end
    
    %% Solve for x
    y1 = [sqrt(mu1)*(u-y-b1);sqrt(mu2)*(v-b2)];
    [x,~] = lsqr(@A1,y1,1e-6,5,[],[],x);
    
    %% Solve for u
    y2 = y-R(x,1)+b1;
    thresh2 = 1/(2*mu1);
    u = IPS(y2,thresh2,p);
    
    %% Solve for v
    y3 = W(x,1)+b2;
    thresh3 = lambda/(2*mu2);
    v = IPS(y3,thresh3,q);
    
    %% Update variables
    b1 = b1-R(x,1)+y-u;
    b2 = b2+W(x,1)-v;
    loss(iter) = (norm(y-R(x,1),p))^p+(lambda*norm(W(x,1),q))^q;
    
end

%% the reconstructed image
recImg = reshape(x,n1,n2);
    

loss = loss(1:iter);

    function y = A1(x,transp_flag)
        if strcmp(transp_flag,'transp')
            y = -sqrt(mu1)*R(x(1:m),2)+sqrt(mu2)*W(x(m+1:end),2);
        else
            y = [-sqrt(mu1)*R(x,1);sqrt(mu2)*W(x,1)];
        end
    end
end
