function Ylong = fppv_second_order_stretch(secondframes, fftwo_size, tsm_factor)

tsm_factor = tsm_factor
moduliY = abs(secondframes);
phasesY = angle(secondframes);
[numBins, NewnumFrames] = size(secondframes);
syn_moduliY = zeros(numBins, round(NewnumFrames*tsm_factor) + 1); % a holder for synthesis magnitudes
syn_phasesY = zeros(numBins, round(NewnumFrames*tsm_factor) + 1); % a holder for synthesis phases

syn_phasesY(:,[1:(fftwo_size /2 -1)]) = phasesY(:,[1:(fftwo_size /2 -1)]); 	% set the phase of the first frame.
syn_idx = 2;
thirdNumHops = floor( NewnumFrames / (fftwo_size) ) 	% same number of hops! 
%floor( NewnumFrames / ((winSampsPow2 /2)) )
NewnumFramesStop =  floor(thirdNumHops	-( (fftwo_size ) / (thirdNumHops * fftwo_size) )	-1 ) % place to stop hopping before running off end.

for an_idx =  2: (NewnumFramesStop)						% go through the frames starting with the second one. for an_idx =  2: (secondFrames - 1)		
	an_ddx = an_idx - 1;								% get index to prior analysis spectrum.
	an_idx_num_start 	= (an_idx * fftwo_size) - fftwo_size + 2;
	an_idx_num_end 		= an_idx_num_start + fftwo_size ;
	an_ddx_num_start 	= an_idx_num_start - fftwo_size - 1;
	an_ddx_num_end 		= an_ddx_num_start + fftwo_size;
	while syn_idx/an_idx <= tsm_factor % loop through the new number of frames.
		syn_ddx = syn_idx - 1;		% get the prior synthesis spectrum.
		syn_idx_num_start 	= (syn_idx * fftwo_size) - fftwo_size + 2;
		syn_idx_num_end 	= syn_idx_num_start + fftwo_size;
		syn_ddx_num_start 	= syn_idx_num_start - fftwo_size - 1;
		syn_ddx_num_end 	= syn_ddx_num_start + fftwo_size;
		phaseIncY 			= phasesY(:,[an_idx_num_start: an_idx_num_end]) - phasesY(:,[an_ddx_num_start: an_ddx_num_end]); % phase increment between frames
		syn_phasesY(:,[syn_idx_num_start: syn_idx_num_end]) = syn_phasesY(:,[syn_ddx_num_start: syn_ddx_num_end]) + phaseIncY;		% synthesis phase is prior phase + incriment.
		syn_moduliY(:,[syn_idx_num_start: syn_idx_num_end]) = moduliY(:,[an_idx_num_start: an_idx_num_end]);
		%for i = 1:64
		%plot( syn_phasesY(i,[syn_idx_num_start: syn_idx_num_end]) )
		%end
        syn_idx = syn_idx + 1;
    end;    
end;

Ylong = syn_moduliY.*exp(i*syn_phasesY);


