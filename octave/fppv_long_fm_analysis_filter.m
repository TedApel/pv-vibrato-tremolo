function [y, MOD] = fppv_long_fm_analysis_filter(x_in)
% long fft and removal of low frequency FM components.


Y = fft(x_in);
[xsize,ysize] = size(Y)
plot(abs(Y));
title('Single fft of entire sound')
hold on
axis([0 20000 0 7000])


center_freq = 4002;		% in Hz
bandwidth 	= 3500; 		% in Hz
[xsize, ysize] = size(Y);
%center_k = center_freq * ysize / 44100;
center_k  = center_freq;
center_k2 = xsize - center_k;
bin_on 	 = center_k - (bandwidth/2)
bin_off  = center_k + (bandwidth/2) - 1
bin_on2 	= center_k2 - (bandwidth/2)
bin_off2  = center_k2 + (bandwidth/2) - 1

%win = 1 - hanning(bandwidth);
win = 1 - boxcar(bandwidth);		% This is a temp window.
%size(Y([1:xsize],[bin_on:bin_off]))
[xwinsize,ywinsize] = size(win)
MOD = Y;
%Y([bin_on:bin_off],1)
Y([bin_on:bin_off],1)   = Y([bin_on:bin_off],1) .* win;
%Y([bin_on:bin_off],1)

%Y([bin_on2:bin_off2],1)
Y([bin_on2:bin_off2],1) = Y([bin_on2:bin_off2],1) .* win;
%Y([bin_on2:bin_off2],1)

plot(abs(Y));
title('Single fft of entire sound after modulation removed')
axis([0 20000 0 7000])
pause

y = real(ifft(Y));



