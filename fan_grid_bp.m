function [X, Y, ydetecImg] = fan_grid_bp(param)
%% fan_grid
    [X,Y] = meshgrid(param.xs);
    X = X + param.SOD;
    % 每个像素所对应的探测器
    ydetecImg = (Y./ X).*param.SDD;
    % 
return