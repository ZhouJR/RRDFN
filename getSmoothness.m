function Smoothness = getSmoothness(x,y,varargin)
%% 计算Smoothness
    d = 0.05;
    y1 = diff(y)/d;
    y2 = diff(y1)/d;
    y1 = y1(2:end);
	Curvature = abs(y2./(1+y1.^2).^1.5);
    Smoothness = log10(1/mean(Curvature)/d);
%% 绘图与否
    if ~isempty(varargin)
        if strcmpi(varargin,'y') || strcmpi(varargin,'yes') || strcmpi(varargin,'draw')
			%% 前处理
            % 避免半径无穷大，设置一大上下边界
            maxy =  10000000;
            miny = -10000000;
            % 曲率半径处理（显示效果）
            curR = 1./Curvature;
            curRFake =  log10(curR)/20+0.10;%%由于曲率半径很大，所以对R进行缩小，用于画示意图
            % 去掉第一和最后一个点，因为他们在曲线上没有两个相邻点
            vertex_x = x(2:end-1);
            vertex_y = y(2:end-1);

			%% 顶点求角平分线单位向量
            vLeft_x = x(1:end-2) - x(2:end - 1);
            vLeft_y = y(1:end-2) - y(2:end - 1);
            vRight_x = x(3:end)  - x(2:end - 1);
            vRight_y = y(3:end)  - y(2:end - 1);
            % normalize
            vLeft_nor =  (vLeft_x.^2  + vLeft_y.^2).^0.5;
            vLeft_x = vLeft_x ./ vLeft_nor;
            vLeft_y = vLeft_y ./ vLeft_nor;
            vRight_nor =  (vRight_x.^2  + vRight_y.^2).^0.5;
            vRight_x = vRight_x ./ vRight_nor;
            vRight_y = vRight_y ./ vRight_nor;

            bisector_x = (vLeft_x + vRight_x) ./ 2;
            bisector_y = (vLeft_y + vRight_y) ./ 2;
            bisector_nor = (bisector_x.^2  + bisector_y.^2).^0.5;
            bisector_x = bisector_x ./ bisector_nor;
            bisector_y = bisector_y ./ bisector_nor;
			%% 求曲率圆心
            % circle center x
            cx = vertex_x + bisector_x .* curRFake;
            % circle center y
            cy = vertex_y + bisector_y .* curRFake;
            for n = 1:length(cx)
				if bisector_nor(n) == 0   % 如果顶点夹角为180度,则角平分线为垂线
					% Create rotation matrix
					theta = 90; % to rotate 90 counterclockwise
                    R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
                    % Rotate your point(s)
                    point = [vRight_x(n), vRight_y(n)]';
                    rotpoint = R*point;
                    rotpoint = rotpoint ./ norm(rotpoint);
                    bisector_x(n) = rotpoint(1);
                    bisector_y(n) = rotpoint(2);
				end
				% 对于虚线上方画圆
				% 顶点坐标为(x,y)，角平分线单位方向向量为(u,v)，长度为r，上部边界为y=m
				% 待求为长度r和圆心点（xc, yc）且有：
				% xc=x+r*u
				% yc=y+r*u
				% 圆心到上部边界距离为r，则有m-yc=m-(y+r*v)=r
				% 可以求得r为：r=(m-y)/(1+v)，同时可以求得xc和yc
				if bisector_y(n) >= 0 % 上部圆
					if cy(n) + curR(n) > maxy
						r = log10((maxy - vertex_y(n)) / (1 + bisector_y(n)))/10;
                        %r=0.1;
                        cx(n) = vertex_x(n) + bisector_x(n) .* r;
                        cy(n) = vertex_y(n) + bisector_y(n) .* r;
                        curR(n) = r;
					end
				elseif bisector_y(n) < 0 % 下部圆
				% 同理，可以求得下部圆r为：
				% r=(y-m)/(1-v)
                   if cy(n) - curR(n) < miny
                        r = (vertex_y(n) - miny) / (1 - bisector_y(n));
                        %r=0.1;
                        cx(n) = vertex_x(n) + bisector_x(n) .* r;
                        cy(n) = vertex_y(n) + bisector_y(n) .* r;
                        curR(n) = r;
                   end    
				end      
            end
			%% 绘图
            figure;
            hold on
            alpha = 0.5;
            col_ind = (1  - curRFake / max(curRFake)) * 0.667;
            for n = 1:length(vertex_x)
				col = hsv2rgb([col_ind(n),1,1]);
                col = [col,alpha];
                MyCircle(cx(n), cy(n), curRFake(n), col);
            end
            plot(vertex_x,vertex_y,'LineWidth',1.5,'Color','black');
            hold off
            axis equal
            axis tight
            axis off
        else
            return
        end
    end
    
function [] = MyCircle(x,y,r,color)  
    rectangle('Position',[x-r,y-r,2*r,2*r],'Curvature',[1,1],'linewidth',1,'FaceColor',color); 
