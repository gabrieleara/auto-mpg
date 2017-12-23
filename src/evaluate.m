function evaluate(verbose, safe_mode)
%EVALUATE	Trains neural networks and evaluates their performances.
%
%   EVALUATE() trains neural networks and evaluates their performances,
%       without operating in safe mode. It will print multiple messages on
%       the console, as in verbose mode on.
%
%   EVALUATE(verbose) allows the user to choose whether operate in verbose
%       mode or not.
%
%   EVALUATE(verbose, safe_mode) allows the user to specify whether execute
%       evaluation of RBF networks in safe mode.
%       See evaluate_rbf for futher details.
%
%   See also EVALUATE_MLP, EVALUATE_RBF, DISPLAY_RESULTS.

fprintf('You have launched network trainer and evaluator.\n');

if nargin < 1
    verbose   = true;
    safe_mode = false;
elseif nargin < 2
    safe_mode = false;
else
    safe_mode = logical(safe_mode);
end


%% Loading Data

% Input data, elaborated from 'auto-mpg.data', have been moved to
% 'auto-mpg.mat', for easier access.

if verbose
    fprintf('\nLoading data...\n');
end

% NOTICE: this assumes that this command is launched from the src folder.
load('../data/auto-mpg.mat');

%% MLP Network Evaluation

if verbose
    fprintf('\nTraining and evaluating MLB Networks...\nThis will take some time.\n');
    fprintf('A window will open to let you track progress, but notice that it \nwill slow down over time, due to the longer time needed to train\nbigger networks.\n\n');
    fprintf('If you want to abort, close the window...\n');
end

% Range of network sizes for MLP networks to be trained and number of
% trainings for each size.
neurons_range = 10:5:200;
number_trainings = 10;

[mlp_bestN, mlp_mean_performances, mlp_mean_regressions, ...
    mlp_performances, mlp_regressions] = ...
        evaluate_mlp(inputs, outputs, neurons_range, number_trainings);

if verbose
    fprintf('\nMLB Networks evaluation completed.\n');
end

%% RBF Network Evaluation

if verbose
    fprintf('\nTraining and evaluating RBF Networks...\nThis will take some time.\n');
    fprintf('A window will open to let you track progress, but notice that it \nwill slow down over time, due to the longer time needed to train\nbigger networks.\n\n');
    fprintf('If you want to abort, close the window...\n');

    if safe_mode
        fprintf('\nNOTICE: operating in safe mode. The newrb Matlab function will open multiple figures\none after the other.\nThere is no way to prevent this if you want to operate in safe mode.\n\n')
    end
end

number_spreads = 20;

% To define spread_range, we need to know distances between input points.
distances   = pdist(inputs);
max_dist    = ceil(max(distances));
min_dist    = floor(min(distances));

if min_dist < 1
    min_dist = 1;
end

spread_range = floor(min_dist:(max_dist-min_dist)/(number_spreads-1):max_dist);

[rbf_bestN, rbf_bestS, rbf_mean_performances, rbf_mean_regressions, ...
    rbf_performances, rbf_regressions] = ...
        evaluate_rbf(inputs, outputs, neurons_range, spread_range, number_trainings, safe_mode);

if verbose
    fprintf('\nRBF Networks evaluation completed.\n');
end

%% Saving results on 'auto-eval.mat' file.

if verbose
    fprintf('\nSaving results...\n');
end

delete('../data/auto-eval.mat');
save('../data/auto-eval.mat', ...
    'neurons_range', 'number_trainings', 'spread_range', ...
    'mlp_bestN', ...
    'mlp_mean_performances', 'mlp_mean_regressions', ...
    'mlp_performances', 'mlp_regressions', ...
    'rbf_bestN', 'rbf_bestS', ...
    'rbf_mean_performances', 'rbf_mean_regressions', ...
    'rbf_performances', 'rbf_regressions');

if verbose
    fprintf('\nNetwork trainer and evaluator completed execution.\n');
end

end