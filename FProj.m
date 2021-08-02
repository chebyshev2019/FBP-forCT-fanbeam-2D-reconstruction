function proj = FProj(img, param)
%% FProj
% 投影
[X, Y] = meshgrid(param.xs);%图像坐标系
[Xq, Yq] = fan_grid(param);%射束路线

proj = gpuArray.zeros(param.nu, param.nProj);
% forward projection
for i = 1:param.nProj
    proj(:,i) = forwardP(img, i);
end
    %% nested function
    %% forwardP
    function proj = forwardP(data2d, iview)
        % counter clockwise    探测器的顺时针旋转，图像的逆时针旋转
        Xprime = Xq.*cosd(iview) - Yq.*sind(iview);
        Yprime = Xq.*sind(iview) + Yq.*cosd(iview);

        data2d_int = interp2(X, Y, data2d, Xprime, Yprime, 'linear', 0);
        proj = param.dh .* sum(data2d_int, 2);%需要乘以单位射线长度

    end

end