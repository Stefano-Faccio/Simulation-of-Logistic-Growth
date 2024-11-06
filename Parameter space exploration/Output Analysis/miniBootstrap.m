% Bootstrap method to gather summary statistics

function [metrics] = miniBootstrap(data, gamma)
    dim = length(data);
    
    r0 = 25; % sufficiently many points outside the interval
    R = ceil(2 * r0 / (1 - gamma)) - 1; % bootstrap replicates
    
    subSample = zeros(dim, 1);
    Mean_ = zeros(R, 1);
    Std_ = zeros(R, 1);
    Cov_ = zeros(R,1);
    
    for i = 1 : R
        for y = 1 : dim
            subSample(y) = data(ceil(rand.* dim));
            % draw (all) elements with replacement from the dataset
        end
        %compute your desired statistics T_r as a function of these replicates
        Mean_(i) = mean(subSample);
        Std_(i) = std(subSample);
        CoV_(i) = Std_(i) / Mean_(i);
    end
    %order the computed statistics to obtain T(1)', T(2)', T(3)',...
    Mean_ = sort(Mean_);
    Std_ = sort(Std_);
    CoV_ = sort(CoV_);
    %Bootstrap percentile estimate [T(r0); T(R+1-r0)]
    metrics = [Mean_(r0) Mean_(R+1-r0); Std_(r0) Std_(R+1-r0); CoV_(r0) CoV_(R+1-r0)];
end
