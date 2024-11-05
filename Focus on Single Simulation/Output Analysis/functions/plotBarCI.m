% This function takes as input the following arguments:
% 1) title_ (chages upon population model)
% 2) xlabel_ (for each stacked bar plot)
% 3) xticks_  (for each stacked bar per time frame)
% 4) yBar_ (true/false values to build each stacked bar per time frame)

% This function outputs a multiple stacked bar plot

function plotBarCI(title_, xlabel_, xticks_, yBar_)
    
    box on;
    yBar = yBar_;
    bar1 = bar(yBar, "stacked");
    xbarCnt = vertcat(bar1.XEndPoints);
    ybarTop = vertcat(bar1.YEndPoints);
    ybarCnt = ybarTop-yBar'./2;
    barTxt = compose('%d', yBar');
    
    th = text(xbarCnt(:), ybarCnt(:), barTxt(:), ...
        'HorizontalAlignment', 'center', ....
        'VerticalAlignment', 'middle', ...
        'Color', 'w',....
        'FontSize', 12);
    xlabel(xlabel_);
    ylabel("t (time) - iterations")
    legend(["True", "False"], Location="northwest");
    title(title_, FontSize=8)
    set(bar1, 'FaceColor', 'Flat');
    bar1(1).CData = [0 0.5 1];  
    bar1(2).CData = [0.8 0.31 0.36]; 
    xticklabels('manual');
    ax = gca;
    xticklabels(ax,xticks_);
    fontsize(ax, scale=1.9);

end