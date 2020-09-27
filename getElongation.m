function Elongation = getElongation(x,y,varargin)
    Elongation = log10((max(x)-min(x))/(max(y)-min(y)));
    % draw or not
    if ~isempty(varargin)
        if strcmpi(varargin,'y') || strcmpi(varargin,'yes') || strcmpi(varargin,'draw')
            figure
            plot(x,y,'color','b')
            axis equal
            hold on
            line ([min(x),min(x)],[min(y),max(y)],'color','r')
            line ([min(x),max(x)],[max(y),max(y)],'color','r')
            line ([max(x),max(x)],[min(y),max(y)],'color','r')
            line ([min(x),max(x)],[min(y),min(y)],'color','r')
            hold off
        else
            return
        end
    end
end