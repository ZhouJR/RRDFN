function [DigitizedFracture] = FractureDigitization(NaturalFracture,d,N)
%==========================================================================
%Figure_Fourier-based Generation of RDFN for Jointed Rock Mass
%Digitization of natural fractures
%==========================================================================
    format long
    % Set the strat ponits as (0,0)
    x0 = NaturalFracture(1,1);
    y0 = NaturalFracture(1,2);
    x_a = NaturalFracture(:,1) - x0;
    y_a = NaturalFracture(:,2) - y0;
% =========================================================================
    % Set x axis and the line between strat ponits and end points
    x_start = x_a(1);
    y_start = y_a(1);
    x_end = x_a(end);
    y_end = y_a(end);
    cita = atan((y_end - y_start) / (x_end - x_start));
    for i = 1:length(NaturalFracture);
        x_b(i) = x_a(i)*cos(cita) + y_a(i)*sin(cita);
        y_b(i) = -x_a(i)*sin(cita) + y_a(i)*cos(cita);
    end
% =========================================================================
    % Set x axis as the baseline
    coefficient = polyfit(x_b,y_b,1);
    a = coefficient(1);
    b = coefficient(2);
    baita = atan(a);
    for i = 1:length(NaturalFracture)
        x_c(i) = x_b(i)*cos(baita) + y_b(i)*sin(baita);
        y_c(i) = -x_b(i)*sin(baita) + y_b(i)*cos(baita) - b;
    end
% =========================================================================
    % Linear interpolation with intervel d
    if x_c(end) > 0
        x_d = 0:d:x_c(end);
    else
        x_d = 0:-d:x_c(end);
    end
    y_d = interp1(x_c,y_c,x_d);
% =========================================================================
    % Sigmoidtrasnform
    Sigmoid = ones(1,length(x_d));
    Sigmoid(1:11) = [0,0.028,0.104,0.216,0.352,0.500,0.648,0.784,0.896,0.972,1];
    Sigmoid(length(x_d) - 10:end) = fliplr([0,0.028,0.104,0.216,0.352,0.500,0.648,0.784,0.896,0.972,1]);
    y_e =  y_d.*Sigmoid;
    x_e = x_d;
% =========================================================================
    % Zero padding
    x_f = 0:d:N;
    y_f = zeros(1,N/d+1);
    for i = 1:length(y_e)
        y_f(i) = y_e(i);
    end
    x_f = x_f';
    y_f = y_f';
    DigitizedFracture = [x_f,y_f];
end