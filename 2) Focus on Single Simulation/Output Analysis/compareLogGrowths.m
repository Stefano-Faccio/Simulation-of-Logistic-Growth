% This function takes as input the following variables:
% 1) k, the continuous growth rate
% 2) N_0, the initial population
% 3) L, the carrying capacity
% 4) inflection_t, the inflection time
% 5) tmax, the number of iterations

% This function outputs 2 plots:
% 1) The big picture of the comparison between continuous and discrete
% logistic growth models (Population vs time)
% 2) The difference between continuous and discrete growth (in terms of population per time unit)
% in subsequent time frames.

function compareLogGrowths(k,N_0,L,inflection_t, tmax)

    t=0:1:tmax;
    % continous logistic function
    N_t=(L * N_0) ./ ((L - N_0) .* exp((-k) .* t) + N_0);

    Discrete_Model = zeros(1,t(end)+1);
    Discrete_Model(1) = N_0;
    % discrete logistic equation
    for i = 2:t(end)+1
        Discrete_Model(i) = Discrete_Model(i-1) + (Discrete_Model(i-1)*k)*(1 - Discrete_Model(i-1)/L);
    end
    
    % Image 1
    % The big picture of the comparison between continuous and discrete logistic growth models
    %{
    figure;
    tiledlayout(2,1)
    
    nexttile
    hold on;
    plot(t, N_t, LineWidth=1.5, Color="k");
    plot(t, Discrete_Model, ".", Color= "#29AB87",LineWidth=1.25);
    ylabel("N (population) - units");
    xlabel("t (time) - units");
    leg=legend("Continuous", "Discrete");
    leg.Location="northeast";
    title(leg, 'Logistic growth models');
    title("Big picture of the comparison between continuous and discrete logistic growth models");
    subtitle_ = ["Discrete = continuous growth rate (r = k): " + k+"; Initial population (N_0): " + N_0 + ";", ...
        "Carrying capacity (L): "+ L+"; Time range: [" + 0 + " - " + tmax + "]; Inflection time (t*):" + inflection_t + ";"];
    subtitle(subtitle_);
    ax = gca;
    fontsize(ax, scale=1.4);
    ax.TitleHorizontalAlignment="center";
    box on;
    hold off;

    nexttile
    hold on;
    plot(t, Discrete_Model-N_t, "r.", LineWidth=1.5);
    yline(0, '-', '\DeltaN=0', Color="#8C92AC",LineWidth=1.25)
    title_ = "Difference in population (\DeltaN) between discrete and continuous logistic growth per time unit";
    title(title_);
    ylabel("\DeltaN");
    xlabel("t (time) - units");
    ax = gca;
    fontsize(ax, scale=1.4);
    ax.TitleHorizontalAlignment="center"; 
    box on;
    hold off;
    %}

    % Image 2
    % The difference between continuous and discrete growth (in terms of population per time unit)
    %{
    figure;
    tl= tiledlayout(2,2);
    title(tl,["Comparison of continuous and discrete logistic growth in subsequent time frames", "[Discrete = continuous growth rate (r = k): " + k+"; Initial population (N_0): " + N_0 + "; Carrying capacity (L): "+ L+"]"]);
    fontsize(tl, scale=2);
    
    % 1) Time range: [0-49]; t*=49
    nexttile
    hold on;
    plot(t(1:inflection_t), N_t(1:inflection_t), LineWidth=1.5, Color="k");
    plot(t(1:inflection_t), Discrete_Model(1:inflection_t), ".", Color= "#29AB87",LineWidth=1.25);
    axis tight;
    title_ = "Time range: [" + 0 + " - " + inflection_t + "]; t*: " + inflection_t + ";";
    title(title_);
    ylabel("N (population) - units");
    xlabel("t (time) - units");
    leg= legend("Continuous", "Discrete");
    title(leg, 'Logistic growth models');
    leg.Location="northwest";
    ax = gca;
    fontsize(ax, scale=2.2);
    box on;
    hold off;
    
    % 2) Time range: [49-98]; 2xt*=98
    nexttile
    hold on;
    plot(t(inflection_t: inflection_t*2), N_t(inflection_t: inflection_t*2), LineWidth=1.5, Color="k");
    plot(t(inflection_t: inflection_t*2), Discrete_Model(inflection_t: inflection_t*2), ".", Color= "#29AB87",LineWidth=1.25);
    axis tight;
    title_ = "Time range: [" + inflection_t + " - " + inflection_t*2 + "]; 2xt*: " + inflection_t*2 + ";";
    title(title_);
    ylabel("N (population) - units");
    xlabel("t (time) - units");
    ax = gca;
    fontsize(ax, scale=2.2);
    box on;
    hold off;
    
    % 3) Time range: [98-196]; 4xt*=196
    nexttile
    hold on;
    plot(t(inflection_t*2:inflection_t*4), N_t(inflection_t*2:inflection_t*4), LineWidth=1.5, Color="k");
    plot(t(inflection_t*2:inflection_t*4), Discrete_Model(inflection_t*2:inflection_t*4), ".", Color= "#29AB87",LineWidth=1.25);
    axis tight;
    title_ = "Time range: [" + inflection_t*2 + " - " + inflection_t*4 + "]; 4xt*: " + inflection_t*4 + ";";
    title(title_);
    ylabel("N (population) - units");
    xlabel("t (time) - units");
    ax = gca;
    fontsize(ax, scale=2.2);
    box on;
    hold off;
    
    % 4) Time range: [196-400]; 8xt*=392
    nexttile
    hold on;
    plot(t(inflection_t*4:tmax), N_t(inflection_t*4:tmax), LineWidth=1.5, Color="k");
    plot(t(inflection_t*4:tmax), Discrete_Model(inflection_t*4:tmax), ".", Color= "#29AB87",LineWidth=1.25);
    axis tight;
    title_ = "Time range: [" + inflection_t*4 + " - " + tmax + "]; 8xt*: " + inflection_t*8 + ";";
    title(title_);
    ylabel("N (population) - units");
    xlabel("t (time) - units");
    ax = gca;
    fontsize(ax, scale=2.2);
    box on;
    hold off;
    %}

    myMarkerSize = 15;

    %1) Time range: [0-49]; t*=49
    figure;
    hold on;
    plot(t(1:inflection_t), N_t(1:inflection_t), LineWidth=1.5, Color="k");
    plot(t(1:inflection_t), Discrete_Model(1:inflection_t), ".", Color="#0072BD", LineWidth=1.25, MarkerSize=myMarkerSize);
    axis tight;
    title_ = "Time range: [" + 0 + " - " + inflection_t + "]; t*: " + inflection_t + ";";
    %title(title_);
    ylabel("N (population) - units");
    xlabel("t (time) - units");
    leg= legend("Continuous", "Discrete");
    leg.Location="southeast";
    title(leg, 'Logistic growth models');
    ax = gca;
    fontsize(ax, scale=2.2);
    box on;
    hold off;

    % 2) Time range: [49-98]; 2xt*=98
    figure;
    hold on;
    plot(t(inflection_t: inflection_t*2), N_t(inflection_t: inflection_t*2), LineWidth=1.5, Color="k");
    plot(t(inflection_t: inflection_t*2), Discrete_Model(inflection_t: inflection_t*2), ".", Color= "#D95319",LineWidth=1.25, MarkerSize=myMarkerSize);
    axis tight;
    title_ = "Time range: [" + inflection_t + " - " + inflection_t*2 + "]; 2xt*: " + inflection_t*2 + ";";
    %title(title_);
    leg= legend("Continuous", "Discrete");
    leg.Location="southeast";
    title(leg, 'Logistic growth models');
    ylabel("N (population) - units");
    xlabel("t (time) - units");
    ax = gca;
    fontsize(ax, scale=2.2);
    box on;
    hold off;

    % 3) Time range: [98-196]; 4xt*=196
    figure;
    hold on;
    plot(t(inflection_t*2:inflection_t*4), N_t(inflection_t*2:inflection_t*4), LineWidth=1.5, Color="k");
    plot(t(inflection_t*2:inflection_t*4), Discrete_Model(inflection_t*2:inflection_t*4), ".", Color= "#EDB120",LineWidth=1.25, MarkerSize=myMarkerSize);
    axis tight;
    leg= legend("Continuous", "Discrete");
    leg.Location="southeast";
    title(leg, 'Logistic growth models');
    title_ = "Time range: [" + inflection_t*2 + " - " + inflection_t*4 + "]; 4xt*: " + inflection_t*4 + ";";
    %title(title_);
    ylabel("N (population) - units");
    xlabel("t (time) - units");
    ax = gca;
    fontsize(ax, scale=2.2);
    box on;
    hold off;
    
    % 4) Time range: [196-400]; 8xt*=392
    figure;
    hold on;
    plot(t(inflection_t*4:tmax), N_t(inflection_t*4:tmax), LineWidth=1.5, Color="k");
    plot(t(inflection_t*4:tmax), Discrete_Model(inflection_t*4:tmax), ".", Color= "#7E2F8E",LineWidth=1.25, MarkerSize=myMarkerSize);
    axis tight;
    title_ = "Time range: [" + inflection_t*4 + " - " + tmax + "]; 8xt*: " + inflection_t*8 + ";";
    %title(title_);
    leg= legend("Continuous", "Discrete");
    title(leg, 'Logistic growth models');
    leg.Location="southeast";
    ylabel("N (population) - units");
    xlabel("t (time) - units");
    ax = gca;
    fontsize(ax, scale=2.2);
    box on;
    hold off;

end