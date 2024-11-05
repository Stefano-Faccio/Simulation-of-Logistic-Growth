% This function is legacy.
% Given the fitted model,
% it performs a complete analysis of the residuals
function residualTest(mdl,residuals)
    % Residuals are useful for detecting outlying y values and checking the linear regression assumptions with respect to the error term in the regression model. 
    % High-leverage observations have smaller residuals because they often shift the regression line or surface closer to them. 
    % You can also use residuals to detect some forms of heteroscedasticity and autocorrelation.
    % Errors in linear regression should have equal variance at all values of the predictor and should be normally distributed
    % equal variance: look at residual plot
    % normality: look at normal probability of residuals
    
    % histogram of residuals
    % Histogram of residuals using probability density function scaling. 
    % The area of each bar is the relative number of observations. 
    % The sum of the bar areas is equal to 1.
    figure;
    hold on;
    plotResiduals(mdl, 'histogram')
    hold off;
    
    %Create a normal probability plot of the residuals of the fitted model.
    plotResiduals(mdl,'probability')
    
    %Plot the residuals versus lagged residuals.
    figure;
    hold on;
    plotResiduals(mdl,'lagged')
    hold off;
    
    % Plot the residuals versus the fitted values.
    % Analysis of Variance, Visually testing the homogeneity assumption
    figure;
    hold on;
    plotResiduals(mdl,'fitted')
    hold off;
    
    % add normality as a discriminant
    h1 = adtest(residuals);
    h2 = lillietest(residuals);
    figure;
    hold on;
    title(["Analysis of Variance", "Visually testing the normality assumption (histogram)", "Null hypothesis (0): the data is from a population with a normal distribution", "Lilliefors test result: " + h1 + ";", "Anderson-Darling test result: "+ h2 + ";"])
    h = histfit(residuals);
    h(1).FaceColor = '#2A9B9D';
    xlabel("residuals")
    ylabel("frequency")
    hold off;
    
    figure;
    hold on;
    title(["Analysis of Variance", "Visually testing the normality assumption (Normal Q-Q)"])
    qqplot(residuals)
    hold off;
    
    
    % Plot the box plot of all four types of residuals.
    %first: Raw (Observed minus fitted values)
    %second: Pearson (Raw residuals divided by the root mean squared error)
    %third: Standardized (Raw residuals divided by their estimated standard deviation)
    %fourth: Studentized (Raw residuals divided by an independent estimate of the residual standard deviation)
    
    figure;
    hold on;
    Res = table2array(mdl.Residuals);
    boxplot(Res)
    title_ = ["Box plot of all four types of resdiduals", "1) Raw 2) Pearson 3) Standardized 4) Studentized"];
    title(title_);
    hold off;
    
    % independence (time series)
    % Check Residuals for Autocorrelation
    % As an informal check, you can plot the sample autocorrelation function (ACF) and partial autocorrelation function (PACF). 
    % If either plot shows significant autocorrelation in the residuals, 
    % you can consider modifying your model to include additional autoregression or moving average terms.
    
    figure;
    % Enlarge figure to full screen.
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    % Give a name to the title bar.
    set(gcf, 'Name', 'Demo by ImageAnalyst', 'NumberTitle', 'Off') 
    title(["Analysis of Variance", "Visually testing the independence assumption", "Autocorrelation"])
    subplot(3,1,1)
    autocorr(residuals, NumMA=2, NumLags=20);
    title("Sample autocorrelation Function: MA(2) process");
    subplot(3,1,2)
    parcorr(residuals, NumLags=20);
    %subsampled
    subplot(3,1,3)
    autocorr(residuals(2:2:end),NumLags=20);
    title("Sample autocorrelation Function: subsample");
    
    % Check Residuals for Conditional Heteroscedasticity
    % As an informal check, you can plot the sample ACF and PACF of the squared residual series. 
    % If either plot shows significant autocorrelation,
    % you can consider modifying your model to include a conditional variance process.
    
    figure;
    % Enlarge figure to full screen.
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    % Give a name to the title bar.
    set(gcf, 'Name', 'Demo by ImageAnalyst', 'NumberTitle', 'Off') 
    title(["Analysis of Variance", "Visually testing the homogeneity assumption", "Conditional heteroscedasticity"])
    subplot(3,1,1)
    autocorr(residuals.^2, NumMA=2, NumLags=20);
    title("Sample autocorrelation Function: MA(2) process");
    %subsampled
    subplot(3,1,2)
    parcorr(residuals.^2, NumLags=20);
    subplot(3,1,3)
    autocorr(residuals(2:2:end).^2, NumLags=20);
    title("Sample autocorrelation Function: subsample");

end