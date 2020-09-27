function fn=idft(Fk)
% Inverse discrete Fourier transform, higher precision than ifft
	Fk = Fk(:)';
	N = length(Fk);
	n = 0:N-1;
	k = n;
	wn = exp(1i*2*pi/N);
	nk = n'*k;
	wnnk = wn.^nk;
	fn = 1/N*wnnk*Fk';
	% fn = real(fn);
end