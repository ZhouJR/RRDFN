function [Points] = RotatePan2D(Object,StartPoint,Azimuth)
    % point: [x,y]
    [row,column] = size(Object);
	if row ~= 2 && column ~= 2
        error('the origin point should been a matrix which row or column =2 ')
	end
    if row == 2
        Object = Object';
    end
    Plocal = Object - repmat(Object(1,:),size(Object,1),1);
	RotateMatrix = [cos(Azimuth),sin(Azimuth);-sin(Azimuth),cos(Azimuth)];
	Points = Plocal * RotateMatrix + repmat(StartPoint,size(Plocal,1),1);
end