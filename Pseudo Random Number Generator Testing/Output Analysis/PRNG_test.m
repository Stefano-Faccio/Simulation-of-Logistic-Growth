clear;

% for reproducibility
rng(3,"twister");

% Import data from PRNG (Mersenne Twister) generator test
% 100 simulations (so 100 sequential prime number seeds)
data = importdata("data.txt");
% Given that we performed 501 iterations, 500 of which throw 2
% probabilities from the uniform distribution per creature, 
% one for R and the other for cN, and
% that the maximum "stable" population should be around 5000 (L) in the "worst" case,
% we generated 500 (iterations) x 100 (stable population) x 2 (thrown
% probabilities) data points per simulation
% to assess the performance of the PRNG (on 100000 x 100 total data points) 
% on a global scale.
% No more could be done, due to time and computational costs.
% The ideal would have been to generate 500 x 5000 x 2 x 100(0) data points
% and check the correlation between each stream (corresponding to 1
% simulation, so 1 seed) with matlab corr()
% its uniform distribution, with matlab kstest() and chi2gof()
% and its randomness, with matlab runstest()

nSample = size(data, 1) - 1;
disp("The number of data points generated per simulation (PRNG stream) is: " + nSample+ ";"); 
nSeed = size(data, 2);
disp("The number of simulations (and sequantial prime numbers seeds) is: " + nSeed+ ";"); 
dataOnly = data(2:end,:);

%%
% Data points from different streams should not be correlated
% Spearman rank correlation coefficient
% Assumption: Non-parametric and does not assume a linear relationship but assumes a monotonic relationship.
% Use Case: Appropriate for both continuous and ordinal data. Particularly useful when the relationship is expected to be monotonic but not necessarily linear.
% Strength: Robust to outliers and non-linearity.
% Formula: Calculates the correlation based on the ranks of data points.
% Interpretation: Measures the strength and direction of the monotonic relationship, similar to Kendall’s Tau.

[rhoS, rhoSpValue] = corr(dataOnly,'Type','Spearman');
%heatmap(rhoS)
significantCorrS = numel(rhoS(rhoS>=0.01|rhoS<=-0.01));
significantCorrS_ = significantCorrS-nSeed;
disp("Spearman correlation matrix: " + significantCorrS_ + " out of " +nSeed^2 + " possible couples, excluding the main diagonal, have rs greater or equal than |0.01|")
significantCorrPercentS = ((significantCorrS_)/(height(rhoS)*width(rhoS))) * 100;

%%
% Data points from different streams should not be correlated
% Pearson correlation coefficient
% Assumption: Assumes a linear relationship and that data is normally distributed.
% Use Case: Suitable for continuous data when you want to measure linear associations.
% Strength: Sensitive to linear relationships, good for capturing linear trends.
% Formula: Based on covariance and standard deviations of the original data.
% Interpretation: Measures the strength and direction of the linear relationship, 
% ranging from -1 (perfect negative correlation) to 1 (perfect positive correlation), 
% with 0 indicating no linear correlation.

[rhoP, rhoPpValue] = corr(dataOnly,'Type','Pearson');
%heatmap(rhoP)
significantCorrP = numel(rhoP(rhoP>=0.01 | rhoP<= -0.01));
significantCorrP_ = significantCorrP-nSeed;
disp("Pearson correlation matrix: " + significantCorrP_ + " out of " +nSeed^2 + " possible couples, excluding the main diagonal, have r greater or equal than |0.01|")
significantCorrPercentP = ((significantCorrP_)/(height(rhoP)*width(rhoP))) * 100;

% Both correlation coefficient entail that there is no significant
% correlation between each stream.

%%

% Run test for randomness (runstest)
% returns a test decision for the null hypothesis that the values in the data vector x 
% come in random order, against the alternative that they do not. 
% The test is based on the number of runs of consecutive values above or below the mean of x. 
% The result is 1 if the test rejects the null hypothesis at the 5% significance level, or 0 otherwise.
% We want to score as much zeros as possible.


% One-sample Kolmogorov-Smirnov test (kstest)
% returns a test decision for the null hypothesis that the data in vector x 
% comes from a uniform distribution, against the alternative that it does
% not come from such a distribution.
% The result is 1 if the test rejects the null hypothesis at the 5% significance level, or 0 otherwise.
% We want to score as much zeros as possible.


% Chi-square goodness-of-fit test (chi2gof)
% returns a test decision for the null hypothesis that the data in vector x 
% comes from a uniform distribution with a mean and variance estimated from x, 
% using the chi-square goodness-of-fit test. 
% The alternative hypothesis is that the data does not come from such a distribution. 
% The result is 1 if the test rejects the null hypothesis at the 5% significance level, and 0 otherwise.
% We want to score as much zeros as possible.

colors = ["#0072BD", "#D95319", "#EDB120", "#7E2F8E", "#77AC30", "#4DBEEE", "#A2142F"];
colorsCounter = 1;
%dataTot = zeros(nSample, 1);
dataTot = [];
randomTestRes = [];
%randomTestPvalues = [];
ksTestRes = [];
pd = makedist('uniform');
chi2TestRes = [];

for i = 1 : nSeed
    dataNow = data(:, i);
    nowSeed = dataNow(1);
    dataNow = dataNow(2:end);
    [h, p, stats] = runstest(dataNow);
    ks = kstest(dataNow,'CDF',pd);
    chi2 = chi2gof(dataNow,"CDF",pd);
    randomTestRes = [randomTestRes h];
    %randomTestPvalues = [randomTestPvalues p];
    ksTestRes = [ksTestRes ks];
    chi2TestRes = [chi2TestRes chi2];
    % Sum all data points (100000 x 100)
    dataTot = [dataTot; dataNow];
    % Plot histogram of first and last seed
    if i == 1 || i == nSeed 
        plotAll(dataNow, strcat(' seed:  ', num2str(nowSeed,'%d')), colors(colorsCounter));
        colorsCounter = mod(colorsCounter, length(colors)) + 1;
    end
end
% Plot all data
plotAll(dataTot, ' multiple seed', colors(colorsCounter));
%%

randomTestValues = histcounts(randomTestRes);
randomTestFail = sum(randomTestRes(:) == 1) / numel(randomTestRes) * 100;
randomTestSuccess = sum(randomTestRes(:) == 0) / numel(randomTestRes) * 100; % null hypothesis random
disp("Run test for randomness (runstest) success percentage: " + randomTestSuccess+ "%;");

ksTestValues = histcounts(ksTestRes);
ksTestFail = sum(ksTestRes(:) == 1) / numel(ksTestRes) * 100;
ksTestSuccess = sum(ksTestRes(:) == 0) / numel(ksTestRes) * 100; % null hypothesis uniform
disp("One-sample Kolmogorov-Smirnov test (kstest) success percentage: " + ksTestSuccess+ "%;");


chi2TestValues = histcounts(chi2TestRes);
chi2TestFail = sum(chi2TestRes(:) == 1) / numel(chi2TestRes) * 100;
chi2TestSuccess = sum(chi2TestRes(:) == 0) / numel(chi2TestRes) * 100; % null hypothesis uniform
disp("Chi-square goodness-of-fit test (chi2gof) success percentage: " + chi2TestSuccess+ "%;");
%%

