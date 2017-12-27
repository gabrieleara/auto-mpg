function display_results()
%DISPLAY_RESULTS	Reads values from savefile and displays plots of performances.
%
%   See also EVALUATE.

%% Loading Data

fprintf('\nLoading evaluated data...\n');

load('../data/auto-eval.mat', ...
    'neurons_range', 'number_trainings', 'spread_range', ...
    'mlp_bestN', ...
    'mlp_mean_performances', 'mlp_mean_regressions', ...
    'mlp_performances', 'mlp_regressions', ...
    'rbf_bestN', 'rbf_bestS', ...
    'rbf_mean_performances', 'rbf_mean_regressions', ...
    'rbf_performances', 'rbf_regressions');

if exist('../fig') ~= 7 % so not a folder
    mkdir('../fig');
end

%% Displaying and saving MLP results

[~, bestP] = min(mlp_mean_performances);

fprintf('\nResults of MLP Networks Evaluation\n');
fprintf(' Best network size is %d, which had\n', neurons_range(bestP));
fprintf('  - Average performance:\t%f\n',   mlp_mean_performances(bestP));
fprintf('  - Average regression:\t\t%f\n',	mlp_mean_regressions(bestP));


[~, bestR] = max(mlp_mean_regressions);

if bestR ~= bestP
    fprintf('\nNOTICE: conflicting results when evaluating best network size based on\n        regressions instead of performance.\n\n');
    fprintf(' Best network size could also be %d, which had\n', neurons_range(bestR));
    fprintf('  - Average performance:\t%f\n',   mlp_mean_performances(bestR));
    fprintf('  - Average regression:\t\t%f\n',	mlp_mean_regressions(bestR));
end


fprintf('\n\nShowing average plots.\n');

fig1 = plot_stats(neurons_range, mlp_mean_performances, mlp_mean_regressions, 'xtext', 'MSE', 'Regression');

savefig(fig1, '../fig/mlp_net_eval.fig');

fprintf('Press any key to continue...');
pause;
fprintf('\n\n');

if ishandle(fig1)
    close(fig1);
end


%% Displaying and saving RBF results

[~, bestP] = min(rbf_mean_performances);

fprintf('\nResults of RBF Networks Evaluation\n');
fprintf(' Best network size is %d\n', neurons_range(bestP));
fprintf('  - Average performance:\t%f\n',   rbf_mean_performances(bestP));
fprintf('  - Average regression:\t\t%f\n',  rbf_mean_regressions(bestP));

fprintf(' Best spread for that network size is %d.\n', rbf_bestS);

[~, bestR] = max(rbf_mean_regressions);

if bestR ~= bestP
    fprintf('\nNOTICE: conflicting results when evaluating best network size based on\n        regressions instead of performance.\n\n');
    fprintf(' Best network size could also be %d, which had\n', neurons_range(bestR));
    fprintf('  - Average performance:\t%f\n',   rbf_mean_performances(bestR));
    fprintf('  - Average regression:\t\t%f\n',	rbf_mean_regressions(bestR));
    
    [~, bestS] = min(squeeze(rbf_performances(bestR, :)));
    bestS = spread_range(bestS);
    
    fprintf(' Best spread for that network size is %d.\n', bestS);
end





fprintf('\n\nShowing average plots.\n');

fig2 = plot_stats(neurons_range, rbf_mean_performances, rbf_mean_regressions, 'xtext', 'MSE', 'Regression');

savefig(fig2, '../fig/rbf_net_eval.fig');

fprintf('Press any key to continue...');
pause;

if ishandle(fig2)
    close(fig2);
end

fprintf('\n\n');



%% Additional plots
 
[X,Y] = meshgrid(spread_range, neurons_range);

tri = delaunay(X,Y);
s = trisurf(tri, X, Y, rbf_performances);
colormap(flipud(hot));
shading('interp');
s.EdgeColor = 'k';

end

function figh = plot_stats(x, y1, y2, xtext, y1text, y2text)
figh = figure;
[AX, hLine1, hLine2] = plotyy(x, y1, x, y2);

xlabel(xtext);

evalc('hold(AX(1))');
evalc('hold(AX(2))');

[yy1, best] = min(y1);
xx1 = x(best);

[yy2, best] = max(y2);
xx2 = x(best);

hLine3 = plot(AX(1),xx1,yy1,'.-');
hLine4 = plot(AX(2),xx2,yy2,'.-');

[   hLine1.LineWidth, ...
    hLine2.LineWidth, ...
    hline3.LineWidth, ...
    hline4.LineWidth    ] = deal(1);

[   hLine3.MarkerSize, ...
    hLine4.MarkerSize   ] = deal(20);

hLine3.Color = hLine1.Color;
hLine4.Color = hLine2.Color;

legend([hLine3, hLine4], y1text, y2text);


% Setting limits for left axis
maxv = (ceil(max(y1)/20)+1)*20;
AX(1).YLim      = [0 maxv];

if mod(maxv,5) < 1
    numTick = 5;
elseif mod(maxv, 4) < 1
    numTick = 4;
else
    numTick = 3;
end

AX(1).YTick = floor(0:maxv/(numTick-1):maxv);

AX(2).YLim  = [0 1];
AX(2).YTick = 0:1/(numTick-1):maxv;

[AX(1).LineWidth, AX(2).LineWidth] = deal(1.1);

AX(1).XLim  = [0 x(end)];
AX(1).XTick = 0:x(end)/4:x(end);

hold(AX(1), 'off');
hold(AX(2), 'off');

end