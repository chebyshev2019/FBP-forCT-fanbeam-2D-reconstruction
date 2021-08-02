% MAIN
% 2021-7-25
% LHY
clear;clc;close all
%% test

%%
Parameter;
img = phantom('Modified Shepp-Logan',512);
proj = FProj(img,param);
figure;imshow(proj,[])
re = fanFBP2(proj,param);
figure;imshow(re,[]);title('FBP_fan')