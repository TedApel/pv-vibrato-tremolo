function synthSignal = fppv_phaseVocoder(signal, tsm_factor, winSamps, fftwo_size, secondAnHopSamps)
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
X = specgram(signal, winSampsPow2, 100, win, winSampsPow2 - anHopSamps);
color = ocean();
colormap(color);
imagesc((abs(X)));
[numBins, numFrames ] = size(X);
size_of_X = size(X)

YONE = fppv_first_order_stretch(X, winSamps, tsm_factor);

%------------------------ Begin the second order section --------------------

Y = fppv_second_analysis(X, winSampsPow2, secondAnHopSamps);
size_of_Y = size(Y)

%---------------------------------------------------------------------------
%--------------- Begin the second order time-stretching --------------------
Ylong = fppv_second_order_stretch(Y, winSampsPow2, tsm_factor);
%size_of_Ylong = size(Ylong)
%imagesc(abs(Ylong));
%---------------------------------------------------------------------------
YY = fppv_second_synthesis(Ylong, winSampsPow2, secondAnHopSamps);
size_of_YY = size(YY)
%---------------------------------------------------------------------------
%imagesc([abs(Y);abs(YY)]);

%imagesc(abs(YY));
%---------------------------------------------------------------------------

%---------------------------------------------------------------------------

moduliX = abs(YONE);
phasesYY = angle(YONE);
%moduliX = abs(YY);
%phasesYY = angle(YY);
XYY = moduliX.*exp(i*phasesYY);

%---------------------------------------------------------------------------
%moduli = abs(X);
%phases = angle(X);

%moduli = abs(YY);
%phases = angle(YY);

%syn_moduli = zeros(numBins, round(numFrames*tsm_factor) + 1); % a holder for synthesis magnitudes
%syn_phases = zeros(numBins, round(numFrames*tsm_factor) + 1); % a holder for synthesis phases

%syn_phases(:,1) = phases(:,1); 

%syn_moduli = moduli;			% do nothing.
%syn_phases = phases;			% do nothing.


%syn_idx = 2;
% new line:
%syn_idx = numFrames;
[syn_numBins, syn_numFramesOverlapped ] = size(YY);
syn_idx = syn_numFramesOverlapped  ;


prev_an_idx = 1;

%Make sure that the LHS and RHS of the DFT's of the synthesis frames are a
%complex conjuget of each other
%Z = syn_moduli.*exp(i*syn_phases);
Z = YONE;
%Z = YONE;
%Z = YY;
Z = Z(1:(numBins),:);
conj_Z = conj(flipud(Z(2:size(Z,1) -1,:)));
Z = [Z;conj_Z];
size_of_Z = size(Z)
synthSignal = zeros((syn_idx*anHopSamps) + length(win), 1);
%size(synthSignal)

curStart = 1;
curEnd = 1;
for idx = 1:syn_idx-15   % cut off some more at the end.
    curEnd   = curStart + length(win) - 1;
    rIFFT    = real(ifft(Z(:,idx))); 
    rIFFT	 = [0; rIFFT; 0];		% pad to match window size.
    synthSignal([curStart:curEnd]) = synthSignal([curStart:curEnd]) + rIFFT.*win;
 %   plot(synthSignal)
    curStart = curStart + anHopSamps;
end

