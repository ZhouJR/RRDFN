function [Distribution_Fourier,Distribution_Phase] = StatisticsSpectrumBimodal(Fourier,Phase)
%==========================================================================
% Fourier-based Generation of RDFN for Jointed Rock Mass
% Statistics of Fourier and Phase with Bimodal distibution
%==========================================================================
    [~,column] = size(Fourier);
    for n = 1:column
        xi = [min(Fourier(:,n)):(max(Fourier(:,n))-min(Fourier(:,n)))/50:max(Fourier(:,n))];
        [yi,xi] = ksdensity(Fourier(:,n),xi);
%         xi = [min(Fourier(:,n)):(max(Fourier(:,n))-min(Fourier(:,n)))/20:max(Fourier(:,n))];
%         yi = hist(Fourier(:,n),xi) / length(Fourier(:,n));
        [GS,~] = fit(xi', yi', 'gauss2');
        a1 = GS.a1;
        b1 = GS.b1;
        c1 = GS.c1;
        a2 = GS.a2;
        b2 = GS.b2;
        c2 = GS.c2;
        mu1 = b1;
        sigma1 = c1/sqrt(2);
        r1 = a1*sigma1*sqrt(2*pi);
        mu2 = b2;
        sigma2 = c2/sqrt(2);
        r2 = 1 - a2*sigma2*sqrt(2*pi);     % r1 is very close to r2
        r = (r1+r2)/2;
        Distribution_Fourier(1,n) = mu1;
        Distribution_Fourier(2,n) = sigma1;
        Distribution_Fourier(3,n) = mu2;
        Distribution_Fourier(4,n) = sigma2;
        Distribution_Fourier(5,n) = r;
        Distribution_Fourier(6,n) = min(Fourier(:,n));
        Distribution_Fourier(7,n) = max(Fourier(:,n));
%         zi = GS(xi);
%         figure(1)
%         scatter(xi,yi)
%         hold on
%         plot(xi,zi)
%         hold off
    end
    
	for n = 1:column
        xi = [min(Phase(:,n)):(max(Phase(:,n))-min(Phase(:,n)))/50:max(Phase(:,n))];
        [yi,xi] = ksdensity(Phase(:,n),xi);
%         xi = [min(Phase(:,n)):(max(Phase(:,n))-min(Phase(:,n)))/20:max(Phase(:,n))];
%         yi = hist(Phase(:,n),xi) / length(Phase(:,n));
        [GS,~] = fit(xi', yi', 'gauss2');
        a1 = GS.a1;
        b1 = GS.b1;
        c1 = GS.c1;
        a2 = GS.a2;
        b2 = GS.b2;
        c2 = GS.c2;
        mu1 = b1;
        sigma1 = c1/sqrt(2);
        r1 = a1*sigma1*sqrt(2*pi);
        mu2 = b2;
        sigma2 = c2/sqrt(2);
        r2 = 1 - a2*sigma2*sqrt(2*pi);
        r = (r1+r2)/2;
        Distribution_Phase(1,n) = mu1;
        Distribution_Phase(2,n) = sigma1;
        Distribution_Phase(3,n) = mu2;
        Distribution_Phase(4,n) = sigma2;
        Distribution_Phase(5,n) = r;
        Distribution_Phase(6,n) = min(Phase(:,n));
        Distribution_Phase(7,n) = max(Phase(:,n));
%         zi = GS(xi);
%         figure(1)
%         scatter(xi,yi)
%         hold on
%         plot(xi,zi)
%         hold off
	end
end