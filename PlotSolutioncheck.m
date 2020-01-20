function PlotSolutioncheck(x,y)

    %route=[route route(1)];
    
    plot(x,y,'k-o',...
        'MarkerSize',3,...
        'MarkerFaceColor','y',...
        'LineWidth',1.5);
    
    xlabel('x');
    ylabel('y');
    
    axis equal;
    grid on;
    
	alpha = 0.1;
	
    xmin = min(x);
    xmax = max(x);
    dx = 05*(xmax - xmin);
    xmin = floor((xmin - alpha*dx)/3)*3;
    xmax = ceil((xmax + alpha*dx)/3)*3;
    xlim([xmin xmax]);
    
    ymin = min(y);
    ymax = max(y);
    dy = ymax - ymin;
    ymin = floor((ymin - alpha*dy)/5)*5;
    ymax = ceil((ymax + alpha*dy)/5)*5;
    ylim([ymin ymax]);
    
end