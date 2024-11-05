%% Output analysis main
% for reproducibility
rng(1,"twister");
addpath("functions\");

%% Theory of the logistic growth model

%% 
% Plot theoretical graphs for discrete and continuous growth (unbounded)
t = 1:1:50;
N_0 = 5;
%k =log(1+r);
compareExpGrowths(1,0.6931,N_0,t)
compareExpGrowths(0.5,0.4055,N_0,t)
compareExpGrowths(0.1,0.0953,N_0,t)
% Closest approximation of continuous growth by discrete growth
compareExpGrowths(0.05,0.0488,N_0,t)

%%
% PLot slope field (SF) for logistic equation or logistic curve (Curve)
tmax = 100;
Nmax = 60;
Nmin = -10;
N_0 = 4;
k = 0.05;
C = 0.001;

plotLogSForCurve(tmax,Nmax,Nmin,k,C,N_0,"curve");
%plotLogSForCurve(tmax,Nmax,Nmin,k,C,N_0,"sf")

%% 
% Phase plot for logistic equation
L=k/C;
t=0:1:100;
xlimit=L+5;
phasePlot(k,C,N_0,t,xlimit);

%%
% Comparison of continuous and discrete plots for theoretical logistic
% growth (bounded)

% inflection time formula
coeff =(L/N_0)-1;
tmax=400;
inflection_t = ceil((-1/k)*log(1/coeff));

compareLogGrowths(k,N_0,L,inflection_t, tmax);

%% Single Simulation Output data load & formatting

clear;
close all;
clc;

% for reproducibility
rng(1,"twister");
path_header = 'header.txt';
path_data = 'data.txt';

% read header
my_header = readtable(path_header);
NSIMULATIONS = my_header.(1);
ITERATIONS = my_header.(2);
START_POPULATION = my_header.(3);
CROWDING_COEFFICIENT = my_header.(4);
REPRODUCTION_PROBABILITY = my_header.(5);
DEATH_PROBABILITY = my_header.(6);
GROWTH_RATE = REPRODUCTION_PROBABILITY - DEATH_PROBABILITY;
CARRYING_CAPACITY = GROWTH_RATE/CROWDING_COEFFICIENT;
INFLECTION_TIME = ceil(log((CARRYING_CAPACITY - START_POPULATION)/START_POPULATION)/GROWTH_RATE);
ITERATIONS_TO_SHOW = 2*INFLECTION_TIME;
INFLECTION_POPULATION = CARRYING_CAPACITY/2;
TIME = 0:1:ITERATIONS-1;

% System (with chosen parameters) output data
% Table: simulations x iterations (1000 x 501)
% Each column contains all population values at the same iteration (time)
all_my_data = readtable(path_data);

% Transposed Table: iterations x simulations
% Each column contains a whole simulation (501 x 1000)
all_my_data_t = rows2vars(all_my_data);
all_my_data_t = all_my_data_t(:,2:end);

%% SimulationS (from time0 to ITERATIONS)

colors = ["#C0C0C0" "#E6194B" "#008080" "#3CB44B" "#FFE119" "#4363D8" "#F58231" "#911EB4" "#46F0F0" "#F032E6" "#BCF60C" "#FABEBE" "#42D4F4"  "#AAFFC3" "#A9A9A9" "#DCBEFF" "#473A4E"]; 

% Plot of the experimental logistic growthS against the theoretical one

% qualitative evaluation (all iterations) 
% - simulation means 
% - Grand mean of the simulation means -> Simulation grand mean
[simulationGrandMean, simulationMean]  = plotLogSimulation(all_my_data_t, NSIMULATIONS , ITERATIONS, ITERATIONS, 0, colors, "", INFLECTION_POPULATION, INFLECTION_TIME);

% qualitative evaluation (for a chosen number of first n iterations) 
% iteration cut at 2* inflection time

[nSimulationGrandMean, nSimulationMean]  = plotLogSimulation(all_my_data_t, NSIMULATIONS ,ITERATIONS, ITERATIONS_TO_SHOW, 0, colors, "", INFLECTION_POPULATION, INFLECTION_TIME);

%% IterationS (from simulation0 to NSIMULATIONS)

% Plot of the experimental logistic growthS against the theoretical one

exponential_population = START_POPULATION*exp(GROWTH_RATE.*TIME);
ymin=0;
ymax=CARRYING_CAPACITY+400;

% Continuous model (x:R -> y:R) 
continuous_model = @(b,x) (b(1) * START_POPULATION) ./ ( (b(1) - START_POPULATION) .* exp((-b(2)) .* x) + START_POPULATION );
continuous_population =  continuous_model([CARRYING_CAPACITY GROWTH_RATE],TIME);

%figure;
%tiledlayout(2,1)
%nexttile

% qualitative evaluation (all iterations) 
% - Iteration means (\mu(N_i) values)
% - Grand mean of the iteration means -> Iteration grand mean
[iterationGrandMean,iterationMean, iterationVar]  = plotLogIteration(all_my_data_t, exponential_population, continuous_population, NSIMULATIONS, ITERATIONS, ITERATIONS, 0, colors,ymin,ymax, CROWDING_COEFFICIENT,REPRODUCTION_PROBABILITY,DEATH_PROBABILITY,START_POPULATION,INFLECTION_POPULATION, INFLECTION_TIME);

%nexttile
% qualitative evaluation (for a chosen number of first n iterations) 
% iteration cut at 2* inflection time
[nIterationGrandMean,nIterationMean]  = plotLogIteration(all_my_data_t, exponential_population, continuous_population, NSIMULATIONS, ITERATIONS, ITERATIONS_TO_SHOW, 0, colors,ymin,ymax, CROWDING_COEFFICIENT,REPRODUCTION_PROBABILITY,DEATH_PROBABILITY,START_POPULATION, INFLECTION_POPULATION, INFLECTION_TIME);

% Iteration grand mean = Simulation grand mean

% Matlab built-in Bootstrap method to obtain 95% CI for each iteration mean
% (\mu(N_i) values)
ci95_iterationMean = bootci(NSIMULATIONS, {@mean, table2array(all_my_data)});
ci95_iterationMean_down = iterationMean - ci95_iterationMean(1, :);
ci95_iterationMean_up = ci95_iterationMean(2, :) - iterationMean;

%% 
% 95% confidence intervals for each iteration mean value saved as
% Supplementary Table 2 for the final report
suppTable2 =  table(iterationMean', ci95_iterationMean(1, :)',ci95_iterationMean(2, :)');
writetable(suppTable2,'SupplementaryTable2.csv','WriteRowNames',true);  
%%
% Matlab built-in Bootstrap method to obtain 95% CI for each iteration
% variance (\sigma^2(N_i))
ci95_iterationVar = bootci(NSIMULATIONS, {@var, table2array(all_my_data)});
ci95_iterationVar_down = iterationVar - ci95_iterationVar(1, :);
ci95_iterationVar_up = ci95_iterationVar(2, :) - iterationVar;
%%
% 95% confidence intervals for each iteration variance value saved as
% Supplementary Table 3 for the final report
suppTable3 =  table(iterationVar', ci95_iterationVar(1, :)',ci95_iterationVar(2, :)');
writetable(suppTable3,'SupplementaryTable3.csv','WriteRowNames',true);  

%%
% Box plot of the iteration means and variances distribution. 
% A) Long-term behaviour included vs. B) excluded.

% What is the impact of the tail?

% A) Long-term behaviour included
tiledlayout(1,2)
nexttile
hold on;
b1 = boxchart([iterationMean', iterationVar'],'Notch','on', 'MarkerStyle','.', 'JitterOutliers','on','BoxFaceColor', "k",'MarkerColor', "#6E7F80");
ax = gca;
xticklabels(ax,{"\mu(N_i)", "\sigma^2(N_i)"});
fontsize(ax, scale=2.4);
xlabel(["Population (N) values"," time range: t_0 - t_{max}"])
title(["A) Box plot of iteration means \mu(N_i)","and variances \sigma^2(N_i)"], "Long-term behaviour included", FontSize= 24)
box on;
hold off;

