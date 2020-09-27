function Rough_Fracture = DerivedFracture(Fourier,Phase,d,StartPoint,EndPoint)
%==========================================================================
%Figure_Fourier-based Generation of RDFN for Jointed Rock Mass
%==========================================================================
    [Azimuth, Trace] = getAzimuth_2points(StartPoint, EndPoint);
    Count = length(Fourier);
    Spectrum = zeros(2*Count-1,1);
    for m = 1:Count
        Spectrum(m) = Fourier(m)*cos(Phase(m)) + 1i*Fourier(m)*sin(Phase(m));
    end
    for n = 1:Count
        Spectrum(2*Count-n) = Fourier(n)*cos(Phase(n)) - 1i*Fourier(n)*sin(Phase(n));
    end
    y = idft(Spectrum);
    for r = 1:length(y)
        if real(y) > 0
            y(r) = abs(y(r));
        else
            y(r) = -abs(y(r));
        end
    end
    px = 0:d:Trace+d;
    px = px';
    py = y(1:length(px));
    Object = [px,py];
    Azimuth = deg2rad(Azimuth);
    Rough_Fracture = RotatePan2D(Object,StartPoint,Azimuth);
end