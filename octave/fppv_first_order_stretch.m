function Yone = fppv_first_order_stretch(frames, win, tsm_factor)

moduli = abs(frames);
phases = angle(frames);
[numBins, numFrames ] = size(phases)

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

Yone = syn_moduli.*exp(i*syn_phases);