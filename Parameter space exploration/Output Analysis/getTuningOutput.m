% getTuningOutput()

% This function takes as input the output file from the branch
% LogisticSimulation-ParameterTuning, which contains all the iterations'
% means (computed over all the simulations) for each population 
% corresponding to each parameter setting.

% This function outputs:

function [T,C] = getTuningOutput(data_file)
    fid = fopen(data_file,'r');
    numLines = 9;
    C = cell(3,numLines-1);
    for i=1:numLines
        if  i < 9 
            tline = fgetl(fid);
            newStr = split(tline);
            C{1,i} = newStr{1};
            C{2,i} = newStr{2};
            C{3,i} = newStr{3};
        elseif i == 9 
            tline = fgetl(fid);
            tline = split(tline);
            tline = strcat('It', tline);
        end
    end
    fclose(fid);

    % Collect tuning parameters
    NSIMULATIONS = str2double(C{1,2});
    ITERATIONS = str2double(C{2,2});
    GROWTH_RATE= str2double(C{3,2});
    
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
    
    % Collect iterations' means for each parameter setting
    T = readtable(data_file,NumHeaderLines=9);
    T.Properties.VariableNames = tline;
    end