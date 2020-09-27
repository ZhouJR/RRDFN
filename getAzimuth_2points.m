function [azimuth, dist] = getAzimuth_2points(point1, point2)
%% the distance and azimuth betweeb Point2 and Point1
% point: [x,y]
% azimuth: right as zero, Counterclockwise as postive, from 0 to 360
P_local = [point2(1)-point1(1) point2(2)-point1(2)];
dist = sqrt(P_local(1)^2+P_local(2)^2);

P_local(1);
P_local(2);

if (P_local(2)>=0)
    azimuth = acos(P_local(1)/dist) * 180/pi;
    return;
end
if (P_local(2)<0)
    azimuth = 360 - acos(P_local(1)/dist)*180/pi; 
    return;
end