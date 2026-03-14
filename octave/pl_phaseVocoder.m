function synthSignal = pl_phaseVocoder(signal, tsm_factor, winSamps)
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

X = specgram(signal, winSampsPow2, 100,win, winSampsPow2 - anHopSamps);
        
moduli = abs(X);
phases = angle(X);
        
[numBins, numFrames ] = size(phases);

syn_moduli = zeros(numBins, round(numFrames*tsm_factor) + 1); % a holder for synthesis magnitudes
syn_phases = zeros(numBins, round(numFrames*tsm_factor) + 1); % a holder for synthesis phases

syn_phases(:,1) = phases(:,1); 

syn_idx = 2;
prev_an_idx = 1;
numFrames
for an_idx =  2: numFrames
    an_ddx             = an_idx - 1;
    while syn_idx/an_idx <= tsm_factor        
        syn_ddx = syn_idx - 1;
        
        phaseInc = phases(:,an_idx) - phases(:,an_ddx);  % phase increment between frames

        %locate the peaks
        pk_indices = [];
        pk_indices = locate_peaks(moduli(:,an_idx));             
        
        %update phase of channels in region of influence
        start_point = 1; %initialize the starting point of the region of influence
        for k = 1: length(pk_indices) -1
            peak = pk_indices(k);
          
            syn_phases(peak,syn_idx) = syn_phases(peak,syn_ddx)+phaseInc(peak);%; %synthesis phase
            % first calculate angle of rotation
            angle_rotation = syn_phases(peak,syn_idx) - phases(peak,an_idx);                
            
            next_peak = pk_indices(k+1);
            end_point = round((peak + next_peak)/2);
            ri_indices = [start_point : peak-1, (peak+1) : end_point]; %indices of the region of influence
            syn_phases(ri_indices,syn_idx) = angle_rotation + phases(ri_indices, an_idx);
                  
            start_point = end_point + 1;
        end;          
        
        syn_moduli(:, syn_idx) = moduli(:, an_idx);
        prev_an_idx = an_idx;
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
    size(rIFFT)
    rIFFT	 = [0, rIFFT, 0];
    size(rIFFT)
    synthSignal([curStart:curEnd]) = synthSignal([curStart:curEnd]) + rIFFT.*win;
    curStart = curStart + anHopSamps;
end

%--------------------------------------------------------------------------
function indices = locate_peaks(ip)
%function to find peaks
%a peak is any sample which is greater than its two nearest neighbours
	index = 1;
	num = 2;
    indices = [];
	for k = 1 + num : length(ip) - num
		seg = ip(k-num:k+num);
		[val, max_index] = max(seg);
		if max_index == num + 1
			indices(index) = k;
			index = index + 1;
		end;
	end;