% The number of outliers for the iteration means is 99 out of 501 data
% points: 19.7605% (with tail)
iterationMeanOutliers = isoutlier(iterationMean, 'quartiles');
nMeanOutliers = histcounts(iterationMeanOutliers);
disp("The number of outliers for the iteration means is " + nMeanOutliers(1,2) + " out of "+ ITERATIONS+ " data points: " + (nMeanOutliers(1,2)/ITERATIONS).*100 + "%");

% The number of outliers for the iteration variances is 151 out of 501 data
% points: 30.1397% (with tail)
iterationVarOutliers = isoutlier(iterationVar, 'quartiles');
nVarOutliers = histcounts(iterationVarOutliers);
disp("The number of outliers for the iteration variances is " + nVarOutliers(1,2) + " out of "+ ITERATIONS+ " data points: " + (nVarOutliers(1,2)/ITERATIONS).*100 + "%");

% A) Long-term behaviour excluded
nexttile
hold on;
b2 = boxchart([iterationMean(1:ITERATIONS_TO_SHOW)', iterationVar(1:ITERATIONS_TO_SHOW)'],'Notch','on','MarkerStyle','.', 'BoxFaceColor', "k" , 'MarkerColor', "#6E7F80");
ax1=gca;
xticklabels(ax1,{"\mu(N_i)", "\sigma^2(N_i)"});
fontsize(ax1, scale=2.4);
xlabel(["Population (N) values"," time range: t_0 - 2t*"])
title(["B) Box plot of iteration means \mu(N_i)","and variances \sigma^2(N_i)"], "Long-term behaviour excluded", FontSize= 24)
box on;
hold off;
% The number of outliers for the iteration means is 0 out of 184 data
% points: 0% (without tail)
% The number of outliers for the iteration variances is 0 out of 184 data
% points: 0% (without tail)

