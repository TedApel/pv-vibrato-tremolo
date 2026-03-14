% fppv_time_stretch.m
% [Feature Preservation Phase Vocoder]
% Ted Apel 2006-2007
%
% This program does a phase vocoder time-stretch with a noise preservation
% method that separates the noise spectrum from the pitched spectrum.
% The pitched spectrum is processed as normal phase vocoder.
% The noise spectrum is multiplied by noise in the spectral domain.
% The two spectra are added together in the spectral domain and converted
% back to the time-domain.


clear;clf
%zenity_file_selection ("Sound File");
disp("FPPV Dual Noise Stretch");
disp("Ted Apel");
amount_stretch  = 8;
n1				= 16; %512;  if getting modulation make smaller.	% analysis step size in samples.
n2				= n1 * amount_stretch; %2048; %n1;  % synthesis step size in samples.
WLen			= 512 						% window length.
w1				= hanningz(WLen); 				% the analysis window.
w2				= w1;							% the synthesis window.
grain			= zeros(WLen,1);				% define grain.
f1				= zeros(WLen,1);				% define empty past phases1.
f2				= zeros(WLen,1);				% define empty past phases2.
tstretch_ratio 	= n2/n1;						% ratio of stretching.
omega    = 2*pi*n1*[0:WLen-1]'/WLen;			% expected phase advance per bin.
phi0     = zeros(WLen,1);
psi      = zeros(WLen,1);

% analysisframesize = (n1 * 1.5) / 44100

%______ Load in audio
[x_in, FS] = auload(file_in_loadpath("moto.wav"));	% xyloc.wav	noisetone.wav	2930clicks.wav moto.wav noise.wav
x_out = zeros(WLen+ceil(length(x_in)*tstretch_ratio),1); % init output.
L            = length(x_in);
%______ Window segment
tic											% timing.
pin  = 0;									% input point.
pout = 0;									% output point. 
pend = length(x_in)- WLen;					% end point. 

while pin < pend							% loop over each window.
	grain		= x_in(pin+1:pin+WLen).* w1;	% select grain a window.
	f			= fft(fftshift(grain));			% fft of grain.
	r     		= abs(f);
	phi   		= angle(f);
	delta_phi	= omega + princarg(phi-phi0-omega);	
	phi0  		= phi;						% store old phase spectrum.
	psi   		= princarg(psi+delta_phi*tstretch_ratio);		% 
	f_stretch	= (r.* exp(i*psi));			% calculate new time point.
 	outgrain  = fftshift(real(ifft(f_stretch))).*w2;	% ifft grain. 
 	x_out(pout+1:pout+WLen) = x_out(pout+1:pout+WLen) + outgrain; % put grain in out.
	f2		= f1;					% store second past complex spectrum.
	f1		= f;					% store first past complex spectrum.
    pin  	= pin  + n1;			% advance the input point by stepsize. 
    pout	= pout + n2;			% advance the output point by stepsize. 
   end
toc
time = toc
%______ Save sound.
%x_out = x_out(WLen+1:WLen+L) / max(abs(x_out));  % normalize.
soundsc(x_out, FS);		% play.
ausave('moto_stretch_power4.wav', x_out, FS);			% save sound.

