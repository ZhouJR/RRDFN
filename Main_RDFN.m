clear;clc;close all
load Natural_Fracture.mat          % Natural fracture collected from rock exposure
 for m = 1:length(Natural_Fracture)
     d = 0.02;                     % Sampling intervel
     N = 4.00;                     % Max fracture length
     Digitized_Fracture{m} = FractureDigitization(Natural_Fracture{m},d,N);
     [Fourier(m,:),Phase(m,:)] = getSpectrum(Digitized_Fracture{m}(:,2));
 end
% Errors may occur in this process, sometimes we have to handle it manually.
% Because the function StatisticsSpectrumBimodal.m is not good writting.
[Distribution_Fourier,Distribution_Phase] = StatisticsSpectrumBimodal(Fourier,Phase);
% save Distribution_Fourier.mat Distribution_Fourier
% save Distribution_Phase.mat Distribution_Phase

% Generate new rough fractures
clear;clc;close all
load('DFNLine.mat')
load ('Distribution_Fourier.mat')
load ('Distribution_Phase.mat')
d = 0.02;
N = 4.00; 
[~,column] = size(Distribution_Fourier);
[~,count] = size(DFNLine);
for m = 1:count
    StartPoint = DFNLine{m}(1,:);
    EndPoint = DFNLine{m}(2,:);
    for n = 1:column
        Fourier(n) = randBimodal(Distribution_Fourier(:,n),1);
        Phase(n) = randBimodal(Distribution_Phase(:,n),1);
    end
    Rough_Fracture{m} = DerivedFracture(Fourier,Phase,d,StartPoint,EndPoint);
end

% Plot
for i = 1:length(Rough_Fracture)
    Detive_Fracture = Rough_Fracture{i};
    plot(Rough_Fracture{i}(:,1),Rough_Fracture{i}(:,2),'k','LineWidth',1.3);
    hold on
end
hold off
axis equal
axis tight
axis off
