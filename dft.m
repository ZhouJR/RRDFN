function Fk = dft(fn)
%Discrete Fourier Transform, higher precision than fft
	fn = fn(:)';
	N = length(fn);
	n = 0:N-1;
	k = n;
	wn = exp(-1i*2*pi/N);
	nk = n'*k;
	wnnk = wn.^nk;
	Fk = wnnk*fn';
	%Fk = abs(Fk);
end