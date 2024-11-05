% This function takes as input the following arguments:
% 1) ITERATIONS
% 2) ITERATIONS_TO_SHOW, to visualize subsequent time frames
% 3) MeanArray, iteration means
% 4) CM, continuous model

% This function outputs the following 6 plots:
% A.1) CM Histogram plot of the head (short-term) raw residuals [t_0 - 2t*]
% B.1) CM Histogram plot of the head+tail (long-term) raw residuals [t_0 - t_{max}]
% C.1) CM Histogram plot of the tail (steady-state only) raw residuals [2t* - t_{max}]
% A.2) CM Normal probability plot [t_0 - 2t*]
% B.2) CM Normal probability plot [t_0 - t_{max}]
% C.2) CM Normal probability plot [2t* - t_{max}]

% normal probabilty plot of the raw residuals of the iteration means wrt to the continuous model
% adding the NRMSE that the experimental iteration means score
% (NRMSE is not enough if an analysis of residuals is not performed)

function compareResiduals(ITERATIONS,ITERATIONS_TO_SHOW, MeanArray, CM)
    
    % A.1)
    % ----------------------------------------------------------------------------------------------------------------------------
    figure;
    hold on;
    residuals_1 = MeanArray-CM;
    histogram(residuals_1(1:ITERATIONS_TO_SHOW), 20, 'Normalization','pdf', FaceColor="#87A96B");
    %title(["A.1) CM Histogram plot of the head ","(short-term) raw residuals;"],"time range: [t_0 - 2t* ("+ITERATIONS_TO_SHOW+")]");
    %title("A.1)", FontSize=15);
    xlabel("CM Raw residuals (x)");
    ylabel("Frequency(x)");
    ax=gca;
    fontsize(ax, "scale", 1.5);
    box on;
    hold off;

    % B.1)
    % ----------------------------------------------------------------------------------------------------------------------------
    figure;
    hold on;
    histogram(residuals_1, 20, 'Normalization','pdf', FaceColor="#29AB87");
    %title(["B.1) CM Histogram plot of the head+tail ","(long-term) raw residuals;"],"time range: [t_0 - t_{max} ("+ITERATIONS+")]");
    %title("B.1)", FontSize=15);
    xlabel("CM Raw residuals (x)");
    ylabel("Frequency(x)");
    ax=gca;
    fontsize(ax, "scale", 1.5);
    box on;
    hold off;
    
    % C.1)
    % ----------------------------------------------------------------------------------------------------------------------------
    figure;
    hold on;
    %histogram(residuals_1(ITERATIONS_TO_SHOW:end),20, 'Normalization','pdf');
    h3 = histfit(residuals_1(ITERATIONS_TO_SHOW:end),20);
    h3(2).Color = [.2 .2 .2];
    h3(1).FaceColor ="#009E60";
    %title(["C.1) CM Histogram plot of the tail ","(steady-state only) raw residuals;"],"time range: [2t* - t_{max}]");
    %title("C.1)", FontSize=15);
    xlabel("CM Raw residuals (x)");
    ylabel("Frequency(x)");
    ax=gca;
    fontsize(ax, "scale", 1.5);
    box on;
    hold off;

    % A.2)
    % ----------------------------------------------------------------------------------------------------------------------------
    figure;
    hold on;
    n1 = normplot(residuals_1(1:ITERATIONS_TO_SHOW));
    props = get(n1,{'marker' 'linestyle' 'color'});
    set(n1, 'color', "#87A96B");
    legend(["x<Q1 or x> Q3","Q1<x<Q3", "x"], Location="northwest");
    NRMSE_CM = goodnessOfFit(MeanArray(1:ITERATIONS_TO_SHOW)', CM(1:ITERATIONS_TO_SHOW)', 'NRMSE'); %
    xlabel("CM Raw residuals (x)");
    ylabel("Probability(x)");
    title([]);
    %title("A.2) CM Normal probability plot;", ["NRMSE: "+NRMSE_CM+";","time range: [t_0 - 2t* ("+ITERATIONS_TO_SHOW+")];"]);
    %title("A.2)", FontSize=15);
    ax=gca;
    fontsize(ax, "scale", 1.5);
    box on;
    hold off;
    
    % B.2)
    % ----------------------------------------------------------------------------------------------------------------------------
    figure;
    hold on;
    n1 = normplot(residuals_1);
    props = get(n1,{'marker' 'linestyle' 'color'});
    set(n1, 'color', "#29AB87")
    legend(["x<Q1 or x> Q3","Q1<x<Q3", "x"], Location="northwest");
    NRMSE_CM = goodnessOfFit(MeanArray', CM', 'NRMSE'); %
    xlabel("CM Raw residuals (x)");
    ylabel("Probability(x)");
    title([]);
    %title("B.2) CM Normal probability plot;", ["NRMSE: "+NRMSE_CM+";","time range: [t_0 - t_{max} ("+ITERATIONS+")];"]);
    %title("B.2)", FontSize=15);
    ax=gca;
    fontsize(ax, "scale", 1.5);
    box on;
    hold off;
    
    % C.2)
    % ----------------------------------------------------------------------------------------------------------------------------
    figure;
    hold on;
    n1 = normplot(residuals_1(ITERATIONS_TO_SHOW:end));
    props = get(n1,{'marker' 'linestyle' 'color'});
    set(n1, 'color', "#009E60");
    legend(["x<Q1 or x> Q3","Q1<x<Q3", "x"], Location="northwest");
    NRMSE_CM = goodnessOfFit(MeanArray(ITERATIONS_TO_SHOW:end)', CM(ITERATIONS_TO_SHOW:end)', 'NRMSE'); %
    xlabel("CM Raw residuals (x)");
    ylabel("Probability(x)");
    title([]);
    %title("C.2) CM Normal probability plot;", ["NRMSE: "+NRMSE_CM+";","time range: [2t* - t_{max}];"]);
    %title("C.2)", FontSize=15);
    ax=gca;
    fontsize(ax, "scale", 1.5);
    box on;
    hold off;

