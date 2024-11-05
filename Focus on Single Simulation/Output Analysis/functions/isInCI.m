% This function takes as input the following arguments:
% 1) CImat, the 95% CIs of the iteration means (experimental)
% 2) PopModel, theoretical continuous or discrete population values corresponding to
% our stochastic simulation parameter settings
% 3) INFLECTION_TIME, to create subsequent time frames of observation

% This function checks how many points of the chosen population model (theoretical)
% fall into the corresponding CIs,
% from a global point of view, regardless of the position of the points (percentage-like)
% and from a range point of view, using the inflection time as the batch
% dimension

% This function outputs the following variables:
% 1) res, global comparison results
% 2) all_trues, number of true values (for stacked bar plot D)
% 3) all_falses, number of false values (for stacked bar plot D)
% 4) stat_ranges, number of true/false values for each subsequent time
% frame, given the population model (for stacked bar plot E and F respectively for CM and DM)

function [res, all_trues, all_falses, stat_ranges] = isInCI(CImat, PopModel, INFLECTION_TIME)

    res = zeros(1,length(CImat));
    for i=1:length(CImat)
        if PopModel(i) >= CImat(1,i) && PopModel(i) <= CImat(2,i)
            res(i) = true;
        else
            res(i) = false;
        end
    
    end
    all_trues = sum(res,'all'); % global point of view
    all_falses = length(CImat) - all_trues;

    % This part can be generalized better 
    % We assume there is always going to be a rest
    % splitting iterations in subsequent time frames, based on the
    % inflection time
    % 't_{0} - t*','t* - 2t*','2t* - 3t*', '3t* - 4t*', '4t* - t_{end}'
    splits = floor(length(CImat) / INFLECTION_TIME);
    rest = mod(length(CImat),INFLECTION_TIME);
    ranges = reshape(res(1:end-rest),splits,[]);
    last_range = [ranges(splits,:) res(end-rest+1:end)];
    ranges(end,:)=[];
    
    % Computing true/falses inside each subsequent same-length time frame/range, except for the
    % last one, which has variable length
    stat_ranges = [];
    for i=1:height(ranges)
        trues = sum(ranges(i,:),'all');
        falses = length(ranges) - trues;
        stat_ranges = [stat_ranges [trues;falses]];
    end
    
    % Computing true/falses inside the last time range
    trues = sum(last_range,'all');
    falses = length(last_range) - trues;
    stat_ranges = [stat_ranges [trues;falses]]; 
end