%%
% Compare residuals between iteration means and continuous (CM) model
% Compare residuals between iteration means and discrete (DM) model
% Assess heteroskedasticity of residuals (unequal variance) between head (short-term behavior: [t0-2xt*])
% and tail (from 2xt* onwards)

% Check which model between CM and DM fits better in the 95% CIs of the
% corresponding iteration means, cosidering subsequent time frames.
% In order for our simulation to be correct, DM should fit better by design

% Discrete model (x:N -> y:R)
discrete_model_real = zeros(1,ITERATIONS);
discrete_model_real(1) = START_POPULATION;
for i = 2:ITERATIONS
    discrete_model_real(i) = discrete_model_real(i-1) + (discrete_model_real(i-1)*GROWTH_RATE)*(1 - discrete_model_real(i-1)/CARRYING_CAPACITY);
end

compareMeansModels(TIME, INFLECTION_TIME, iterationMean, ci95_iterationMean, ci95_iterationMean_up ,ci95_iterationMean_down, continuous_population,discrete_model_real)

%%
% What are the constitutive differences between these 2 models? Since they
% produce a greater (continuous model) and a smaller (discrete model)
% v-shape when compared with the experimental growth?
compareLogFittedGrowths(TIME, continuous_population, discrete_model_real, GROWTH_RATE, CARRYING_CAPACITY, START_POPULATION, INFLECTION_TIME)

%%

% How does the constitutive difference between continuous and discrete model impact stochastic simulations?
% Is our simulation the only one that behaves like this?
% Let us implement the state of the art Gillespie algorithm for logistic
% growth simulation

NSIMULATIONS_GILLEPSIE = 1000;
% The number of iterations was manually tuned to match our stochastic
% simulation long-term behaviour
ITERATIONS_GILLEPSIE = 200000;

[Gillespie_Model_Times, Gillespie_Model_Values] = gillespie(START_POPULATION, GROWTH_RATE, CARRYING_CAPACITY, CROWDING_COEFFICIENT, ITERATIONS_GILLEPSIE, NSIMULATIONS_GILLEPSIE);
Gillespie_Model = [Gillespie_Model_Times; Gillespie_Model_Values];

% we can compare gillespie simulation output only with the continuous
% model, knowing that gillespie time starts at 1 and CM at 0
gillespie_continuous_population =  continuous_model([CARRYING_CAPACITY GROWTH_RATE],Gillespie_Model_Times-1);

%%
% we now check if residuals are normally distributed in both our simulation
% and gillespie (compared with the continuous model)
% and check if heteroskedasticity is also present in the gillepsie
% simulation and to what extent
% is there a best simulation approach?
compareResiduals(ITERATIONS,ITERATIONS_TO_SHOW,iterationMean,continuous_population)
compareGillespieResiduals(ITERATIONS,ITERATIONS_TO_SHOW,Gillespie_Model_Times, Gillespie_Model_Values, gillespie_continuous_population)

% Gillespie residuals have a smaller minimum
% and their distribution is closer to normal

% time is important
% mutual exclusiveness is important

%%
% Extra linear model fitting (optional)
%[residualsStd,fitIntercept, fitSlope, fitInterceptCI, fitSlopeCI, fitInterceptSE, fitSlopeSE, fitInterceptTstat, fitSlopeTstat, fitSlopePvalue] = fitLinearModel(iterationMean, TIME, GROWTH_RATE, CARRYING_CAPACITY, ITERATIONS_TO_SHOW);
%%
% Extra non-linear model fitting (legacy) -  we already have a fit to the
% theoretical model, it is our iteraion means, this is our experimental fit
% to compare with the continuous model
%[est_K, est_r, residualsStd, est_K_SE, est_r_SE, est_K_Tstat, est_r_Tstat, est_K_pValue , est_r_pValue,est_K_CI, est_r_CI  ] = fitNonLinearModel(iterationMean, TIME, GROWTH_RATE, CARRYING_CAPACITY, START_POPULATION, continuous_population, ITERATIONS_TO_SHOW);
%%