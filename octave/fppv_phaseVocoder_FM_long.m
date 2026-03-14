% fppv_phaseVocoder_FM_long.m
% [Feature Preservation Phase Vocoder]
% Ted Apel 2006-2007
clear

tsm_factor = 2;
winSamps = 512;  % to try 64, 128, 256, 512, 1024, 2048    
FS = 44100;
fftwo_size = winSamps ;
secondAnHopSamps = fftwo_size / 1;   % 128

%  x_in=wavread("2000.wav"\);   2930.wav  cello.aiff xyloc.wav  bongo_roll.aiff deplus.aiff saxo.wav
[x_in, FS] = auload("mezzo.aiff");
%x_in = x_in_all(1:2048*30);
%plot(abs(fft(x_in)));
 
w= pi/20000;  % 256 4096 8000
q= pi/40;
k=0.8;
len = 60;
  %      x_in([1:2048*len])=(1+(k*cos(w*([1:2048*len])))).*(cos(q*([1:2048*len])));
%        x_one([1:2048*len])=(cos(q*([1:2048*len])));
%		x_two([1:2048*len])=(cos(w*([1:2048*len])));
%		x_in = cos(x_one + x_two);


[y,MOD] = fppv_long_fm_analysis_filter(x_in);
size_of_y = size(y)
%---------------------------------------------------------------------------
%size_of_YY = size(YY)

% Normal PV time-stretch
%synth_stretch = pl_phaseVocoder_no_lock(synth_no_mod, tsm_factor, winSamps);
%soundsc(synth_stretch, FS);		% play.
% Reinsert the modulation MOD
%synthSignal = fppv_long_fm_analysis_addmod(synthSignal);

%synthSignal = pl_phaseVocoder_no_lock(x_in, tsm_factor, winSamps);
synthSignal = y;
soundsc(synthSignal, FS);		% play.
ausave('pl_sounddemoStandard.wav', synthSignal, FS);			% save sound.
% plot(synthSignal);
% pause
