% This function is legacy and takes the following input arguments:
% 1) pickedSimArr, or iteration means
% 2) t, TIME
% 3) r, GROWTH_RATE
% 4) K, CARRYING_CAPACITY
% 5) iterCut, or ITERATIONS_TO_SHOW (up to 2t*)


% This function outputs information relative to the fitted linear model,
% especially estimated growth rate (intercept)
% and estimated -crowding coefficient (slope)
% along with plots for visual assessment of the fit and the residuals.
function [residualsStd,fitIntercept, fitSlope, fitInterceptCI, fitSlopeCI, fitInterceptSE, fitSlopeSE, fitInterceptTstat, fitSlopeTstat, fitSlopePvalue, mdl] = fitLinearModel(pickedSimArr, t, r, K, iterCut)
    
    tableTN = [t(1:iterCut);pickedSimArr(1:iterCut)]';
    dist=2;
    
    W = [];
    X = [];
    Y = [];
    
    if rem(iterCut,2) == 0
        stop = iterCut-(2*dist);
    else
        stop = iterCut-(2*dist)-1;
    end

   
    
    % Calculate the ratios of slopes to function values.
    for i=1:stop
        j = i+dist;
        value = (tableTN(j+dist,2) - tableTN(j-dist,2)) / (2 * dist * tableTN(j,2));
        W = [W tableTN(j,1)];
        X = [X tableTN(j,2)];
        Y = [Y value];
    end
    
    % make a table of X and Y: values in Y may be an approximately linear
    % function of X.
    estimates = table(W(:),X(:),Y(:));
    disp("Size of estimate table " + size(estimates))
    estimates.Properties.VariableNames = ["t","N", "(dN/dt)*1/N"];
    
    % assumption linear relationship between N and (dN/dt) *1/N
    % slope is -C
    m = -r/K;
    % intercept is r
    b = r;
    theoreticalLine = @(x)(m .* x + b);   
    
    disp("b1 (slope) " + m)
    disp("b0 (intercept) " + b)

    estimates(:,[2 3])
    
    % linear model fitting
    % significant relationsship
    mdl = fitlm(estimates(:,[2 3]), 'linear');
    %{
    [p,DW] = dwtest(mdl,'exact','both');
    disp("The value of the Durbin-Watson test statistic is" + DW + "The p-value is "+ p +";");
    %}
    disp(mdl)
    fitIntercept = table2array(mdl.Coefficients("(Intercept)",1));
    fitSlope = table2array(mdl.Coefficients("N",1));
    fitK = - (fitIntercept / fitSlope);
    residuals = mdl.Residuals.Raw;
    yFit = fitSlope.* X + fitIntercept;
    
    % residual standard deviation
    % small values of SE imply that the points are clustered relatively close
    % to the regression line
    n = mdl.NumObservations;
    % same as RMSE
    residualsStd = sqrt((sum(residuals.^2))/(n-2));
    rootMeanSquaredE = mdl.RMSE;
    
    % What does the residual standard deviation mean in context?
    % we have N(x) and dN/dt*1/N(y) so 
    % a typical (simmetric difference) will tend to deviate from its predicted value 
    % on the regression line by about RMSE.
    %Value on the line is the best prediction, 
    % but values within RMSE of that prediction are not unexpected.
    
    fitInterceptSE = table2array(mdl.Coefficients("(Intercept)",2));
    % Standard Error of the Slope: 
    % measure of how different the slope of a regression line 
    % tends to be from the true population slope
    % Slopes will be less variable with a smaller residual standard deviation, 
    % larger spread of the predictor, 
    % and larger sample size.
    % What does the standard error mean in context?
    % While bla is the best estimate for the slope, slopes as low bla-SE or as high as bla+SE would not be surprising.
    fitSlopeSE = table2array(mdl.Coefficients("N",2));
    
    fitInterceptTstat= table2array(mdl.Coefficients("(Intercept)",3));
    % t-test for the regression slope
    % A significant relationship exists between two quantitative variables in regression 
    % if the slope of the regression line by is significantly different from 0.
    % linearity: data follows a moderate negative linear trend
    % independence: N and residuals
    % equal variance of residuals
    % normality

    
    figure;
    hold on;
    scatter(X, residuals);
    xlabel("Population (N)")
    ylabel("residuals")
    title("Testing Independence for tTest of the slope")
    hold off;
    
    

    fitSlopeTstat = table2array(mdl.Coefficients("N",3));
    fitSlopePvalue = table2array(mdl.Coefficients("N",4));
    % we reject Ho and conclude that the number of population 
    % is linearly related to the simmetric differences. 
    % Given the slope of bla, the relationship is negative.
    
    % A significant relationship exists between X and Y 
    % if the confidence interval does not contain zero.
    ci = coefCI(mdl);
    fitInterceptCI = ci(1,:);
    fitSlopeCI = ci(2,:);
    
    % We are 95% confident that the true decrease in simmetric difference
    % is between lowerCI and upperCi for every additional number of pupulation
    
    % Confidence interval on the regression line
    % an interval estimate that provides a range of plausible values 
    % for where the mean of all responses at particular value of the predictor will fall
    
    % prediction interval on the regression line
    % an interval estimate that provides a range of plausible values for where 
    % a single response will fall given a particular value of the predictor
    
    % Plot with both confidence intervals and prediction intervals

    
    figure ;
    plot(X,mdl.Fitted,"k.","LineWidth",1,"DisplayName","Fit") ;
    [ypred,yci_curve]=predict(mdl,X',"Prediction","curve");
    [~,yci_obs]=predict(mdl,X',"Prediction","observation");
    xlabel("N")
    ylabel("(1/N)*dN/dt")
    axis tight;
    hold on ;
    plot(X,yci_curve,"g--.","DisplayName","Confidence bounds") ;
    plot(X,yci_obs,"b--","DisplayName","Prediction bounds") ;
    title_ = ["Linear Regression Model", "Theoretical slope: " + m + "; intercept: " + b + ";", "Fitted slope: " + fitSlope + "; intercept: " + fitIntercept + ";", "Theoretical K: " + K + "; r: " + r + ";", "Fitted K: " + fitK  + "; r: " + fitIntercept + ";"];
    title(title_)
    legend ;
    hold off ;
    

    % PLot with theoretical line and confidence intervals
    
    figure;
    hold on;
    plot(mdl)
    plot(X, theoreticalLine(X))
    legend("Data", "Fit", "Confidence Bounds", "theoretical line")
    title_ = ["Linear Regression Model", "Theoretical slope: " + m + "; intercept: " + b + ";", "Fitted slope: " + fitSlope + "; intercept: " + fitIntercept + ";", "Theoretical K: " + K + "; r: " + r + ";", "Fitted K: " + fitK  + "; r: " + fitIntercept + ";"];
    title(title_)
    hold off;
    
    residualTest(mdl,residuals);
   
    
end
