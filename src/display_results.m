clear;

load('auto-eval.mat');

plot_stats(mlp_neurons_range, mlp_perf_values, ...
    mlp_regr_values, 1, 'MLP Network Evaluation');
plot_stats(rbf_non_exact_neurons_range, rbf_non_exact_perf_values, ...
    rbf_non_exact_regr_values, 2, 'RBF Network Evaluation: Non Exact');
plot_stats(rbf_exact_clus_neurons_range, rbf_exact_clus_perf_values, ...
    rbf_exact_clus_regr_values, 3, 'RBF Network Evaluation: Exact with Custering');

function plot_stats(neurons_range, perf_values, regr_values, position, sub_title)
    if(position == 1)
        figure
        %subtitle('Neural Networks Evaluation for MPG prediction');
    end
    
    subplot(2,2,position, 'replace');
    
    hold on
    
    yyaxis left
    plot(neurons_range, perf_values);
    [~, best] = min(perf_values);
    L0 = plot(neurons_range(best), perf_values(best), '-o', 'MarkerSize', 12);

    yyaxis right
    plot(neurons_range, regr_values)
    [~, best] = max(regr_values);
    L1 = plot(neurons_range(best), regr_values(best), '-o', 'MarkerSize', 12);

    legend([L0, L1], 'MSE', 'Regression');
    
    title(sub_title);
    
    hold off
end