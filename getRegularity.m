function Regularity = getRegularity(x,y,varargin)
% Regularity = log10(P / (P - Pconv));
    P = 0;
    for i = 1:length(x)-1
        P = P + norm([x(i),y(i)]-[x(i+1),y(i+1)]);
    end
    L = max(x) - min(x);
    Regularity = log10(P / (P - L));
    % plot or not
    varargin = lower(varargin);
    if ~isempty(varargin)
        if strcmpi(varargin,'y') || strcmpi(varargin,'yes') || strcmpi(varargin,'draw')
            figure
            plot(x,y,'color','b')
            axis equal
            line ([min(x),max(x)],[0,0],'color','r')
        else
            return
        end
    end
end