end

%{

function compareResiduals(ITERATIONS,ITERATIONS_TO_SHOW, MeanArray, CM)
    
    figure;
    tiledlayout(2,3)
    
    % A.1)
    % ----------------------------------------------------------------------------------------------------------------------------
    nexttile
    hold on;
    residuals_1 = MeanArray-CM;
    histogram(residuals_1(1:ITERATIONS_TO_SHOW), 20, 'Normalization','pdf', FaceColor="#87A96B");
    title(["A.1) CM Histogram plot of the head ","(short-term) raw residuals;"],"time range: [t_0 - 2t* ("+ITERATIONS_TO_SHOW+")]");
    %title("A.1)", FontSize=15);
    xlabel("CM Raw residuals (x)");
    ylabel("Frequency(x)");
    ax=gca;
    fontsize(ax, "scale", 1.5);
    box on;
    hold off;

    % B.1)
    % ----------------------------------------------------------------------------------------------------------------------------
    nexttile
    hold on;
    histogram(residuals_1, 20, 'Normalization','pdf', FaceColor="#29AB87");
    title(["B.1) CM Histogram plot of the head+tail ","(long-term) raw residuals;"],"time range: [t_0 - t_{max} ("+ITERATIONS+")]");
    %title("B.1)", FontSize=15);
    xlabel("CM Raw residuals (x)");
    ylabel("Frequency(x)");
    ax=gca;
    fontsize(ax, "scale", 1.5);
    box on;
    hold off;
    
    % C.1)
    % ----------------------------------------------------------------------------------------------------------------------------
    nexttile
    hold on;
    %histogram(residuals_1(ITERATIONS_TO_SHOW:end),20, 'Normalization','pdf');
    h3 = histfit(residuals_1(ITERATIONS_TO_SHOW:end),20);
    h3(2).Color = [.2 .2 .2];
    h3(1).FaceColor ="#009E60";
    title(["C.1) CM Histogram plot of the tail ","(steady-state only) raw residuals;"],"time range: [2t* - t_{max}]");
    %title("C.1)", FontSize=15);
    xlabel("CM Raw residuals (x)");
    ylabel("Frequency(x)");
    ax=gca;
    fontsize(ax, "scale", 1.5);
    box on;
    hold off;

    % A.2)
    % ----------------------------------------------------------------------------------------------------------------------------
    nexttile
    hold on;
    n1 = normplot(residuals_1(1:ITERATIONS_TO_SHOW));
    props = get(n1,{'marker' 'linestyle' 'color'});
    set(n1, 'color', "#87A96B");
    legend(["x<Q1 or x> Q3","Q1<x<Q3", "x"], Location="northwest");
    NRMSE_CM = goodnessOfFit(MeanArray(1:ITERATIONS_TO_SHOW)', CM(1:ITERATIONS_TO_SHOW)', 'NRMSE'); %
    xlabel("CM Raw residuals (x)");
    ylabel("Probability(x)");
    title("A.2) CM Normal probability plot;", ["NRMSE: "+NRMSE_CM+";","time range: [t_0 - 2t* ("+ITERATIONS_TO_SHOW+")];"]);
    %title("A.2)", FontSize=15);
    ax=gca;
    fontsize(ax, "scale", 1.5);
    box on;
    hold off;
    
    % B.2)
    % ----------------------------------------------------------------------------------------------------------------------------
    nexttile
    hold on;
    n1 = normplot(residuals_1);
    props = get(n1,{'marker' 'linestyle' 'color'});
    set(n1, 'color', "#29AB87")
    legend(["x<Q1 or x> Q3","Q1<x<Q3", "x"], Location="northwest");
    NRMSE_CM = goodnessOfFit(MeanArray', CM', 'NRMSE'); %
    xlabel("CM Raw residuals (x)");
    ylabel("Probability(x)");
    title("B.2) CM Normal probability plot;", ["NRMSE: "+NRMSE_CM+";","time range: [t_0 - t_{max} ("+ITERATIONS+")];"]);
    %title("B.2)", FontSize=15);
    ax=gca;
    fontsize(ax, "scale", 1.5);
    box on;
    hold off;
    
    % C.2)
    % ----------------------------------------------------------------------------------------------------------------------------
    nexttile
    hold on;
    n1 = normplot(residuals_1(ITERATIONS_TO_SHOW:end));
    props = get(n1,{'marker' 'linestyle' 'color'});
    set(n1, 'color', "#009E60");
    legend(["x<Q1 or x> Q3","Q1<x<Q3", "x"], Location="northwest");
    NRMSE_CM = goodnessOfFit(MeanArray(ITERATIONS_TO_SHOW:end)', CM(ITERATIONS_TO_SHOW:end)', 'NRMSE'); %
    xlabel("CM Raw residuals (x)");
    ylabel("Probability(x)");
    title("C.2) CM Normal probability plot;", ["NRMSE: "+NRMSE_CM+";","time range: [2t* - t_{max}];"]);
    %title("C.2)", FontSize=15);
    ax=gca;
    fontsize(ax, "scale", 1.5);
    box on;
    hold off;

end

%}