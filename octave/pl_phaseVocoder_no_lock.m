function synthSignal = pl_phaseVocoder_no_lock(signal, tsm_factor, winSamps)
% A phase locked vocoder time-scale modification algorithm based upon Jean
% Laroche's 1999 work. Also incorporates a Jordi Bonada (2000)
% approach i.e. the same analysis and synthesis hop size. This code started
% out as the code provided by Tae Hong Park, but has changed significantly
% over the years
%
% David Dorran, Audio Research Group, Dublin Institute of Technology
% david.dorran@dit.ie
% http://eleceng.dit.ie/dorran
% http://eleceng.dit.ie/arg
%

% make sure input is mono and transpose if necessary
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
anHopSamps = winSampsPow2/4;
    
win = hanning(winSampsPow2);

X = specgram(signal, winSampsPow2, 44100 ,win, winSampsPow2 - anHopSamps);
        
moduli = abs(X);
phases = angle(X);
        
[numBins, numFrames ] = size(phases);

syn_moduli = zeros(numBins, round(numFrames*tsm_factor) + 1); % a holder for synthesis magnitudes
syn_phases = zeros(numBins, round(numFrames*tsm_factor) + 1); % a holder for synthesis phases

syn_phases(:,1) = phases(:,1); 							% set the phase of the first frame.

syn_idx = 2;
for an_idx =  2: numFrames								% loop  through the analysis frames starting with the second one. 
    an_ddx = an_idx - 1;								% get index to prior analysis spectrum.
    while syn_idx/an_idx <= tsm_factor        			% loop through the new number of frames.
    	syn_ddx = syn_idx - 1;							% get the prior synthesis spectrum.
        phaseInc = phases(:,an_idx) - phases(:,an_ddx); % phase increment between frames
      	syn_phases(:,syn_idx) = syn_phases(:,syn_ddx)+phaseInc(:);		% synthesis phase is prior phase + incriment.
        syn_moduli(:, syn_idx) = moduli(:, an_idx);
        syn_idx = syn_idx + 1;
    end;    
end;

%Make sure that the LHS and RHS of the DFT's of the synthesis frames are a
%complex conjuget of each other
Z = syn_moduli.*exp(i*syn_phases);
Z = Z(1:(numBins),:);
conj_Z = conj(flipud(Z(2:size(Z,1) -1,:)));
Z = [Z;conj_Z];

synthSignal = zeros((syn_idx*anHopSamps) + length(win), 1);

curStart = 1;
for idx = 1:syn_idx-1
    curEnd   = curStart + length(win) - 1;
    rIFFT    = real(ifft(Z(:,idx))); 
    rIFFT	 = [0; rIFFT; 0];
    synthSignal([curStart:curEnd]) = synthSignal([curStart:curEnd]) + rIFFT.*win;
    curStart = curStart + anHopSamps;
end

