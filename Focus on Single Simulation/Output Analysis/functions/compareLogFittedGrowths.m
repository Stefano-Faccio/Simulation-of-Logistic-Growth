% This function takes as input the following arguments:
% 1) TIME (0:1:ITERATIONS-1)
% 2) population per time unit corresponding to the continuous model
% 3) population per time unit corresponding to the discrete model
% 4) GROWTH_RATE (REPRODUCTION_PROBABILITY - DEATH_PROBABILITY)
% 5) CARRYING_CAPACITY
% 6) START_POPULATION
% 7) INFLECTION_TIME (CARRYING_CAPACITY/2)

% This function compares theoretical continuous and discrete growth models
% in order to check the constitutive difference between them,
% knowing that our stochastic simulation is of discrete logistic growth,
% using the parameter settings of our single simulation

% This function outputs the following plots in tiled layout:
% A) Big picture of the comparison between continuous (CM) and discrete (DM) logistic growth models
% B) Difference in population (\DeltaN) between DM and CM per time unit


function compareLogFittedGrowths(TIME, continuous_population, discrete_model_real, GROWTH_RATE, CARRYING_CAPACITY, START_POPULATION, INFLECTION_TIME)

tl= tiledlayout(2,1);
title(tl,"Theoretical logistic growth models", fontsize=26);
subtitle_ = ["Discrete = continuous growth rate (r = k): " + GROWTH_RATE + "; Carrying capacity (L): "+ CARRYING_CAPACITY + ";", ...
    "Initial population (N_0): " + START_POPULATION + "; Time range: [" + 0 + " - " + TIME(end) + "]; Inflection time (t*): " + INFLECTION_TIME + ";"];
subtitle(tl,subtitle_, fontsize=24);

nexttile
hold on;
c_1 = plot(TIME,continuous_population,Color = "#29AB87", LineWidth=1.75);
d_1 = plot(TIME,discrete_model_real, ".", Color="#FF8243", LineWidth=1.5);
leg = legend([c_1,d_1], "Continuous", "Discrete");
leg.Location="southeast";
title(leg,'Logistic growth models');
ylabel("N (population) - units");
xlabel("t (time) - units");
title("A) Big picture of the comparison between continuous (CM) and discrete (DM) logistic growth models");
ax = gca;
fontsize(ax, scale=2.1);
box on;
hold off;

nexttile
hold on;
% where the discrepancy shows up
plot(TIME,discrete_model_real-continuous_population, ".r", LineWidth=1.5);
yline(0, '-', '\DeltaN=0', Color="#8C92AC",LineWidth=1.25);
ylabel("\DeltaN");
xlabel("t (time) - units");
ax = gca;
fontsize(ax, scale=2.1);
title("B) Difference in population (\DeltaN) between DM and CM per time unit");
legend("Raw residuals", Location="southeast");
box on;
hold off;

figure;
hold on;
plot(TIME,100 * abs(discrete_model_real-continuous_population) ./ continuous_population, ".", LineWidth=1.5, Color="#0040ff");
leg = legend("Absolute Percentage Error");
ylabel("Error (%)");
xlabel("t (time) - units");
ax = gca;
fontsize(ax, scale=2.1);
box on;
hold off;

end