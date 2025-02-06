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
        p_log = plot(ti, N_tl, LineWidth=4, Color="#FD151B");
        p_exp = plot(ti, N_te, LineWidth=3, Color="k");
        
    elseif string=="sf"
        % make grid visible
        quiver(t,N,dt,dN, Color=CT(1,:));
        plot(u,y, LineWidth=myWidth, Color="k");
    end
    
    % plot relevant y values 
    pstart = yline(0, "--","N=0     ", LineWidth=1.5, Color="k", LabelVerticalAlignment="bottom");
    pstop = yline(L, "--","N=L     ", LineWidth=1.5, Color="k");
    p2start = yline(N_0, "-","N_0                                                  ", LineWidth=2.5, Color="#00ff00");
    
    
    if string=="curve"
        % additional information
        maxN_t = max(y);
        coeff =(L/N_0)-1;
        inflection_t = (-1/k)*log(1/coeff);

        p2stop = yline(maxN_t, "-", "N_{max}                                                  ",LineWidth=2.5, Color="#ffc61a", LabelVerticalAlignment="bottom");
        p_middle = yline(L/2, "-", "N*=L/2                    ",'LabelOrientation', 'horizontal', LineWidth=2.5, Color="#ff00ff");
        p_vertical = xline(inflection_t,"-", {"", "", "", "", "", "","t^*"}, 'LabelOrientation', 'horizontal', LineWidth=2.5, Color="#3366ff", LabelHorizontalAlignment="left", LabelVerticalAlignment="middle");
    end
    
    ylabel("N (population) - units");
    xlabel("t (time) - units");
    
    if string=="sf"
        title("Solution to the Logistic Equation: Slope Field");
        subtitle_ = ["N_0 (initial population): " + N_0 + "; c (crowding coefficient): " + C + ";" , "k (continuous growth rate): " + k + "; L (carrying capacity): " + L+";"]; 

    elseif string=="curve"
        title("Logistic growth model");
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
        leg = legend([p_log p_exp p2start p2stop p_middle p_vertical], "Logistic", "Exponential", "N_0", "N_{max}", "N=L/2", "t^*", Location="northwest");
        title(leg, 'Growth curve');
    end

    fontsize(ax, scale=2.0);
    hold off;
    
end