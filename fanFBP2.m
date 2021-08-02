function re = fanFBP2(proj,param)
[X,Y] = meshgrid(param.xs);
[theta,rho] = cart2pol(X,Y);
[~,~,ydetec] = fan_grid(param);
degInx = randperm(param.nProj);
re = gpuArray(zeros(param.nx));
% COEFFICIENT
Ratio = param.SOD./sqrt((param.SDD.*ones(param.nu,1)).^2 + ydetec.^2);
proj = proj .* Ratio;
% fliter
proj = RLh(proj,param);
% backprojection
figure(9)
for i = 1:param.nProj
    %
    yLoc = ydetectImg(degInx(i));%param.beta(degInx(i))
    temp = interp1(ydetec,proj(:,degInx(i)),yLoc,'linear',0) ;
    %
    U = (param.SOD + rho .* sin(ones(size(theta)).*param.beta(:,i)*pi/180-theta)) ./ param.SDD;
    %
    re = re + temp.*U;
    imshow(re,[]);pause(0.01)
end
re = finalRotate(re);
%% 图像坐标所对应的探测器坐标
    function [yLoc] = ydetectImg(iview)
        iview = 90 - iview;
        % counter clockwise    探测器的顺时针旋转，图像的逆时针旋转
        Xprime = X.*cosd(iview) - Y.*sind(iview);
        Yprime = X.*sind(iview) + Y.*cosd(iview);
        Xprime = Xprime + param.SOD;
        yLoc = (Yprime./Xprime).*param.SDD;
    end
%% final rotate
    function re = finalRotate(re)
        iview = -90;
        % counter clockwise    探测器的顺时针旋转，图像的逆时针旋转
        Xprime = X.*cosd(iview) - Y.*sind(iview);
        Yprime = X.*sind(iview) + Y.*cosd(iview);
        re = interp2(X,Y,re,Xprime,Yprime,'linear',0);
    end

end