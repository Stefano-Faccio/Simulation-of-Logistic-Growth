% This function takes as input the following arguments:
% 1) table of simulations (Each column contains a whole simulation (501 x 1000)), 
% 2) theoretical exponential function population (y) values given simulation time (x) values
% 3) theoretical logistic function population (y) values given the simulation time (x) values
% 4) number of simulations (table columns), NSIMULATIONS 
% 5) number of iterations (table rows), ITERATIONS

% 6) chosen number of first n interations to check (number of table rows
% otherwise) ITERATIONS_TO_SHOW or ITERATIONS

% 7) window for the moving average of each simulation data (population evolution) or zero,
% 8) array of colors to visually detect simulations
% 9) ymin boundary for plot
% 10) ymax boundary for plot
% 11) CROWDING_COEFFICIENT (C)
% 12) REPRODUCTION_PROBABILITY (R)
% 13) DEATH_PROBABILITY (D)
% 14) START_POPULATION (N_0)
% 15) INFLECTION_POPULATION
% 16) INFLECTION_TIME

% This function returns as output the following arguments:
% 1) popTGrandMean, each time mean array of simulation values (old TimeWiseGrandMean, new iteration grand mean) 

% 2) popTMean, the array resulting from calculating the mean of y (population) values
% (of all simulations) for each x (time) value, referred to as timeWiseMean
% (old), now called iteration means or \mu(N_i) values

% 3) popTVar, the array resulting from calculating the variance of y (population) values
% (of all simulations) for each x (time) value, referred to as iteration variances or \sigma^2(N_i) values
 
% 4) the plot of all simulation data (with moving average to smooth data for visualisation if window>zero)
% overlapping with the corresponding plot of the theoretical exponential
% and logistic growths


function [popTGrandMean,popTMean, popTVar] = plotLogIteration(T, arrayE, arrayL, nSim, nIter, timeCut, movMeanWindow, colors,ymin,ymax, C,R,D,N_0, INFLECTION_POPULATION, INFLECTION_TIME)
    
    t = 0:nIter-1;
    t = t(1:end-(end-timeCut)); % to account for time cut if different from the number of total iterations
    colorCount = 0;
    
    figure; 
    hold on;
    popMean = [];
    
    for i=1:nSim
        pop = table2array(T(1:end-(end-timeCut),i));
        window = movMeanWindow;
        if window==0
            % display single simulation (out of 1000)
            popMovMean = plot(t, pop, 'Color', colors(mod(colorCount,length(colors))+1), 'LineWidth', 1);
        else
            popMovMean = plot(t, movmean(pop, window), 'Color', colors(mod(colorCount,length(colors))+1), 'LineWidth', 1);
        end
        %colorCount = colorCount + 1; 
    end
    
    % Compute iteration means and variances
    popTMean = [];
    popTVar = [];
    for i=1:nIter-(nIter-timeCut)
        popT = table2array(T(i,:));
        popTMean = [popTMean mean(popT)];
        popTVar = [popTVar var(popT)];
    end
    
    % Compute iteration grand mean
    popTGrandMean = mean(popTMean);
    popTGrandMeanY = yline(popTGrandMean, 'k', 'LineWidth', 1.5, 'LineStyle','-.');
    % exponential growth
    pEm = plot(t, arrayE(1:end-(end-timeCut)), '*', Color ="#0093AF");
    % logistic growth
    pLm = plot(t, arrayL(1:end-(end-timeCut)), 'o', Color ="#3CB44B",LineWidth=1.5 );
    % iteration means
    timeWiseMean = plot(t,popTMean, 'k', 'LineWidth', 1.5);
    % additional info (inflection population and time)
    inflectionPopY = yline(INFLECTION_POPULATION,"r:", "N*",  'LineWidth', 1.5);
    inflectionTimeX = xline(INFLECTION_TIME,  "b:","t*",'LineWidth', 1.5);
    
    xlabel("t (time) - iterations");
    ylabel('N (Population)');
    legend([pEm pLm timeWiseMean popTGrandMeanY inflectionPopY inflectionTimeX], 'Exponential growth', 'Logistic growth','Iteration means \mu(N_i)', 'Iteration grand mean', 'N*', 't*', Location='southeast');
    ylim([ymin ymax]);
    
    title_="Logistic growth: simulation vs theory";
    if window==0
        subtitle_ = ["Simulations: " + nSim + ", Iterations:  " + timeCut + "; Iteration grand mean: " + round(popTGrandMean,2) + ";", ...
        "Theory inflection population (N*): "+INFLECTION_POPULATION+"; Theory inflection time (t*): "+INFLECTION_TIME+ ";", ...
        "R: " + R + "; D: " + D + "; c: " +  C + "; N_0: " + N_0 + ";"];
    else
        subtitle_ = ["Moving average of population per simulation with a window of " + window + ";", ...
        "Simulations: " + nSim + ", Iterations:  " + timeCut + "; Simulation grand mean: " + round(popTGrandMean,2) + ";", ...
        "Theory inflection population (N*): "+INFLECTION_POPULATION+"; Theory inflection time (t*): "+INFLECTION_TIME+ ";",...
        "R: " + R + "; D: " + D + "; c: " +  C + "; N_0: " + N_0 + ";"];
    end
    title(title_, fontsize=20);
    subtitle(subtitle_, fontsize=18);
    
    ax = gca;
    fontsize(ax, scale=1.8);
    xlim('tight');
    hold off;
    
end