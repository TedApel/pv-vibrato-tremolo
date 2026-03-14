function [synthSignal, MODmag, MODphase] = fppv_phase_vocoder_second_long(signal, tsm_factor, winSamps, fftwo_size, center_freq, bandwidth, center_freq_freq, bandwidth_freq)
% A phase locked vocoder time-scale modification algorithm based upon Jean
% Laroche's 1999 work. Also incorporates a Jordi Bonada (2000)
% approach i.e. the same analysis and synthesis hop size. This code started
% out as the code provided by Tae Hong Park, but has changed significantly
% over the years
%
%
% fftwo_size = size of the second order fft.

[r, c] = size(signal);
if r > 1
    signal = signal';
end;    
[r, c] = size(signal);
if r > 1
    disp('Note :only works on mono signals');
    synthSignal = [];
    return
end;

% add a few zeros to stop the algorithm failing
zpad = zeros(1, 44100/4);
signal = [signal, zpad];
if nargin < 3
 winSamps = 2048;
end

winSampsPow2 = winSamps; 
anHopSamps = winSampsPow2/4	;	% winSampsPow2 = winSamps;

 omega    = 2*pi*anHopSamps*[0:fftwo_size/2-1]'/fftwo_size/2;
    
win = hanning(winSampsPow2);
[X,f] = (specgram(signal, winSampsPow2, 44100, win, winSampsPow2 - anHopSamps));
%imagesc((abs(X)));
[numBins, numFrames ] = size(abs(X))
smallframes = 64
smallbins = 64
xvec = 1:smallframes;
yvec  = 1:smallbins;
%[xtime, ybin] = meshgrid(xvec,yvec);
zamp([1:smallbins],[1:smallframes])  = abs(X([1:smallbins],[1:smallframes]));
%gset term postscript eps color


%mesh(xvec, yvec, zamp)   % surf mesh
%mesh(xvec, yvec, zamp)   
%view(-30,20);
%colormap("gray");
%xlabel('Frequency [Hz]');ylabel('Time [s]');zlabel('Magnitude [dB]');
%waterfall(xvec, yvec, zamp)   % surf mesh
 %mesh(zamp);
 %xlabel('Time Frame Number');
 %ylabel('Bin Number');
 %zlabel('Amplitude');
%axis ([0 40 0 80 0 30],"labelxyz");
%legend ("off");
%box ("off");
%box ("off");
%grid ("off");
%view([30 28]);  % view([-30 28])
%print("-depsc", "out.pslatex")
%print('spectralframes');
%set�terminal�postscript�eps�rounded
%set�output�'spectralframes.eps'
%gset output "fig.pslatex"
 %pause
 %break


%hold off;
%colormap(gray);
%plot(abs(X(10,:)),'LineWidth', 2, "k");
%xlabel('Time frame number');
%ylabel('Amplitude');
%legend ("off");
%box ("off");
% pause
% break



%hold on;
%break
% can get frequency indicies f out if this also. and time indicies!
%color = ocean();
%colormap(color);

%size_of_X = size(X)
frames_phase = angle(X);
%siseoff = size(f)
[numBins, numFrames ] = size(frames_phase);
%syn_moduli = zeros(numBins, round(numFrames) + 1); % a holder for synthesis magnitudes
%syn_phases = zeros(numBins, round(numFrames) + 1); % a holder for synthesis phases
%syn_phases(:,1) = frames_phase(:,1); 							% set the phase of the first frame.
for an_idx =  2: numFrames								% loop  through the analysis frames starting with the second one. 
    an_ddx = an_idx - 1;								% get index to prior analysis spectrum.
     frames_freq(:,an_idx) = (frames_phase(:,an_idx) - frames_phase(:,an_ddx) );
     % could be using diff command.
%princarg
    %frames_freq(:,an_idx) = unwrap(frames_phase(:,an_idx) - frames_phase(:,an_ddx) ); % phase increment between frames
   % delta_phi(:,an_idx) = omega + princarg(frames_phase(:,an_idx) - frames_phase(:,an_ddx) - omega);
%delta_phi(:,an_idx) = ( princarg(frames_phase(:,an_idx) - frames_phase(:,an_ddx) - omega) );
  %  delta_phi_hz(:,an_idx) =  delta_phi(:,an_idx) /(2*pi*44100) * winSampsPow2 ;  % f' +
%delta_phi(:,an_idx) = unwrap( (frames_phase(:,an_idx)) - (frames_phase(:,an_ddx)) - omega) ; 
%delta_phi(:,an_idx) = unwrap( princarg(frames_phase(:,an_idx)) - princarg(frames_phase(:,an_ddx)) , pi/64) ;
%plot( unwrap(frames_phase(:,an_idx)) -  frames_phase(:,an_ddx));
    % divide this by 2pi RT (where R is the STFT hop size, in samples, and T is the sampling period in seconds.)

end

for xincr = 1:fftwo_size /2
frames_freq(xincr,:) = unwrap( frames_freq(xincr,:) );
end

%hold off
%plot((frames_freq(10,:)));
%colormap(gray);
%plot((frames_freq(10,[4:970])),'LineWidth', 2, "k");
%axis([0 1000 0 2]);
%xlabel('Time frame number');
%ylabel('Frequency');
%hold on
%break

%------------------------ Average of complex spectrum
%aveX = sum(X);
%size(aveX)

%plot(angle(aveX))
%title('phase of average complex values')
%pause

%------------------------ 
% Zero pad the frames to the new length.
%[xsize, ysize] = size(X);
%zpad = zeros(xsize, (tsm_factor-1)*ysize);
%X = [X, zpad];
%frames_mag = abs(X);


%------------------------ Begin the second order section --------------------
[Y, MODmag, MODphase] = fppv_second_analysis_long(X, frames_freq, winSampsPow2, center_freq, bandwidth, center_freq_freq, bandwidth_freq);  % frames_mag
size_of_Y_here = size(Y)
%YY = Y;






% combine mag with original phase
YY = Y;
%YY = Y .* exp(i*frames_phase);  % This is combining with first order phase. not second order phases.
%---------------------------------------------------------------------------
%YY = fppv_second_synthesis_long(Y,frames_phase, winSampsPow2);  % 
size_of_YY = size(YY)
%---------------------------------------------------------------------------
%imagesc([abs(Y);abs(YY)])
%imagesc(abs(YY));
%---------------------------------------------------------------------------
[syn_numBins, syn_numFramesOverlapped ] = size(YY);
syn_idx = syn_numFramesOverlapped  ;
prev_an_idx = 1;
%Make sure that the LHS and RHS of the DFT's of the synthesis frames are a
%complex conjuget of each other
%Z = syn_moduli.*exp(i*syn_phases);
Z = YY;
Z = Z(1:(numBins),:);
conj_Z = conj(flipud(Z(2:size(Z,1) -1,:)));
Z = [Z;conj_Z];
size_of_Z = size(Z)
synthSignal = zeros((syn_idx*anHopSamps) + length(win), 1);

curStart = 1;
curEnd = 1;
for idx = 1:syn_idx
    curEnd   = curStart + length(win) - 1;
    rIFFT    = real(ifft(Z(:,idx))); 
    rIFFT	 = [0; rIFFT; 0];		% pad to match window size.
    synthSignal([curStart:curEnd]) = synthSignal([curStart:curEnd]) + rIFFT.*win;
    curStart = curStart + anHopSamps;
end


