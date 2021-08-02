function proj = FProj(img, param)
%% FProj
% ͶӰ
[X, Y] = meshgrid(param.xs);%ͼ������ϵ
[Xq, Yq] = fan_grid(param);%����·��

proj = gpuArray.zeros(param.nu, param.nProj);
% forward projection
for i = 1:param.nProj
    proj(:,i) = forwardP(img, i);
end
    %% nested function
    %% forwardP
    function proj = forwardP(data2d, iview)
        % counter clockwise    ̽������˳ʱ����ת��ͼ�����ʱ����ת
        Xprime = Xq.*cosd(iview) - Yq.*sind(iview);
        Yprime = Xq.*sind(iview) + Yq.*cosd(iview);

        data2d_int = interp2(X, Y, data2d, Xprime, Yprime, 'linear', 0);
        proj = param.dh .* sum(data2d_int, 2);%��Ҫ���Ե�λ���߳���

    end

end