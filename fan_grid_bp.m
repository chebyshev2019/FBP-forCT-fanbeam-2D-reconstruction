function [X, Y, ydetecImg] = fan_grid_bp(param)
%% fan_grid
    [X,Y] = meshgrid(param.xs);
    X = X + param.SOD;
    % ÿ����������Ӧ��̽����
    ydetecImg = (Y./ X).*param.SDD;
    % 
return