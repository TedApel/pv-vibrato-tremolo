function [YTWO, MODmag, MODfreq] = fppv_second_analysis_long(frames,freqs, fftwo_size, center_freq, bandwidth, center_freq_freq, bandwidth_freq)

% A single fft of each analysis channel.

[numBins, numFrames] = size(frames);
Y = zeros(numBins, numFrames);

magframes = abs(frames);
phaseframes = angle(frames);
%for xincr = 1:fftwo_size / 2  
%freqframes(xincr,:) = unwrap(freqs(xincr,:));
%end


%hold off
%for xincr = 1:fftwo_size / 4
%plot(freqs(xincr,:));
%	hold on
%	title('Frequency trajectories')
% end
%hold off

%for xincr = 1 :10
%sig = (abs(frames(xincr,:)));
%knee = .1;
%[B,A] = butter(4, pi*knee); % high pass digital filter
%blue = filter(B,A,sig);
%plot(blue );
%y = abs(hilbert(abs(frames(xincr,:))));
%plot( y);
%title('Smoothed Magnitude over time')
%hold on
%end
%hold off
%pause

%smoothmagframes = abs(hilbert(abs(frames)));


for xincr = 1:fftwo_size / 2  
%waitbar(xincr/(fftwo_size/2) );
%knee = .1;  % .003
%[B,A] = butter(4, pi*knee); % low pass digital filter
%smoothmagframes(xincr,:) = filter(B,A,frames(xincr,:));


Ycomplexmag(xincr,:) = fft((magframes(xincr,:) ));
%Ycomplexphase(xincr,:) = fft((phaseframes(xincr,:) ));	
Ycomplexfreq(xincr,:) = fft((freqs(xincr,:) ));
%MOD(xincr,:) = Y(xincr,:);
MODmag(xincr,:) = Ycomplexmag(xincr,:);
MODfreq(xincr,:) = Ycomplexfreq(xincr,:);  % Frequency, not phase.

%	Y(xincr,:) = (fft((frames(xincr,:))));	% This is of the complex second order fft. not the fft2 of the mag. abs is missing.
end

%hold off;
%colormap(gray);
%plot(abs(Ycomplexmag(10,[1:numFrames-100])),'LineWidth', 2, "r");
%axis([1 100 0 8000]);
%xlabel('2DFT Amplitude spectra bin number');
%ylabel('Amplitude');
%legend ("on");
%box ("off");
%hold on;
%break
Ycomplexmag_prior = abs(Ycomplexmag);
%hold off
%colormap(gray);
%plot((frames_freq(10,[4:970])),'LineWidth', 2, "k");
%axis([0 1000 0 2]);
%xlabel('Time frame number');
%ylabel('Frequency');
%hold on
%break


% pause

% hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%Ysum = sum(Ycomplexfreq);
%plot((abs(Ysum)));
%	title('Sum of First Higher Order Analysis to remove bins before ')
%	axis([1 20 0 150000]);
%	hold on
%pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Yfreqsum = sum(Ycomplexfreq);
%plot((abs(Yfreqsum)));
%	title('Sum of Frequencies over time')
%	axis([1 80 0 80000]);
%	hold on
%pause
%hold off
%for xincr = 1:100
%	plot(abs(Ycomplexfreq(xincr,:)));
%	title('First Higher Order Analysis to remove bins before modification')
%	axis([0 100 0 600])
%	hold on
%	end
%	pause
%hold off

[xsize, ysize] = size(frames)
center_k  = center_freq;
center_k2 = ysize - center_k + 3;  % mirror bin index.
bin_on 	 = center_k - (bandwidth/2);
bin_off  = center_k + (bandwidth/2) - 1;
bin_on2 	= center_k2 - (bandwidth/2);
bin_off2  = center_k2 + (bandwidth/2) - 1;

center_k_freq  = center_freq_freq;   
center_k2_freq = ysize - center_k_freq + 3;  % mirror bin index.
bin_on_freq		= center_k_freq -  (bandwidth_freq/2);
bin_off_freq	= center_k_freq +  (bandwidth_freq/2) - 1;
bin_on_freq2	= center_k2_freq -  (bandwidth_freq/2);
bin_off_freq2	= center_k2_freq +  (bandwidth_freq/2) - 1;


