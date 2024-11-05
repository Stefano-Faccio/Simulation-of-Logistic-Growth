
% The function getScatterPlots() takes as input the following variables:
% 1) tailMeanT, the table containing observed L for each
% parameter setting;
% 2) var, the column name corresponding to the difference between the theoretical L
% and the observed L (raw, absolute, absolute scaled, raw scaled);
% 3) sz, size of the points for scatter plots
% 4) label, \Delta L for axis
% 5) START_CROWDING_COEFFICIENT
% 6) STEP_CROWDING_COEFFICIENT
% 7) END_CROWDING_COEFFICIENT
% 8) START_REPRODUCTION_PROBABILITY
% 9) STEP_REPRODUCTION_PROBABILITY
% 10) END_REPRODUCTION_PROBABILITY

% The function outputs 4 plots:
% 1) scatter plot of start population and \DeltaL (scaled percentage):
% choose the start population that leads growth to the carrying capacity
% limit.
% 2) boxplot of crowding coefficients and conrresponding distributions of \DeltaL
% 3) boxplot of reproduction probability and conrresponding distributions of \DeltaL
% 4) histogram to assess the frequency of \DeltaL values.

function  getParamPlots(tailMeanT, var, sz, label, c_start, c_step, c_end, R_start, R_step, R_end)
    
    figure
    hold on;
    t=tiledlayout(2,2);
    title(t, "Evaluation of \DeltaL (%) and the system variables N_0 (initial population), R (reproduction probability), D (death probability) and c (crowding coefficient).", fontsize=15)
    subtitle(t,'$$\Delta L (\%) = \frac{|theoretical~L - observed~L|}{theoretical~L} \times 100;~~R=D+0.05;$$', 'interpreter', 'latex', fontsize=14)
    
    % 1) scatter plot of start population and \DeltaL (scaled percentage)
    % Question: does initial population have an impact on the carrying
    % capacity limit. Here we assume that it does, since smaller population
    % may lead to extinction.
    nexttile
    scatter(tailMeanT.ItSTART_POPULATION,tailMeanT.(var), sz, 'MarkerEdgeColor','w', 'MarkerFaceColor',"#966FD6",'LineWidth',0.5)
    xlabel('N_0')
    ylabel(label)
    ytickformat('percentage')
    title("A) Pair-wise relationship between initial population (N_0) and \DeltaL");
    ax = gca;
    fontsize(ax, scale=1.2);
    box on;
    
    % 2) boxplot of crowding coefficients and conrresponding distributions of \DeltaL
    % Question: does a greater crowding coefficient, hence smaller carrying
    % capacity lead to a smaller difference, or viceversa?
    nexttile
    miniTableC = table(tailMeanT.ItCROWDING_COEFFICIENT,tailMeanT.(var) );
    miniTableC.Properties.VariableNames = ["C" var];
    arrayC = [];
    miniTableC.C = round(miniTableC.C,5);
    for i=c_start:c_step:c_end
        newTable = miniTableC(miniTableC.C == round(i, 5), var);
        newTable.Properties.VariableNames = string(i);
        arrayC = [arrayC newTable];
    end
    boxplot(arrayC{:,:}, 'Labels', string(c_start:c_step:c_end), 'Symbol', '.', 'Colors', [0 0.7 0.6]);
    xlabel('c')
    ylabel(label)
    ax = gca;
    fontsize(ax, scale=1.2);
    ytickformat('percentage')
    title("B) Boxplot of \DeltaL for each crowding coefficient (c) value");
    
    % 3) boxplot of reproduction probability and conrresponding distributions of \DeltaL
    % Question: since the difference between reproduction and death probability is kept fixed to
    % the discrete growth rate (r), are the reproduction-death probability
    % values relevant for the carrying capacity limit? Are there better
    % values than others?
    nexttile
    miniTableR = table(tailMeanT.ItREPRODUCTION_PROBABILITY,tailMeanT.(var) );
    miniTableR.Properties.VariableNames = ["R" var];
    arrayR = [];
    miniTableR.R = round(miniTableR.R,5);
    for i=R_start:R_step:R_end
        newTable = miniTableR(miniTableR.R == round(i, 5), var);
        newTable.Properties.VariableNames = string(i);
        arrayR = [arrayR newTable];
    end
    boxplot(arrayR{:,:}, 'Labels', string(R_start:R_step:R_end), 'Symbol', '.', 'Colors', [0.7 0.6 0.3]);
    xlabel('R (D+0.05)')
    ylabel(label)
    ytickformat('percentage')
    ax = gca;
    fontsize(ax, scale=1.2);
    title("C) Boxplot of \DeltaL for each reproduction (R) and death (D) probability values.");

    % 4) histogram to assess the frequency of \DeltaL values:
    % Question: how many cases (parameter settings) are there  where the difference is close to
    % 0%?
    nexttile
    histogram(tailMeanT.(var), "EdgeColor", 'w', "FaceColor", "#0FC0FC", "LineWidth", 1);
    xlabel(label)
    xtickformat('percentage')
    ylabel('Frequency')
    ax = gca;
    fontsize(ax, scale=1.2);
    title("D) Frequency distribution of \DeltaL values across all parameter settings");
    hold off;
    
  
end