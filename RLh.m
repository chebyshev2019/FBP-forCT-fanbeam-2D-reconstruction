% RL - filter
function re = RLh(proj,param)
    N = param.nu;
    filter = 2*[0: (N/2-1), N/2: -1: 1]/N;
    filter = repmat(filter',1,param.nProj);
    re = fft(proj);
    re = re.*filter;
    re = ifft(re);
    re = real(re);
end