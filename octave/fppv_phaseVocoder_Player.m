% fppv_phaseVocoder_Player.m
% [Feature Preservation Phase Vocoder]
% Ted Apel 2006-2007
clear

tsm_factor = 2;
winSamps = 512;  % to try 64, 128, 256, 512, 1024, 2048    
FS = 44100;
fftwo_size = winSamps ;
%secondAnHopSamps = fftwo_size / 4;   % 128

%  x_in=wavread("2000.wav"\);   2930.wav  cello.aiff xyloc.wav  bongo_roll.aiff deplus.aiff saxo.wav
[x_in, FS] = auload("saxo.wav");
%x_in = x_in_all(1:2048*100);
%plot(abs(fft(x_in)));
 
w= pi/60;  % 256 4096 8000
q= pi/8000;
k=0.8;
%for n=1:2048*30
%   x_in(n)=(1+(k*cos(w*(n))))*(cos(q*(n)));
  % x_in(n)=(cos(q*(n))) + (cos(q*2*(n))) + (cos(q*3*(n)));
   %  x_in(n)= .5 * (cos(q*(n))) + 1.0 *(cos(w*(n)))  ;
%end
%len = 60;
% x_in([1:2048*len])=(cos(w*([1:2048*len])));
%    x_in([1:2048*len])=(.5+(k*cos(q*([1:2048*len])))).*(cos(w*([1:2048*len])));
       % x_one([1:2048*len])=(cos(q*([1:2048*len])));
		%x_two([1:2048*len])=(cos(w*([1:2048*len])));
		%x_in = sin(x_one + x_two);
		%plot(x_in)
		%x_in = x_one;
%x_in(n)=(cos(2*pi*q*[1:2048*10])) ;  % faster sine wave generation.

sf = 44100;                    % sample frequency (Hz)
d = 3.0;                       % duration (s)
n = sf * d;                    % number of samples
% set carrier
cf = 1000;                     % carrier frequency (Hz)
c = (1:n) / sf;                % carrier data preparation
c = 2 * pi * cf * c;
% set modulator
mf = 4;                        % modulator frequency (Hz) 
mi = 2.5;  % .5                     % modulator index
m = (1:n) / sf;                % modulator data preparation
m = mi * cos(2 * pi * mf * m); % sinusoidal modulation
% frequency modulation

%Amplitude Modulation
%sf = 44100;                        % sample frequency (Hz)
%d = 3;                           % duration (s)
%n = sf * d;                        % number of samples

% set carrier
%cf = 440;                         % carrier frequency (Hz)
%c = (1:n) / sf;                    % carrier data preparation
%c = sin(2 * pi * cf * c);          % sinusoidal modulation

% set modulator
%mf = 4;                            % modulator frequency (Hz)
%mi = 1;      %  0.5;                     % modulator index
%m = (1:n) / sf;                    % modulator data preparation
%m = 1 + mi * sin(2 * pi * mf * m); % sinusoidal modulation

% amplitude modulation
%s = m .* c;                        % amplitude modulation
%x_in = s;

%   x_in = sin(c + m);                % frequency modulation

%colormap(gray);
%plot(x_in, 'LineWidth', .1, "k");
%axis([0 3.1*44100 -1 1 ]);
%xlabel('Time in seconds');
%ylabel('Amplitude');
%set (gca, "xtick", [44100,2*44100,3*44100])
%set (gca, "xticklabelmode", "Manual") 
%set (gca, "xticklabel", ['1'; '2'; '3']) 
%pause(.001);
%break


%modulation = (1+(k*cos(w*([1:2048*len]))));
%plot(abs(fft(  modulation  )));
%pause
%break
%x_in = [x_in ; x_in ;x_in; x_in ; x_in ; x_in ; x_in ; x_inx_in ; x_in ;x_in; x_in ; x_in ; x_in ; x_in ; x_in] ;
%soundsc(x_in, FS);		% play.

%ausave('inputsound.wav', x_in, FS);			% save sound.

%plot(x_in);
%pause
%x_in = x_in + (.2 * (rand(1,2048*10)));
%size(x_in)

%%[a,f,t,p] = instf(x_in,FS,winSampsPow2,winSampsPow2 - anHopSamps)

center_freq 		= 16  			% good is 16 and 6 
bandwidth 			= 6			% 8  % Try six  6  For amp mod 28 and 18
center_freq_freq 	= 16  			%
bandwidth_freq 		= 6			% 

[synth_no_mod, MODmag, MODfreq] = fppv_phase_vocoder_second_long(x_in, tsm_factor, winSamps, fftwo_size, center_freq, bandwidth, center_freq_freq, bandwidth_freq);
%sound(synth_no_mod, FS);                           %soundsc(synth_no_mod, FS);		% play.
ausave('sing_mod_removed.wav', synth_no_mod, FS);			% save sound.
% Normal PV time-stretch


 

[xsize,ysize] = size(synth_no_mod)
%plot(synth_no_mod)
%synth_no_mod2 = synth_no_mod([1: xsize / (tsm_factor)],1);
%[xsize2,ysize2] = size(synth_no_mod2)
%plot(synth_no_mod2)
%synth_stretch = pl_phaseVocoder_no_lock(x_in, tsm_factor, winSamps);
synth_stretch = pl_phaseVocoder_no_lock(synth_no_mod, tsm_factor, winSamps);
%soundsc(synth_stretch, FS);		% play.\
ausave('sing_mod_removed_long.wav', synth_stretch, FS);			% save sound.



[xsynthstretch, ysynthstretch] = size(synth_stretch)

% add zeros to make the length exactly twice or tsm factor longer.
%size_pad = xsynthstretch - (xsize * 2);
%stretch_pad = zeros(1,size_pad)
	%	synth_stretch2 = synth_stretch([1:(xsize*tsm_factor)],1) ;
	%	[xsynthstretch2, ysynthstretch2] = size(synth_stretch2)
% Reinsert the modulation MOD
% synth_stretch
synthSignal = fppv_phase_vocoder_second_addmod(synth_stretch, MODmag, MODfreq, tsm_factor, winSamps, fftwo_size, center_freq, bandwidth, center_freq_freq, bandwidth_freq);
%soundsc(synthSignal, FS);		% play.

ausave('LongMODED.wav', synthSignal, FS);			% save sound.
% plot(synthSignal);
% pause

colormap(gray);
plot(synthSignal, 'LineWidth', .1, "k");
axis([0 6.1*44100 -1 1 ]);
xlabel('Time in seconds');
ylabel('Amplitude');
set (gca, "xtick", [44100,2*44100,3*44100,4*44100,5*44100,6*44100])
set (gca, "xticklabelmode", "Manual") 
set (gca, "xticklabel", ['1'; '2'; '3':'4';'5';'6']) 
pause(.001);




%plot(synthSignal, 'k');
%axis([0 6.8*44100 -1 1 ]);
%tics('x',[44100,2*44100,3*44100,4*44100,5*44100,6*44100 ],['1';'2';'3':'4';'5';'6'])
%legend ("off");
%box ("off");
%xlabel('Time in seconds');
%ylabel('Amplitude');
%pause
%break
