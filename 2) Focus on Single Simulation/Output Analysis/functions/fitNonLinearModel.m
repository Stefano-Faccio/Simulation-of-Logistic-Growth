% This function is legacy and takes the following input arguments:
% 1) pickedSimArr, or iteration means
% 2) t, TIME
% 3) r, GROWTH_RATE
% 4) K, CARRYING_CAPACITY
% 5) N_0, START_POPULATION
% 6) N_t, continuous model population values
% 7) iterCut, or ITERATIONS_TO_SHOW (up to 2t*)

% This function outputs information/plots about the non-linear fit and the
% residuals
% especially estimated growth rate and carrying capacity

function [est_K, est_r, residualsStd, est_K_SE, est_r_SE, est_K_Tstat, est_r_Tstat, est_K_pValue , est_r_pValue, est_K_CI, est_r_CI  ] = fitNonLinearModel(pickedSimArr, t, r, K, N_0, N_t, iterCut)
    
    modelfun = @(b,x) (b(1) * N_0) ./ ( (b(1) - N_0) .* exp((-b(2)) .* x) + N_0 );
    
    kappa = 5000;
    erre = 0.05;

    beta0 = [kappa,erre]; % ATTENZ
    
    mdl1 = fitnlm(t(1:iterCut), pickedSimArr(1:iterCut),modelfun, beta0);
    %[p,DW] = dwtest(mdl1,'exact', 'both');
    %disp("The value of the Durbin-Watson test statistic is" + DW + "The p-value is "+ p +";");
    
    %{
    plotDiagnostics(mdl1,'cookd')
    %}

    est_K = table2array(mdl1.Coefficients("b1",1)); 
    est_r = table2array(mdl1.Coefficients("b2",1)); 
    residuals = mdl1.Residuals.Raw; 
    
    yFit = (est_K * N_0) ./ ( (est_K - N_0) .* exp((-est_r) .* t(1:iterCut)) + N_0 ); %
    
    % residual standard deviation
    % small values of SE imply that the points are clustered relatively close
    % to the regression line
    n = mdl1.NumObservations;
    % same as RMSE
    residualsStd = sqrt((sum(residuals.^2))/(n-2));
    rootMeanSquaredE = mdl1.RMSE;
    
    disp(mdl1)
    disp("RSE " + residualsStd)
    
    est_K_SE = table2array(mdl1.Coefficients("b1",2)); 
    est_r_SE = table2array(mdl1.Coefficients("b2",2)); 
    
    est_K_Tstat= table2array(mdl1.Coefficients("b1",3)); 
    est_r_Tstat = table2array(mdl1.Coefficients("b2",3));
    
    est_K_pValue = table2array(mdl1.Coefficients("b1",4)); 
    est_r_pValue = table2array(mdl1.Coefficients("b2",4));
    
    %{
    figure;
    hold on;
    scatter(t(1:iterCut), residuals);
    xlabel("Population (N)")
    ylabel("residuals")
    title("Testing Independence for tTest of the slope")
    hold off;
    %}
    
    % A significant relationship exists between X and Y 
    % if the confidence interval does not contain zero.
    ci = coefCI(mdl1);
    est_K_CI = ci(1,:);
    est_r_CI = ci(2,:);
    
    
    % Plot with both confidence intervals and prediction intervals
    
    figure ;
    hold on ;
    plot(t(1:iterCut),mdl1.Fitted,"k.","LineWidth",1,"DisplayName","Fit") ;
    [ypred,yci_curve]=predict(mdl1, t(1:iterCut)', 'Alpha',0.05,"Prediction","curve");
    [~,yci_obs]=predict(mdl1,t(1:iterCut)','Alpha',0.05,"Prediction","observation");
    xlabel("t")
    ylabel("N")
    axis tight;
    plot(t(1:iterCut),yci_curve,"g--.","DisplayName","Confidence bounds") ;
    plot(t(1:iterCut),yci_obs,"b--","DisplayName","Prediction bounds") ;
    title_ = ["Non Linear Regression Model", "Theoretical K: " + K + "; r: " + r + ";", "Fitted K: " + est_K  + "; r: " + est_r + ";"];
    title(title_)
    hold off ;
    legend ;
    %}
    
    
    % PLot with theoretical line and confidence intervals
    figure;
    hold on;
    plot(t(1:iterCut),mdl1.Fitted,"k.","LineWidth",1,"DisplayName","Fit") ;
    plot(t(1:iterCut), N_t(1:iterCut),"DisplayName","Theoretical curve")
    plot(t(1:iterCut),yci_curve,"g--.","DisplayName","Confidence bounds") ;
    title_ = ["Non Linear Regression Model", "Theoretical K: " + K + "; r: " + r + ";", "Fitted K: " + est_K  + "; r: " + est_r + ";"];
    title(title_)
    hold off;
    legend ;
    
    
    residualTest(mdl1,residuals)
    
    
end