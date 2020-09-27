function [Distribution_Fourier] = StatisticsSpectrumLognormal(Fourier)
%==========================================================================
% Fourier-based Generation of RDFN for Jointed Rock Mass
% Statistics of Fourier and Phase with Lognormal distibution
%==========================================================================
    [~,column] = size(Fourier);
    for n = 1:column
        maxFourier = max(Fourier(:,n));
        minFourier = min(Fourier(:,n));
        x = linspace(minFourier,maxFourier,101);
        [y,x] = ksdensity(Fourier(:,n),x);
        fun = @(p,x) p(1)./x.*exp(-((log(x)-p(2))/p(3)).^2/2);
        [maxy,ind] = max(y);
        p = nlinfit(x,y,fun,[maxy*x(ind),log(x(ind)),1]);
        figure(1)
        scatter(x,y)
        hold on
        xfit = x;
        yfit = fun(p,xfit);
        plot(xfit,yfit,'k','linewidth',3);
        hold off
        Distribution_Fourier = y;
    end
end