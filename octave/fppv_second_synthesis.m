function Z = fppv_second_synthesis(secondframes, fftwo_size, second_hop)
%---------------------------------------------------------------------------
% Now we have our second order pv representation
% time to reverse it to the normal pv representation.
[syn_numBins, syn_numFrames ] = size(secondframes);
newlength = ((syn_numFrames / fftwo_size) * second_hop ) + 0
YY = zeros(syn_numBins, newlength); % a holder
curStart = 1;
curStartSyn = 1;
curEnd  = 0;
syn_secondFrames = floor( syn_numFrames / (fftwo_size ) ) - floor(fftwo_size/second_hop)

for yincr = 1:syn_secondFrames    
	curEnd   = curStart + (fftwo_size   ) ;
	curEndSyn = curStartSyn + (fftwo_size  ) ;
	for xincr = 1:syn_numBins   % top column to bottom column.
		YY(xincr,[curStartSyn:curEndSyn]) = YY(xincr,[curStartSyn:curEndSyn]) + ifft(secondframes(xincr,[curStart:curEnd]));			% fft of grain. return complex fft
	%	plot( abs(YY) )
	end
	curStart = curStart + (fftwo_size  );
	curStartSyn = curStartSyn + second_hop;
end
Z = YY;