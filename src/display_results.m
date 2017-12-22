function display_results(equal_axis)
%DISPLAY_RESULTS	Reads values from savefile and displays plots of performances.
%
%   See also EVALUATE.

if nargin < 1
    equal_axis = false;
end

load('../data/auto-eval.mat', ...
    'neurons_range', 'number_trainings', 'spread_range', ...
    'mlp_bestN', ...
    'mlp_mean_performances', 'mlp_mean_regressions', ...
    'mlp_performances', 'mlp_regressions', ...
    'rbf_bestN', 'rbf_bestS', ...
    'rbf_mean_performances', 'rbf_mean_regressions', ...
    'rbf_performances', 'rbf_regressions');

plot_stats(neurons_range, mlp_mean_performances, mlp_mean_regressions, 1, 'MLP Network Evaluation', equal_axis);
plot_stats(neurons_range, rbf_mean_performances, rbf_mean_regressions, 2, 'RBF Network Evaluation', equal_axis);

end

function plot_stats(neurons_range, perf_values, regr_values, position, sub_title, equal_axis)

persistent max_yaxis;

if(position == 1)
    figure
    max_yaxis = 0;
    %subtitle('Neural Networks Evaluation for MPG prediction');
end

subplot(1,2, position, 'replace');

hold on

yyaxis left
plot(neurons_range, perf_values);
[~, best] = min(perf_values);
L0 = plot(neurons_range(best), perf_values(best), '-o', 'MarkerSize', 12);

max_perf = ceil(max(perf_values)/10)*10;

if isempty(max_yaxis) || ~equal_axis || max_perf > max_yaxis
    max_yaxis = max_perf;
end

ylim([0,max_yaxis]);

yyaxis right
plot(neurons_range, regr_values)
[~, best] = max(regr_values);
L1 = plot(neurons_range(best), regr_values(best), '-o', 'MarkerSize', 12);

ylim([0,1]);

legend([L0, L1], 'MSE', 'Regression');

title(sub_title);

hold off

if equal_axis
    % Selects the other plot
    subplot(1,2, 3-position);
    
    yyaxis left
    ylim([0, max_yaxis]);
end

end