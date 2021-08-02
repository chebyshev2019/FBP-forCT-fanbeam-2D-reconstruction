function [Xq, Yq, ydetec] = fan_grid(param)
%ͨ���������ţ��������꣬����������ͶӰ��ͼ��Ķ�Ӧ��ϵ
%��ͶӰ���ؽ��������õ��˸ú���
%���ص�ÿһ��Ϊ�����߾���������
%ydetec������صı����ڷ�ͶӰ��ʱ���д���
%% fan_grid

    % clockwise
    xdetec = param.us.*sind(param.rotate) + param.SDD;
    ydetec = param.us.*cosd(param.rotate);%̽��������

    % sample grid  ���е�Ϊ�������ᣬ��ʵ���꣬x��y��һ��
    Xhrzt = gpuArray.colon(-(param.sx-param.dx)/2,param.dh,(param.sx-param.dx)/2) ...
             + param.SOD;%size��Ϊ(512,1023)
    %��ô����ԭ�������������ģ���ʱ����Դ����Ϊԭ��
    fx = @(x,y) x/sqrt(x^2+y^2);
    fanx = arrayfun(fx, xdetec, ydetec);%����Դ��̽����������Դ��̽�����е�ļн�����
    fany = (ydetec./xdetec).*fanx;%����Դ��̽����������Դ��̽�����е�ļн�����
    param.cosS = fanx;
    param.sinS = fany;
    Xq = bsxfun(@times, fanx, Xhrzt);
    Yq = bsxfun(@times, fany, Xhrzt);
    Xq = bsxfun(@minus, Xq, param.SOD);%��ʱͼ���е�Ϊԭ��
    %���ص�ÿһ��Ϊ���ߵ�·��
return