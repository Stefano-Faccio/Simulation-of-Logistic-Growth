%%
% We know that CARRYING_CAPACITY = (REPRODUCTION_PROBABILITY-DEATH_PROBABILITY)/CROWDING_COEFFICIENT
% or CARRYING_CAPACITY=GROWTH_RATE/CROWDING_COEFFICIENT
% for reproducibility
rng(3,"twister");
%colors_1 = ["#C0C0C0" "#E6194B" "#008080" "#3CB44B" "#FFE119" "#4363D8" "#F58231" "#911EB4" "#46F0F0" "#F032E6"];
data_file_1 = 'data.txt';

% TABLE FORMAT : simulation (given setting) x iterations' mean (over all the simulations per setting)

% the CROWDING_COEFFICIENT range is between 0.00001 and 0.0001 (step = 0.00001)
% the START_POPULATION range is between 1 and 50 (excluded) (step = 2)
% the REPRODUCTION_PROBABILITY range is between 0.05 and 1 (step = 0.05)
% the DEATH_PROBABILITY range is between 0 and 0.95 (step = 0.05)

[T, C] = getTuningOutput(data_file_1);

NSIMULATIONS = str2double(C{1,2});
ITERATIONS = str2double(C{2,2});
GROWTH_RATE = str2double(C{3,2});
  
START_START_POPULATION = str2double(C{1,4});
STEP_POPULATION = str2double(C{2,4});
END_START_POPULATION = str2double(C{3,4});

START_CROWDING_COEFFICIENT = str2double(C{1,6});
STEP_CROWDING_COEFFICIENT = str2double(C{2,6});
END_CROWDING_COEFFICIENT = str2double(C{3,6});

START_REPRODUCTION_PROBABILITY = str2double(C{1,8});
STEP_REPRODUCTION_PROBABILITY = str2double(C{2,8});
END_REPRODUCTION_PROBABILITY = str2double(C{3,8});

START_DEATH_PROBABILITY = START_REPRODUCTION_PROBABILITY-0.05;
END_DEATH_PROBABILITY = END_REPRODUCTION_PROBABILITY-0.05;
STEP_DEATH_PROBABILITY = STEP_REPRODUCTION_PROBABILITY;

% CARRYING_CAPACITY = GROWTH_RATE/CROWDING_COEFFICIENT;
% ITERATIONS_TO_SHOW = 2*ceil(log((CARRYING_CAPACITY - START_POPULATION)/START_POPULATION)/GROWTH_RATE);

%%
% Steady-state (tail) analysis
% For each parameter setting, the means (over all simulations) of the last 200 iterations
% are extracted to get a qualitative approximation of the observed CARRYING_CAPACITY (L)

columnsToDelete = 5:1:303;
tailT = T;
tailT(:, columnsToDelete) = [];

%%

% Bootstrap method to compute the mean (observed L)
% (standard deviation and coefficient of variation) confidence
% intervals (95%)
% of the last 200 iterations' means --> computing a grand mean

Mean = [];
Std = [];
CoV = [];
Metrics = [];
for i=1:height(tailT)
    meanSim = mean(table2array(tailT(i,5:end)));
    Mean = [Mean meanSim];
    stdSim = std(table2array(tailT(i,5:end)));
    Std = [Std stdSim];
    CoVSim = stdSim / meanSim;
    CoV = [CoV CoVSim];
    metricsSim = miniBootstrap(sort(table2array(tailT(i,5:end))), 0.95);
    Metrics = [Metrics metricsSim];
end

MeanLowerCI= [];
MeanUpperCI= [];
StdLowerCI = [];
StdUpperCI = [];
CoVLowerCI = [];
CoVUpperCI = [];

for i=1:2:width(Metrics)
    MeanLowerCI= [MeanLowerCI Metrics(1,i)];
    StdLowerCI = [StdLowerCI Metrics(2,i)];
    CoVLowerCI  = [CoVLowerCI Metrics(3,i)];
end

for i=2:2:width(Metrics)
    MeanUpperCI = [MeanUpperCI Metrics(1,i)];  
    StdUpperCI = [StdUpperCI Metrics(2,i)];
    CoVUpperCI = [CoVUpperCI Metrics(3,i)];
end


% Steady-state (tail) analysis
% For each parameter setting, we keep the observed L (and other summary statistics)
% to compare it against the theoretical L
tailMeanT = tailT(:,1:4);

MeanCol = Mean';
tailMeanT.("Mean") = MeanCol;   
MeanLowerCICol = (MeanLowerCI)';
MeanUpperCICol = (MeanUpperCI)';
tailMeanT.("MeanLowerCI") = MeanLowerCICol ;  
tailMeanT.("MeanUpperCI") = MeanUpperCICol;  

StdCol = Std';
tailMeanT.("Std") = StdCol;   
StdLowerCICol = (StdLowerCI)';
StdUpperCICol = (StdUpperCI)';
tailMeanT.("StdLowerCI") = StdLowerCICol;
tailMeanT.("StdUpperCI") = StdUpperCICol;

CoVCol = CoV';
tailMeanT.("CoV") = CoVCol;   
CoVLowerCICol = (CoVLowerCI)';
CoVUpperCICol = (CoVUpperCI)';
tailMeanT.("CoVLowerCI") = CoVLowerCICol;
tailMeanT.("CoVUpperCI") = CoVUpperCICol;

