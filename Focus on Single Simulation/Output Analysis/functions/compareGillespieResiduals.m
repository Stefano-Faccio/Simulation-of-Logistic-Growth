% This function takes as input the following arguments:
% 1) ITERATIONS
% 2) ITERATIONS_TO_SHOW, for subsequent time frames
% 3) Gillespie_Model_Times, iteration time means (time "points")
% 4) Gillespie_Model_Values, iteration means
% 5) gillespie_continuous_population, CM

% This function outputs the following 8 plots:
% 1) Big picture of the CM fitting of the experimental Gillepsie \mu(N_i) values

% 2) Difference in population (\DeltaN) between Gillespie \mu(N_i) values
% and CM growth per time unit (is the v-shape deeper or not?)

% A.1) CM Histogram plot of the head (short-term) raw residuals [t_0 - ~2t*]
% B.1) CM Histogram plot of the head+tail (long-term) raw residuals [t_0 - ~t_{max}]
% C.1) CM Histogram plot of the tail (steady-state only) raw residuals [2t* - ~t_{max}]
% A.2) CM Normal probability plot [t_0 - ~2t*]
% B.2) CM Normal probability plot [t_0 - ~t_{max}]
% C.2) CM Normal probability plot [2t* - ~t_{max}]

% normal probabilty plot of the raw residuals of the iteration means wrt to the continuous model
% adding the NRMSE that the experimental iteration means score
% (NRMSE is not enough if an analysis of residuals is not performed)

