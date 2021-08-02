function [Xq, Yq, ydetec] = fan_grid(param)
%通过数据重排，返回坐标，描述了扇束投影与图像的对应关系
%在投影和重建中两次用到了该函数
%返回的每一行为该射线经过的坐标
%ydetec这个返回的变量在饭投影的时候有大用
%% fan_grid

    % clockwise
    xdetec = param.us.*sind(param.rotate) + param.SDD;
    ydetec = param.us.*cosd(param.rotate);%探测器坐标

    % sample grid  以中点为中心做轴，真实坐标，x轴y轴一致
    Xhrzt = gpuArray.colon(-(param.sx-param.dx)/2,param.dh,(param.sx-param.dx)/2) ...
             + param.SOD;%size变为(512,1023)
    %这么做的原因是物体在中心，此时射线源所在为原点
    fx = @(x,y) x/sqrt(x^2+y^2);
    fanx = arrayfun(fx, xdetec, ydetec);%射线源到探测器与射线源到探测器中点的夹角余弦
    fany = (ydetec./xdetec).*fanx;%射线源到探测器与射线源到探测器中点的夹角正弦
    param.cosS = fanx;
    param.sinS = fany;
    Xq = bsxfun(@times, fanx, Xhrzt);
    Yq = bsxfun(@times, fany, Xhrzt);
    Xq = bsxfun(@minus, Xq, param.SOD);%此时图像中点为原点
    %返回的每一行为射线的路径
return