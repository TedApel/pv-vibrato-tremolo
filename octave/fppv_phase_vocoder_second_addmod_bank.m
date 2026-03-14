function [synthSignal] = fppv_phase_vocoder_second_addmod_bank(signal, MODmag, MODfreq, tsm_factor, winSamps, fftwo_size, center_freq, bandwidth, center_freq_freq, bandwidth_freq)
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
win = hanning(winSampsPow2);
X = specgram(signal, winSampsPow2, 44100, win, winSampsPow2 - anHopSamps);
[numBins, numFrames ] = size(X);

%frames_mag = abs(X);
frames_phase = angle(X);
	
for an_idx =  2: numFrames		% loop  through the analysis frames starting with the second one. 
	an_ddx = an_idx - 1;			% get index to prior analysis spectrum.
	frames_freq(:,an_idx) = (princarg(frames_phase(:,an_idx)) - princarg(frames_phase(:,an_ddx)) );
	%frames_freq(:,an_idx) = (frames_phase(:,an_idx) - frames_phase(:,an_ddx) );
	
end;

%------------------------ Begin the second order section --------------------
[Y, YMAGOUT,YFREQOUT ] = fppv_second_analysis_addmod(X, frames_freq, MODmag, MODfreq, tsm_factor, winSampsPow2, center_freq, bandwidth, center_freq_freq, bandwidth_freq);

% Write the sinusoidal alternate version here using: 
% or make an alternate version of this file with alternate method.
% like fppv_phase_vocoder_second_addmod_bank()
% YMAGOUT,YFREQOUT


%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
%pin  = 0;
%pout = 0;
%pend = length(DAFx_in) - WLen;

[syn_numBins, syn_numFramesOverlapped ] = size(Y);
syn_idx = syn_numFramesOverlapped  ;
prev_an_idx = 1;

for idx = 1:syn_idx-15   % cut off some more at the end.
	%grain = DAFx_in(pin+1:pin+WLen).* w1;
%===========================================
	%fc  = fft(fftshift(grain));
	%f   = fc(1:ll);
	r   = 	YMAGOUT(:,idx); 			%abs(f);
	phi = 	YFREQOUT(:,idx);							%angle(f);
	delta_phi = omega + princarg(phi-phi0-omega);
    % now we have the unwrapped difference of phase
    % on each bin for the hop size of n2
	delta_r   = (r-r0)/n1;
	delta_psi = delta_phi/n1;
    % and now we have the increment of phase and of magnitude 
    % to make a linear interpolation and reconstruction
	for k=1:n2
		r0     = r0 + delta_r;
		psi    = psi + delta_psi;
		res(k) = r0'*cos(psi);
        % this tricky line is making the sum of weighted cosine
	end
    %----- for next time ------
	phi0 = phi;
	r0   = r;
	psi  = princarg(psi);
% ===========================================
	synthSignal(pout+1:pout+n2) = synthSignal(pout+1:pout+n2) + res;
	pin  = pin + n1;
	pout = pout + n2;
	end
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU




%Make sure that the LHS and RHS of the DFT's of the synthesis frames are a
%complex conjuget of each other
%Z = syn_moduli.*exp(i*syn_phases);
%Z = YY;
%Z = Z(1:(numBins),:);
%conj_Z = conj(flipud(Z(2:size(Z,1) -1,:)));
%Z = [Z;conj_Z];
%size_of_Z = size(Z)
%synthSignal = zeros((syn_idx*anHopSamps) + length(win), 1);

%curStart = 1;
%curEnd = 1;
%for idx = 1:syn_idx-15   % cut off some more at the end.
%    curEnd   = curStart + length(win) - 1;
%    rIFFT    = real(ifft(Z(:,idx))); 
%    rIFFT	 = [0; rIFFT; 0];		% pad to match window size.
 %   synthSignal([curStart:curEnd]) = synthSignal([curStart:curEnd]) + rIFFT.*win;
%    curStart = curStart + anHopSamps;
%end


