function YTWO = fppv_second_analysis(frames, fftwo_size, second_hop)

% fftwo_size = not used yet. uses the same size as fft 1.
% The number of frames increases in this step because it is overlapped for the second order analysis.
% TO DO:
% Need to add windows to the second order analysis. 
% sampling rate?
% fftshift
[numBins, numFrames] = size(frames);
newlength = ((numFrames/second_hop)) * fftwo_size
Y = zeros(numBins, newlength); % this doesnt look right.
%size_of_Y = size(Y)
curStart = 1;
curStartOut = 1;
curEnd  = (fftwo_size  ) - 1;
curEndOut  = (fftwo_size  ) - 1 ;
%secondNumHops = floor( numFrames / (second_hop) ) ;
%secondNumHopsStop =  floor(secondNumHops	-( (fftwo_size ) / (secondNumHops * fftwo_size) )	-1 ); % place to stop hopping before running off end.
secondNumHopsStop = floor(newlength / fftwo_size) - floor(fftwo_size/second_hop)
for yincr = 1:secondNumHopsStop		% for yincr = 1:secondFrames
%yincr
	curEnd   = curStart + (fftwo_size );
	curEndOut = curStartOut + (fftwo_size );
	for xincr = 1:fftwo_size / 2  % top column to bottom column. numBins
		Y(xincr ,[curStartOut:curEndOut]) = fft(frames(xincr,[curStart:curEnd]));	% fft of grain.
		%plot(abs(Y(xincr,[curStart:curEnd])));
	end
	curStart = curStart + second_hop;		% curStart = curStart + (winSampsPow2 /2 );
	curStartOut = curStartOut + (fftwo_size  );
end
YTWO = Y;

