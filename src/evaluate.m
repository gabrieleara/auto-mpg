function evaluate()
% EVALUATE  Trains neural networks and evaluates their performances.
%
% See also EVALUATE_MLP, EVALUATE_RBF.

fprintf('You have launched network trainer and evaluator.\n');


%% Loading Data

% Input data, elaborated from 'auto-mpg.data', have been moved to
% 'auto-mpg.mat', for easier access.

fprintf('\nLoading data...\n');

% NOTICE: this assumes that this command is launched from the src folder.
load('../data/auto-mpg.mat');

%% MLP Network Evaluation

fprintf('\nTraining and evaluating MLB Networks...\nThis will take some time.\n');
fprintf('A window will open to let you track progress, but notice that it \nwill slow down over time, due to the longer time needed to train\nbigger networks.\n\n');
fprintf('If you want to abort, close the window...\n');

% Range of network sizes for MLP networks to be trained and number of
% trainings for each size.
mlp_neurons_range = 10:10:200;
mlp_number_trainings = 10;

[mlp_N, mlp_perf_values, mlp_regr_values] = ...
    evaluate_mlp(inputs, outputs, mlp_neurons_range, mlp_number_trainings);

fprintf('\nMLB Networks evaluation completed.\n');


% %% RBF Network Evaluation
% 
% % Number of trainings and spread for each RBF network size.
% rbf_number_trainings = 1;
% rbf_number_spreads = 5;
% 
% % Range of network sizes for RBF networks to be trained.
% rbf_non_exact_neurons_range = 10:10:200;
% rbf_exact_clus_neurons_range = 10:10:200;
% 
% 
% 
% 
% [rbf_non_exact_N, rbf_non_exact_perf_values, ...
%     rbf_non_exact_regr_values, rbf_non_exact_S] = ...
%     rbf_performance_evaluation(inputs, outputs, ...
%     rbf_non_exact_neurons_range, rbf_number_trainings, ...
%     'non-exact', rbf_number_spreads);
% 
% 
% 
% [rbf_exact_clus_N, rbf_exact_clus_perf_values, ...
%     rbf_exact_clus_regr_values, rbf_exact_clus_S] = ...
%     rbf_performance_evaluation(inputs, outputs, ...
%     rbf_exact_clus_neurons_range, rbf_number_trainings, ...
%     'exact-clustering', rbf_number_spreads);


%% Saving results on 'auto-eval.mat' file.

fprintf('\nSaving results...\n');

save('../data/auto-eval.mat');

end