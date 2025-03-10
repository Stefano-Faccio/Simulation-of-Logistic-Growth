% This function takes as input the following arguments:
% 1) TIME (0:1:ITERATIONS-1)
% 2) INFLECTION_TIME (CARRYING_CAPACITY/2)
% 3) MeanArray, iteration means or \mu(N_i) values
% 4) MeanArrayCIs, 95% CIs of the iteration means
% 5) upCI (ci95_iterationMean(2, :) - iterationMean) - upper segment width;
% 6) downCI (iterationMean - ci95_iterationMean(1, :)) - lower segment width;
% 7) CM, population values corresponding to the continuous model
% 8) DM, population valeus corresponding to the discrete model

% This function outputs the following 6 plots:
% A) Big picture of the CM and DM fitting of the experimental \mu(N_i) values
% B) Difference in population (\DeltaN) between \mu(N_i) values and
% CONTINUOUS logistic growth per time unit (check min)
% C) Difference in population (\DeltaN) between \mu(N_i) values and
% DISCRETE logistic growth per time unit (check min)

% D) Global comparison of the CM (continuous) and DM (discrete) models fitting in the 95% CIs of the iteration means:
% number of true and false population (N) values per logistic growth model

% E) Comparison within the CM model: number of population values that fit
% in the 95% CIs of the iteration means, given specific time frames (check simmetries)

% F) Comparison within the DM model: number of population values that fit
% in the 95% CIs of the iteration means, given specific time frames (check simmetries)

function compareMeansModels(TIME, INFLECTION_TIME, MeanArray, MeanArrayCIs, upCI, downCI, CM, DM)

    % Which of the 2 models fits the iteration means better? theory vs practice

    % CM: continuous model
    % DM: discrete model (best candidate, but not continuous)

    % Compute the belonging (true/false) of CM and DM population values into the 95% CIs
    % of the iterations means, globally and in subsequent time frames
    [resCM, trueCM, falseCM, stat_rangesCM] = isInCI(MeanArrayCIs, CM, INFLECTION_TIME);
    [resDM, trueDM, falseDM, stat_rangesDM]= isInCI(MeanArrayCIs, DM, INFLECTION_TIME);
        
    figure;
    tl = tiledlayout(2,3);
    title(tl, ["A) B) C) Comparison of CM and DM fitting of \mu(N_i) values through the analysis of raw residuals", ...
        "D) E) F) Number of model population values that (do not) fall into the corresponding \mu(N_i) 95% CIs", ...
        "[ Population values belonging to \mu(N_i) 95% CIs: True; Otherwise: False ]"], fontsize=24)
    
    % A) B) C) Comparison of CM and DM fitting of \mu(N_i) values through the analysis of raw residuals
    nexttile
    hold on;
    errorbar(TIME, MeanArray, downCI, upCI, ".");
    plot(TIME,CM, Color="#29AB87");
    plot(TIME,DM, ".", Color="#FF8243");
    xlabel("time");
    ylabel("\mu(N_i)");
    legend ("\mu(N_i) 95% CIs", "CM: continuous model", "DM: discrete model", Location="southeast");
    title(["A) Big picture of the CM and DM fitting","of the experimental \mu(N_i) values"]);
    ax=gca;
    fontsize(ax, "scale", 1.6);
    box on;
    hold off;

    nexttile
    hold on;
    plot(TIME,MeanArray-CM, ".",Color="#29AB87", LineWidth=1.5);
    yline(0, '-', '\DeltaN=0',Color="#8C92AC",LineWidth=1.25);
    ylabel("\DeltaN");
    xlabel("t (time) - units");
    title(["B) Difference in population (\DeltaN) between \mu(N_i)"," and continuous logistic growth per time unit;"]);
    legend("CM Raw residuals", Location="southeast");
    ax=gca;
    fontsize(ax, "scale", 1.6);
    box on;
    hold off;

    nexttile
    hold on;
    plot(TIME,MeanArray-DM, ".", Color="#FF8243", LineWidth=1.5);
    yline(0, '-', '\DeltaN=0',Color="#8C92AC" ,LineWidth=1.25);
    ylabel("\DeltaN");
    xlabel("t (time) - units");
    title(["C) Difference in population (\DeltaN) between \mu(N_i)"," and discrete logistic growth per time unit;"]);
    legend("DM Raw residuals", Location="southeast");
    ax=gca;
    fontsize(ax, "scale", 1.6);
    box on;
    hold off;
    
    % D) E) F) Number of model population values that (do not) fall into the corresponding \mu(N_i) 95% CIs
    % [ Population values belonging to \mu(N_i) 95% CIs: True; Otherwise: False ]
    nexttile
    % visualize stacked bar plot of false over true values for continuos
    % and discrete model (side by side)
    plotBarCI(["D) Global comparison of the CM (continuous)","and DM (discrete) models"], ...
            ["Number of true and false population (N)","values per logistic growth model"], { 'CM','DM','FM', '', '','', '',}, ...
            [trueCM, falseCM; trueDM, falseDM]);
    nexttile
    % visualize stacked bar plot of false over true values for continuos
    % model in subsequent time frames (check last time frame)
    plotBarCI(["E) Comparison within the CM model;", "t* (inflection time): "+INFLECTION_TIME+";"], ...
            ["Number of true and false population (N)","values per time range"], {'t_{0} - t*','t* - 2t*','2t* - 3t*', '3t* - 4t*', '4t* - t_{max}', "",''}, ...
            stat_rangesCM');
    nexttile
    % visualize stacked bar plot of false over true values for discrete
    % model in subsequent time frames (check last time frame)
    plotBarCI(["F) Comparison within the DM model;", "t* (inflection time): "+INFLECTION_TIME+";" ], ...
            ["Number of true and false population (N)","values per time range"], {'t_{0} - t*','t* - 2t*','2t* - 3t*', '3t* - 4t*', '4t* - t_{max}',"", ''}, ...
            stat_rangesDM');
    hold off;
end