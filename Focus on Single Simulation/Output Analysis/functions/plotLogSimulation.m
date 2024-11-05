% This function takes as input the following arguments : 
% 1) table of simulations (Each column contains a whole simulation (501 x 1000)), 
% 2) number of simulations (table columns), NSIMULATIONS 
% 3) number of iterations (table rows), ITERATIONS
% 4) chosen number of first n interations to check (number of table rows
% otherwise) ITERATIONS_TO_SHOW or ITERATIONS

% 5) window for the moving average of each simulation data (population evolution) or zero,
% 6) array of colors to visually detect simulations
% 7) INFLECTION_POPULATION to visualize the theoretical inflection population

% 8) INFLECTION_TIME to visualize the corresponding theoretical inflection
% time

% This function returns as output the following arguments:
% 1) each simulation mean array (popMean)
% 2) the grand mean of all simulations (popGrandMean)
% 3) the plot of all simulation data (with moving average to smooth data for visualisation if the window is >zero)

function [popGrandMean, popMean] = plotLogSimulation(T, nSim, nIter, timeCut, movMeanWindow, colors, string, INFLECTION_POPULATION, INFLECTION_TIME)
    
    t = 0:nIter-1;
    t = t(1:end-(end-timeCut)); % to account for time cut if different from the number of total iterations
    colorCount = 0;
    figure;
    hold on;
    popMean = [];
    for i=1:nSim
        pop = table2array(T(1:end-(end-timeCut),i));
        % sample mean for each replication (simulation means)
        popMean = [popMean mean(pop)];
        window = movMeanWindow;
        if window==0
            popMovMean = plot(t, pop,  'Color', colors(mod(colorCount,length(colors))+1), 'LineWidth', 1);
        else
            popMovMean= plot(t, movmean(pop, window),  'Color', colors(mod(colorCount,length(colors))+1), 'LineWidth', 1);
        end
        colorCount = colorCount + 1;
        
    end
    % sample grand mean (simulation grand mean)
    popGrandMean = mean(popMean);
    popGrandMeanY = yline(popGrandMean, 'k-.', 'LineWidth', 1.5);
    inflectionPopY = yline(INFLECTION_POPULATION,"r:", "N*",  'LineWidth', 1.5);
    inflectionTimeX = xline(INFLECTION_TIME,  "b:","t*",'LineWidth', 1.5);
    title_ = "" + string + "Population evolution over time"; 
    title(title_);
    if window==0
        subtitle_ = ["Simulations: " + nSim + ", Iterations:  " + timeCut + "; Simulation grand mean: " + round(popGrandMean,2) + ";", ...
        "Theoretical inflection population (N*): "+INFLECTION_POPULATION+"; Theoretical inflection time (t*): "+INFLECTION_TIME+ ";"];
    else
        subtitle_ = ["Moving average of population per simulation with a window of " + window + ";", ...
        "Simulations: " + nSim + ", Iterations:  " + timeCut + "; Simulation grand mean: " + round(popGrandMean,2) + ";", ...
        "Theoretical inflection population (N*): "+INFLECTION_POPULATION+"; Theoretical inflection time (t*): "+INFLECTION_TIME+ ";"];
    end
    subtitle(subtitle_);
    legend([popGrandMeanY, inflectionPopY inflectionTimeX], " Simulation grand mean", " N*", " t*", Location="southeast");
    xlabel("t (time) - iterations");
    ylabel('N (Population)');
    axis tight;
    ax = gca;
    fontsize(ax, scale=1.6);
    box on;
    hold off;
end