%%
% Produce paper Supplementary table 1 (corresponding to footnote 6: 
% 95% confidence intervals (computed with the Bootstrap method) of 5200 observed L (iteration grand mean) values,
% for each setting, are given in Supplementary Table $1.)
% Note that the iteration grand mean is computed on the last 200
% iteration means.

suppTable1 = tailMeanT(:,1:7);
suppTable1.Properties.VariableNames = ["START_POPULATION","CROWDING_COEFFICIENT", "REPRODUCTION_PROBABILITY" ...
    "DEATH_PROBABILITY", "ITERATION_GRAND_MEAN", "LOWER_95_CI", "UPPER_95_CI"];
writetable(suppTable1,'SupplementaryTable1.csv','WriteRowNames',true);  

%%
% L is CARRYING_CAPACITY
% For each parameter setting, compute the theoretical L.
L = [];
for i=1:height(tailMeanT)
    C = table2array(tailMeanT(i, "ItCROWDING_COEFFICIENT"));
    R_D = table2array(tailMeanT(i, "ItREPRODUCTION_PROBABILITY")) -  table2array(tailMeanT(i, "ItDEATH_PROBABILITY"));
    l = R_D/C;
    L = [L l];
end

LCol = L';
tailMeanT.("TheorL") = LCol;   

% Compute the difference between the theoretical L
% and the observed L
DeltaL = tailMeanT.TheorL - tailMeanT.Mean;

% absolute value of the difference
tailMeanT.("DeltaL") = abs(DeltaL);

% raw difference
tailMeanT.("RawDeltaL") = DeltaL;


% absolute value of the difference scaled by the theoretical
% carrying capacity corresponding to each parameter setting 
% (so we get a weighted difference comparable to the others)
% since carrying capacity ranges from 500 to 5000
ScaledDeltaL = (tailMeanT.DeltaL) ./ tailMeanT.TheorL;
tailMeanT.("ScaledDeltaL") = ScaledDeltaL;

% absolute value of the difference scaled by the theoretical
% carrying capacity corresponding to each parameter setting 
% (so we get a weighted difference comparable to the others)
% since carrying capacity ranges from 500 to 5000
% we then get the percentage for visualization purposes
ScaledDeltaLPerCent = (tailMeanT.DeltaL .*100) ./ tailMeanT.TheorL;
tailMeanT.("ScaledDeltaLPerCent") = ScaledDeltaLPerCent;

% raw difference scaled by the theoretical carrying capacity (in percentage)
RawScaledDeltaLPerCent = (tailMeanT.RawDeltaL .*100) ./ tailMeanT.TheorL;
tailMeanT.("RawScaledDeltaLPerCent") = RawScaledDeltaLPerCent;

%%
figure
% We plot the scaled absolute value of the difference between observed L
% and the theoretical L to restrict the parameter space
% to solutions that meet the following functional requirement of the
% system: CARRYING CAPACITY needs to be as closer as possible to the
% theoretical one, so minimize \ScaledDelta L.

scatter3(tailMeanT.ItSTART_POPULATION,tailMeanT.ItCROWDING_COEFFICIENT, tailMeanT.ItREPRODUCTION_PROBABILITY,30,tailMeanT.ScaledDeltaL, "filled" );
ax = gca;
xlabel('N_0')
ylabel('c')
zlabel('R (D + 0.05)')
cb = colorbar;                              
cb.Label.String = '\DeltaL (log scale)';
set(gca, 'ColorScale', 'log');
title_ = ["Scaled absolute difference between theoretical carrying capacity", "and observed carrying capacity (\DeltaL)"];
%title(title_)
subtitle_ = ["Discrete growth rate (r): " + GROWTH_RATE + ";", ...
    "Initial population (N_0) range: "+ START_START_POPULATION + "-" + END_START_POPULATION + "; step: " + STEP_POPULATION+ "];", ...
    "Reproduction probability (R) range: "+ START_REPRODUCTION_PROBABILITY + "-" + END_REPRODUCTION_PROBABILITY + "; step: " + STEP_REPRODUCTION_PROBABILITY+ "];", ...
    "Crowding coefficient (c) range: "+ START_CROWDING_COEFFICIENT + "-" + END_CROWDING_COEFFICIENT + "; step: " + STEP_CROWDING_COEFFICIENT+ "];", ...
    "Death probability (D) range: "+ START_DEATH_PROBABILITY + "-" + END_DEATH_PROBABILITY + "; step: " + STEP_DEATH_PROBABILITY+ "];", ...
    "Simulations: " + NSIMULATIONS + "; Iterations: last " + 200 + " (out of " + ITERATIONS+ ");"];
%subtitle(subtitle_);
box on;

%%
% We choose/assess the parameter setting(s) that minimize \ScaledDelta L,
% looking at the percentages of differences (\ScaledDeltaLs) that the settings imply when combined,
% by comparing parameters in a pair-wise manner, to evaluate how they
% contribute to the minimization of ScaledDelta L (in percentage)
% Goal: keep the parameters that have 0%
getParamPlots(tailMeanT, "ScaledDeltaLPerCent",15, "\DeltaL (%)", START_CROWDING_COEFFICIENT, STEP_CROWDING_COEFFICIENT, END_CROWDING_COEFFICIENT, START_REPRODUCTION_PROBABILITY, STEP_REPRODUCTION_PROBABILITY, END_REPRODUCTION_PROBABILITY)

%%
