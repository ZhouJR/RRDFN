function Smoothness = getSmoothness(x,y,varargin)
%% ����Smoothness
    d = 0.05;
    y1 = diff(y)/d;
    y2 = diff(y1)/d;
    y1 = y1(2:end);
	Curvature = abs(y2./(1+y1.^2).^1.5);
    Smoothness = log10(1/mean(Curvature)/d);
%% ��ͼ���
    if ~isempty(varargin)
        if strcmpi(varargin,'y') || strcmpi(varargin,'yes') || strcmpi(varargin,'draw')
			%% ǰ����
            % ����뾶���������һ�����±߽�
            maxy =  10000000;
            miny = -10000000;
            % ���ʰ뾶������ʾЧ����
            curR = 1./Curvature;
            curRFake =  log10(curR)/20+0.10;%%�������ʰ뾶�ܴ����Զ�R������С�����ڻ�ʾ��ͼ
            % ȥ����һ�����һ���㣬��Ϊ������������û���������ڵ�
            vertex_x = x(2:end-1);
            vertex_y = y(2:end-1);

			%% �������ƽ���ߵ�λ����
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
			%% ������Բ��
            % circle center x
            cx = vertex_x + bisector_x .* curRFake;
            % circle center y
            cy = vertex_y + bisector_y .* curRFake;
            for n = 1:length(cx)
				if bisector_nor(n) == 0   % �������н�Ϊ180��,���ƽ����Ϊ����
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
				% ���������Ϸ���Բ
				% ��������Ϊ(x,y)����ƽ���ߵ�λ��������Ϊ(u,v)������Ϊr���ϲ��߽�Ϊy=m
				% ����Ϊ����r��Բ�ĵ㣨xc, yc�����У�
				% xc=x+r*u
				% yc=y+r*u
				% Բ�ĵ��ϲ��߽����Ϊr������m-yc=m-(y+r*v)=r
				% �������rΪ��r=(m-y)/(1+v)��ͬʱ�������xc��yc
				if bisector_y(n) >= 0 % �ϲ�Բ
					if cy(n) + curR(n) > maxy
						r = log10((maxy - vertex_y(n)) / (1 + bisector_y(n)))/10;
                        %r=0.1;
                        cx(n) = vertex_x(n) + bisector_x(n) .* r;
                        cy(n) = vertex_y(n) + bisector_y(n) .* r;
                        curR(n) = r;
					end
				elseif bisector_y(n) < 0 % �²�Բ
				% ͬ����������²�ԲrΪ��
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
			%% ��ͼ
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
