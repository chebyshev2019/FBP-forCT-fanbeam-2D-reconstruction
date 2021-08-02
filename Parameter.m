% IPCD
%% param
% Image setting (system)
param.nx = 512; % number of pixels
param.sx = 144; % mm (real size of the image, also the diameter of the FOV)
param.dx = param.sx/param.nx; % single pixel size

% The real detector panel pixel density (number of pixels)
param.nu = 900; % number of detector unit
% Detector setting (real size)
param.su = 180; % mm (real size)
param.du = param.su/param.nu;

param.dh = 0.5*param.dx; % sample distance of ray

% X-ray source and detector setting
param.SDD = 1200;    %  Distance source to detector 
param.SOD = 981;    %  X-ray source to object axis distance

param.off_u = 0; % detector rotation shift (real size)
param.rotate = 0;

% angle setting
% param.dir = -1;   % gantry rotating direction (clock wise/ counter clockwise)
param.dang = 1; % angular step size (deg)
% 0 degree is suggested for the X ray source is on the left horizontal axis,
% assume the gantry rotate clockwise by default.
param.deg = 1:param.dang:360;
% param.deg = -60:param.dang:60;
% param.deg = param.deg*param.dir;
param.nProj = length(param.deg);

% data with 360 deg -> param.parker = 0 , data less than 360 deg -> param.parker=1 
% param.parker = 0; 

% % % Geometry calculation % % %
% param.detec_origin = (param.su-param.du)/2;
% param.img_origin = (param.sx-param.dx)/2;
param.xs = gpuArray.colon(-(param.sx-param.dx)/2,param.dx,(param.sx-param.dx)/2);
param.us = gpuArray.colon(-(param.su-param.du)/2,param.du,(param.su-param.du)/2) ...
            + param.off_u;
param.us = (param.us).';
%% param radon grid
%Ì½²âÆ÷×ø±ê
xdetec = param.us.*sind(param.rotate) + param.SDD;
ydetec = param.us.*cosd(param.rotate);
% Clockwise is positive and counterclockwise is negative along the Y axis
param.beta = (param.nProj/4-1):-1:-(param.nProj*3/4);
% Clockwise is positive and counterclockwise is negative along the param.SOD axis
fx = @(x,y) x/sqrt(x^2+y^2);
fanx = arrayfun(fx, xdetec, ydetec);
fany = (ydetec./xdetec).*fanx;
param.gamma = asind(fany);
