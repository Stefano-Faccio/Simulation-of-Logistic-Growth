% This function takes as input the following arguments: 
% 1) maximum time for the grid upper width limit (lower: 0)
% 2) maximun N for the grid upper height limit
% 3) minimum N for the grid lower height limit
% 4) continuous growth rate
% 5) crowding coefficient
% 6) initial population
% 7) string: either "curve" for logistic curve only (with additional information)
% or "sf" for logistic curve over the slope field 
% (with additional information to account for the logistic growth model)

% This function returns as output the following arguments:
% 1) either the slope field (with tiny arrows) for the logistic curve or
% the logistic curve (with model information)

function plotLogSForCurve(tmax,Nmax,Nmin,k,C,N_0,string)
    
    % grid preparation (for slope field)
    [t,N]=meshgrid(0:1:tmax,Nmin:1:Nmax);
    L = k/C;
    dN = k*N-C*N.^2;
    dt = ones(size(dN));
    
    % Theoretical logistic equation
    logisticEquation = @(u,y)(C.* y(1) .* (L - y(1)));
    % method 1: matlab built-in function ode45 to get logistic function (for slope field)
    [u, y] = ode45(logisticEquation, [0 tmax], N_0);

    % Theoretical logistic function
    ti=0:1:tmax;
    N_tl =  (L * N_0) ./ ( (L - N_0) .* exp((-k) .* ti) + N_0 );
    % Theoretical exponential function
    N_te = N_0*exp(k.*ti);

    figure;
    hold on;
    if string=="curve"
        % switch off the grid
        % quiver(t,N,dt,dN, Color = "#FFFFFF");
        p1 = plot(ti, N_tl, "k",LineWidth=1.5);
        p2 = plot(ti, N_te, LineWidth=1.5, Color="#8C92AC");
        
    elseif string=="sf"
        % make grid visible
        quiver(t,N,dt,dN, Color = "#A2A2D0");
        plot(u,y, LineWidth=1.5, Color="k");
    end
    
    % plot relevant y values 
    yline(L, "r--","N=L", LineWidth=1.5);
    yline(N_0, "g-","N_0", LineWidth=1.5);
    yline(0, "b--","N=0", LineWidth=1.5);
    
    if string=="curve"
        % additional information
        maxN_t = max(y);
        yline(maxN_t, "-", "N_{max}",LineWidth=1.5, Color="#EDB120");
        yline(L/2, "m-", "N=L/2",'LabelOrientation', 'horizontal', LineWidth=1.5)
        coeff =(L/N_0)-1;
        inflection_t = (-1/k)*log(1/coeff);
        xline(inflection_t,"c-", "t^*", 'LabelOrientation', 'horizontal', LineWidth=1.5)
    end
    
    ylabel("N (population) - units");
    xlabel("t (time) - units");
    
    if string=="sf"
        %title("Solution to the Logistic Equation: Slope Field");
        subtitle_ = ["N_0 (initial population): " + N_0 + "; c (crowding coefficient): " + C + ";" , "k (continuous growth rate): " + k + "; L (carrying capacity): " + L+";"]; 

    elseif string=="curve"
        %title("Logistic growth model");
        subtitle_ = [" (The exponential growth model is displayed as a reference)", ... 
            "N_0 (initial population): " + N_0 + "; N_{max} (maximum population at time t="+ tmax+ "): " + round(maxN_t,2)+ ";",  ...
            "c (crowding coefficient): " + C + "; k (continuous growth rate): " + k + ";", ...
            "L (carrying capacity): " + L+"; L/2 (inflection population): " + L/2 + "; t* (inflection time): " + round(inflection_t,2)+";"]; 
    end

    subtitle(subtitle_);
    axis tight;
    box on;
    ylim([Nmin Nmax]);
    ax = gca;
    ax.TitleHorizontalAlignment="center";

    if string=="sf"
    elseif string=="curve"
        leg= legend([p1 p2], "Logistic", "Exponential",Location="southwest");
        title(leg, 'Growth curve');
    end

    fontsize(ax, scale=2.0);
    hold off;
    
end