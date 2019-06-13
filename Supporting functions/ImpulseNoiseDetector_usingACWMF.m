% Function to detect impulse noise from the image using ACWM filter
% First created: 17 August 2018
function idx = ImpulseNoiseDetector_usingACWMF(noisyImg)

[n1,n2] = size(noisyImg);
Flag = ones(n1,n2);
delta = [40,25,10,5]/255;
[~,Flag]=ACWMfilter(noisyImg,Flag,delta);

idx = find(Flag == 0);