function compareGillespieResiduals(ITERATIONS,ITERATIONS_TO_SHOW,Gillespie_Model_Times, Gillespie_Model_Values, gillespie_continuous_population)
    
    figure;
    tl = tiledlayout(3,3);
    
    % 1)
    % ---------------------------------------------------------------------------------------------------------------------
    nexttile(1)
    hold on;
    box on;
    plot(Gillespie_Model_Times-1,Gillespie_Model_Values, ".", Color="#EC3B83");
    plot(Gillespie_Model_Times-1,gillespie_continuous_population, Color="#29AB87", LineWidth=2);
    xlabel("time");
    ylabel("\mu(N_i)");
    title(["1) Big picture of the CM fitting of the"," experimental Gillepsie \mu(N_i) values"]);
    %title("1)", FontSize=15);
    ax= gca;
    fontsize(ax, "scale", 1.25);
    axis tight;
    hold off;
    
    % 2)
    % ---------------------------------------------------------------------------------------------------------------------
    nexttile(2)
    hold on;
    plot(Gillespie_Model_Times-1,Gillespie_Model_Values-gillespie_continuous_population, ".",Color="#29AB87", LineWidth=1.5);
    box on;
    yline(0, '-', '\DeltaN=0',Color="#8C92AC",LineWidth=1.25);
    ylabel("\DeltaN");
    xlabel("t (time) - units");
    title(["2) Difference in population (\DeltaN) between Gillespie","\mu(N_i) values and CM growth per time unit;"]);
    %title("2)", FontSize=15);
    legend("CM Raw residuals", Location="southeast");
    axis tight;
    ax= gca;
    fontsize(ax, "scale", 1.25);
    hold off;

    % A.1)
    % ---------------------------------------------------------------------------------------------------------------------
    Gillespie_Model_Times_Head = Gillespie_Model_Times(Gillespie_Model_Times-1<= ITERATIONS_TO_SHOW); % match the head
    nexttile(4)
    hold on;
    residuals_1 = Gillespie_Model_Values-gillespie_continuous_population;
    histogram(residuals_1(1:length(Gillespie_Model_Times_Head)),20, 'Normalization','pdf', FaceColor="#87A96B");
    %disp(length(Gillespie_Model_Times_Head));
    box on;
    title(["A.1) CM Histogram plot of the head ","(short-term) raw residuals;"],"time range: [t_0 - 2t* (~"+ITERATIONS_TO_SHOW+")]");
    %title("A.1)", FontSize=15);
    xlabel("CM Raw residuals (x)");
    ylabel("Frequency(x)");
    ax= gca;
    fontsize(ax, "scale", 1.25);
    hold off;
    
    % B.1)
    % ---------------------------------------------------------------------------------------------------------------------
    nexttile(5)
    hold on;
    histogram(residuals_1, 20, 'Normalization','pdf',FaceColor="#29AB87");
    box on;
    title(["B.1) CM Histogram plot of the head+tail ","(long-term) raw residuals;"],"time range: [t_0 - t_{max} (~"+ITERATIONS+")]");
    %title("B.1)", FontSize=15);
    xlabel("CM Raw residuals (x)");
    ylabel("Frequency(x)");
    ax= gca;
    fontsize(ax, "scale", 1.25);
    hold off;
    
    % C.1)
    % ---------------------------------------------------------------------------------------------------------------------
    Gillespie_Model_Times_tail = Gillespie_Model_Times(Gillespie_Model_Times-1 >=ITERATIONS_TO_SHOW); % match the steady state
    %disp(length(Gillespie_Model_Times_tail));
    nexttile(6)
    hold on;
    %histogram(residuals_1(end-length(Gillespie_Model_Times_tail):end),20, 'Normalization','pdf');
    h3 = histfit(residuals_1(end-length(Gillespie_Model_Times_tail):end),20);
    h3(2).Color = [.2 .2 .2];
    h3(1).FaceColor = "#009E60";
    box on;
    title(["C.1) CM Histogram plot of the tail ","(steady-state only) raw residuals;"],"time range: [2t* - t_{max}]");
    %title("C.1)", FontSize=15);
    xlabel("CM Raw residuals (x)");
    ylabel("Frequency(x)");
    ax= gca;
    fontsize(ax, "scale", 1.25);
    hold off;

    % A.2)
    % ---------------------------------------------------------------------------------------------------------------------
    NRMSE_CM = goodnessOfFit(Gillespie_Model_Values(1:length(Gillespie_Model_Times_Head))', gillespie_continuous_population(1:length(Gillespie_Model_Times_Head))', 'NRMSE'); %
    nexttile(7)
    hold on;
    n1 = normplot(residuals_1(1:length(Gillespie_Model_Times_Head)));
    props = get(n1,{'marker' 'linestyle' 'color'});
    set(n1, 'color', "#87A96B");
    legend(["x<Q1 or x> Q3","Q1<x<Q3", "x"], Location="northwest");
    xlabel("CM Raw residuals (x)");
    ylabel("Probability(x)");
    title("A.2) CM Normal probability plot;", ["NRMSE: "+NRMSE_CM+";","time range: [t_0 - 2t* (~"+ITERATIONS_TO_SHOW+")];"]);
    %title("A.2)", FontSize=15);
    box on;
    ax= gca;
    fontsize(ax, "scale", 1.15);
    hold off;

    % B.2)
    % ---------------------------------------------------------------------------------------------------------------------
    NRMSE_CM = goodnessOfFit(Gillespie_Model_Values', gillespie_continuous_population', 'NRMSE'); %
    nexttile(8)
    hold on;
    n1 = normplot(residuals_1);
    props = get(n1,{'marker' 'linestyle' 'color'});
    set(n1, 'color', "#29AB87");
    legend(["x<Q1 or x> Q3","Q1<x<Q3", "x"], Location="northwest");
    xlabel("CM Raw residuals (x)");
    ylabel("Probability(x)");
    title("B.2) CM Normal probability plot;", ["NRMSE: "+NRMSE_CM+";","time range: [t_0 - t_{max} (~"+ITERATIONS+")];"]);
    %title("B.2)", FontSize=15);
    box on;
    ax= gca;
    fontsize(ax, "scale", 1.15);
    hold off;
    
    % C.2)
    % ---------------------------------------------------------------------------------------------------------------------
    NRMSE_CM = goodnessOfFit(Gillespie_Model_Values(end-length(Gillespie_Model_Times_tail):end)', gillespie_continuous_population(end-length(Gillespie_Model_Times_tail):end)', 'NRMSE'); %
    nexttile(9)
    hold on;
    n1 = normplot(residuals_1(end-length(Gillespie_Model_Times_tail):end));
    props = get(n1,{'marker' 'linestyle' 'color'});
    set(n1, 'color', "#009E60");
    legend(["x<Q1 or x> Q3","Q1<x<Q3", "x"], Location="northwest");
    xlabel("CM Raw residuals (x)");
    ylabel("Probability(x)");
    title("C.2) CM Normal probability plot;", ["NRMSE: "+NRMSE_CM+";","time range: [2t* - t_{max}];"]);
    %title("C.2)", FontSize=15);
    box on;
    ax= gca;
    fontsize(ax, "scale", 1.15);
    hold off;

end