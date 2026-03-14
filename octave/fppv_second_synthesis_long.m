function Z = fppv_second_synthesis_long(mags2, phases, fftwo_size)
%---------------------------------------------------------------------------

[numBins, numFrames] = size(mags2);
YTWO = zeros(numBins, numFrames);
for xincr = 1:fftwo_size / 2  


	YMAG(xincr,:) = (ifft(mags2(xincr,:)));	
	YTWO(xincr,:) = YMAG(xincr,:).*exp(i*phases(xincr,[1:numFrames]));		
end
Z= YTWO;