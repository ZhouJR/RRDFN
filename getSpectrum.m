function [Fourier,Phase] = getSpectrum(DigitizedFracture)
% ==========================================================================
% Figure_Fourier-based Generation of RDFN for Jointed Rock Mass
% Fourier trasnform
    Spectrum = dft(DigitizedFracture);
    Spectrum = Spectrum(1:ceil(end/2));
    Fourier = abs(Spectrum);
    Phase = angle(Spectrum);
end