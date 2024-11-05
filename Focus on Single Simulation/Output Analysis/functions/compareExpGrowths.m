% This function takes as input the following arguments : 
% 1) the discrete growth rate
% 2) the continuous growth rate
% 3) the initial population
% 4) time (unit steps)

% This function returns as output the following arguments:
% 1) the plot of discrete vs continous growth, 
% having N (population) on the Y axis and t (time) on the X axis

function compareExpGrowths(r,k,N_0,t)
    figure;
    hold on;
    s = stairs(t, N_0*(1+r).^t, Color="#9B59B6", LineWidth=1.5);
    p = plot(t, N_0*exp(k.*t), Color="#16A085", LineWidth=1.5);
    ylabel("N (population) - units");
    xlabel("t (time) - units");
    title("Population evolution over time");
    subtitle_ = ["Initial population ( N_0 ): " + N_0 + "", "Continuous growth rate ( k ): " + k + "    Discrete growth rate ( r ): " + r + ""]; 
    subtitle(subtitle_);
    legend([p,s], "continuous growth (exponential curve)", " discrete growth (geometric progression)", Location="best")
    hold off;
end
