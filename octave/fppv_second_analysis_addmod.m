function [YTWO, YMAGOUT,YFREQOUT ] = fppv_second_analysis_addmod(frames, freqs, MODmag, MODfreq, tsm_factor,fftwo_size, center_freq, bandwidth, center_freq_freq, bandwidth_freq)
% A single fft of each analysis channel.

%MOD = abs(MOD);   % make it just a mag spec.

[numBins, numFrames] = size(frames)
magframes = abs(frames);
phaseframes = angle(frames);
for xincr = 1:fftwo_size / 2  
%freqframes(xincr,:) = unwrap(freqs(xincr,:));
freqframes(xincr,:) = (unwrap((freqs(xincr,:))));  % mod
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
%for xincr = 2 :30
%plot((freqframes(xincr,:)),"b");
%title('Magnitude over time')
%	axis([1 80 -6 2]);
%hold on
%end
%hold off
%pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


MODLONG(1,:) = resample(MODmag(1,:),tsm_factor,1);
[xMOD, yMOD] = size(MODLONG);


center_freq = center_freq * tsm_factor;		% should be in Hz
bandwidth 	= bandwidth * tsm_factor; 		% should be in Hz
center_k  = center_freq;
center_k2 = yMOD - center_k;
bin_on1 	 = center_k - (bandwidth/2);
bin_off1  = center_k + (bandwidth/2) - 1;
bin_on2 	= center_k2 - (bandwidth/2);
bin_off2  = center_k2 + (bandwidth/2) - 1;

center_freq_freq = center_freq_freq * tsm_factor;		% should be in Hz
bandwidth_freq 	= bandwidth_freq * tsm_factor; 		% should be in Hz
center_k  = center_freq_freq;
center_k2 = yMOD - center_k;
bin_on1_freq 	 = center_k - (bandwidth_freq/2);
bin_off1_freq  = center_k + (bandwidth_freq/2) - 1;
bin_on2_freq 	= center_k2 - (bandwidth_freq/2);
bin_off2_freq  = center_k2 + (bandwidth_freq/2) - 1;


for xincr = 1:fftwo_size / 2  
%	waitbar(xincr/(fftwo_size/2) );
	magMODLONG(xincr,:) 				= resample(abs(MODmag(xincr,:)),tsm_factor,1);
	freqMODLONG(xincr,:) 				= resample(abs(MODfreq(xincr,:)),tsm_factor,1);
	Ycomplexmag(xincr,:) 				= (fft(magframes(xincr,[1:yMOD]) ));
	Ymagmag(xincr,:)					= abs(Ycomplexmag(xincr,:));
	Yphasemag(xincr,:)					= angle(Ycomplexmag(xincr,:));
	Ymagmag_unmoded(xincr,:) 			= Ymagmag(xincr,:) ;
	Ycomplexfreq(xincr,:) 				= (fft(freqframes(xincr,[1:yMOD]) ));	% this was wrong. had abs
	Ymagfreq(xincr,:)					= abs(Ycomplexfreq(xincr,:));
	Yphasefreq(xincr,:)					= angle(Ycomplexfreq(xincr,:));
	Ymagfreq_unmoded(xincr,:) 			= Ymagfreq(xincr,:) ;  % for the graphs
	Ymagmag(xincr,[bin_on1:bin_off1])   = 3*magMODLONG(xincr,[bin_on1:bin_off1]);
	Ymagmag(xincr,[bin_on2:bin_off2])   = 3*magMODLONG(xincr,[bin_on2:bin_off2]);
	Ymagfreq(xincr,[bin_on1_freq:bin_off1_freq]) 	= 2*freqMODLONG(xincr,[bin_on1_freq:bin_off1_freq]);
	Ymagfreq(xincr,[bin_on2_freq:bin_off2_freq]) 	= 2*freqMODLONG(xincr,[bin_on2_freq:bin_off2_freq]);
	% maybe i should be using the second order phase of MODmag and MODfreq. Im not now.
% Need to generate some random phase. 
	Ycomplexmag(xincr,:) 	= Ymagmag(xincr,:) .* exp(i*Yphasemag(xincr,:)); 
	Ycomplexfreq(xincr,:)	= Ymagfreq(xincr,:) .* exp(i*Yphasefreq(xincr,:)); 
	Ycomplexmag_unmoded(xincr,:)	= Ymagmag_unmoded(xincr,:) .* exp(i*Yphasefreq(xincr,:));
	Ycomplexfreq_unmoded(xincr,:)	= Ymagfreq_unmoded(xincr,:) .* exp(i*Yphasefreq(xincr,:));
end

%for xincr = 1:12
%plot( real( ifft( Y_no_mod(xincr,:))));
%axis([0 numFrames 0 400])
%hold on
%end
%hold off

%for xincr = 8:12
%plot( real( ifft( Y(xincr,:))));
%axis([0 numFrames 0 400])
%hold on
%end
%pause

%sumY_all_mod = sum(abs(magMODLONG));
%plot(( sumY_all_mod ));
%title('Amp of MOD only')
%	axis([0 3500 0 20000])
%	hold on  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%Ysum = sum(Ycomplexfreq_unmoded);
%plot((abs(Ysum)));
%	title('LONG Sum of First Higher Order Analysis bins')
%	axis([1 600 0 1000000]);
%	hold on
%pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%Ysum = sum(Ycomplexfreq);
%plot((abs(Ysum)));
%	title('LONG Sum of First Higher Order Analysis bins')
%	axis([1 600 0 1000000]);
%	hold on
%pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%plot(abs(Ycomplexmag(10,:)),'LineWidth', 2, "k");
%axis([1 200 0 8000]);
%xlabel('2DFT amplitude spectra in bin number');
%ylabel('Amplitude');
%legend ("off");
%box ("off");
%hold on;

% pause

%hold off;

%sumY_no_mod = sum((Ymagfreq_unmoded));
%plot(( sumY_no_mod ));
%title('Freq Not Modified')
%	axis([0 3500 0 20000])
%	hold on  

%Ymodp = sum(abs(Ymagfreq));
%plot((Ymodp));
%title('mag of Freq spec After Mod is added in')
%axis([0 400 0 20000])
%hold off
%pause



% Now transform back from the second order stuff:

for xincr = 1:fftwo_size / 2  
%waitbar(xincr/(fftwo_size/2) );
YMAGOUT(xincr,:) 	= real(ifft(Ycomplexmag(xincr,:)));	
YFREQOUT(xincr,:) 	= real(ifft(Ycomplexfreq(xincr,:)));	
end

%hold off
%for xincr = 2 :30
%plot((YFREQOUT(xincr,:)),"r");
%title('OUTPUT Frequency over time')
%	axis([1 80 -6 2]);
%hold on
%end
%hold off





[xsizefreqout,ysizefreqout] = size(YFREQOUT)
frames_newphase(:,1) = phaseframes(:,1);
for an_idx =  2: ysizefreqout	  % was to numFrames   yMOD
    an_ddx = an_idx - 1;		
     frames_newphase(:,an_idx) = (  frames_newphase(:,an_ddx) + YFREQOUT(:,an_idx)  );
end

for xincr = 1:fftwo_size / 2  
	YOUT(xincr,:) = YMAGOUT(xincr,:) .* exp(i*frames_newphase(xincr,:));
	%YOUT(xincr,:) = YMAGOUT(xincr,:) .* exp(i*frames_newphase(xincr,[1:yMOD]));
end

YTWO = YOUT;