%win = 1 - hanning(bandwidth);
win = 1 - boxcar(bandwidth);
win_freq = 1 - boxcar(bandwidth_freq);
for xincr = 1:fftwo_size / 2  
Ycomplexmag(xincr,[bin_on:bin_off])   		=  (Ycomplexmag(xincr,[bin_on:bin_off])) .* win';
Ycomplexmag(xincr,[bin_on2:bin_off2]) 		= (Ycomplexmag(xincr,[bin_on2:bin_off2])) .* win';
Ycomplexfreq(xincr,[bin_on_freq:bin_off_freq])   	= (Ycomplexfreq(xincr,[bin_on_freq:bin_off_freq])) .* win_freq';
Ycomplexfreq(xincr,[bin_on_freq2:bin_off_freq2]) 	= (Ycomplexfreq(xincr,[bin_on_freq2:bin_off_freq2])) .* win_freq';
end  

%for xincr = 8:12
%plot( real( ifft( Y(xincr,:))));
%hold on
%end
%hold off
%pause
		
%hold off
%for xincr = 1:150
%	plot(abs(Ycomplexmag(xincr,:)));
%	title('First Higher Order Analysis to remove bins before modification')
%	axis([0 numFrames 0 6500])
%	axis([0 100 0 1600])
%	hold on
%	end
	%pause
%hold off


%colormap(gray);
%plot((Ycomplexmag_prior(10,[1:numFrames-100])),'LineWidth', 2, "k");
%hold on;
%plot(abs(Ycomplexmag(10,[1:numFrames-100])),'LineWidth', 2, "k");
%axis([1 100 0 8000]);
%xlabel('2DFT amplitude spectra in bin number');
%ylabel('Amplitude');
%legend("Before removal", "After removal");
%box ("off");
%hold on;

% pause
 
 
 
%hold on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Ysum = sum(Ycomplexfreq);
%plot((abs(Ysum)));
%title('Sum of First Higher Order Analysis after bins removed')
%axis([0 200 0 100000])
%hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%pause
%Yfreqsum = sum(Ycomplexfreq);
%plot((abs(Yfreqsum)));
%	title('Sum of Frequencies over time after bins removed')
%	axis([1 80 0 80000]);
%	hold on
%pause
%hold off
		
%for xincr = 20:30
%	plot(abs(Y(xincr,:)));
%		title('First Higher Order Analysis after bins removed')
	%axis([0 numFrames 0 6500])    %axis([0 numFrames*2 0 4500])
%		axis([0 200 0 400])
%	hold on
%	end
%	pause
	

for xincr = 1:fftwo_size / 2  
	YMAGOUT(xincr,:) = real(ifft(Ycomplexmag(xincr,:)));	
	YFREQOUT(xincr,:) = real(ifft(Ycomplexfreq(xincr,:)));
	%YPHASEOUT(xincr,:) = real(ifft(Ycomplexphase(xincr,:)));

%	YOUT(xincr,:) = YMAGOUT(xincr,:) .* exp(i*phaseframes(xincr,:)); % try with straight second order phase.
%	YOUT(xincr,:) = smoothmagframes(xincr,:) ;
%	YOUT(xincr,:) = magframes(xincr,:) .* exp(i*frames_newphase(xincr,:));
end

%for xincr = 11 :20
%plot((YFREQOUT(xincr,:)));
%title('Magnitude over time')
%	axis([1 1000 -50 50]);
%hold on
%end
%hold off
%pause



% Now transform back from the second order stuff:
frames_newphase(:,1) = phaseframes(:,1);
for an_idx =  2: numFrames	
    an_ddx = an_idx - 1;								
     frames_newphase(:,an_idx) = (  frames_newphase(:,an_ddx) + YFREQOUT(:,an_idx)  );
end

for xincr = 1:fftwo_size / 2  
	YOUT(xincr,:) = YMAGOUT(xincr,:) .* exp(i*frames_newphase(xincr,:));  % THIS IS THE CORRECT METHOD.
%	YOUT(xincr,:) = YMAGOUT(xincr,:) .* exp(i*phaseframes(xincr,:));	

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

YTWO = YOUT;

