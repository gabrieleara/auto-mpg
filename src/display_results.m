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

if exist('../fig') ~= 7 % It is not a folder, so it doesn't exist
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

fig1 = plot_stats(neurons_range, rbf_mean_performances, rbf_mean_regressions, 'xtext', 'MSE', 'Regression');

savefig(fig1, '../fig/rbf_net_eval.fig');

fprintf('Press any key to continue...');
pause;

if ishandle(fig1)
    close(fig1);
end

fprintf('\n\n');



%% Additional plots


fprintf('\nSpreads Graphical Evaluation for RBF Networks\n');

fprintf('\n\nShowing average plots for network sizes and spread.\n');

[X,Y] = meshgrid(spread_range, neurons_range);
tri = delaunay(X,Y);
map = [0.242200002074242 0.150399997830391 0.660300016403198;0.249311909079552 0.166469037532806 0.704317867755890;0.256423801183701 0.182538092136383 0.748335719108582;0.263535708189011 0.198607146739960 0.792353570461273;0.270647615194321 0.214676186442375 0.836371421813965;0.275114297866821 0.234238088130951 0.870985686779022;0.278299987316132 0.255871415138245 0.899071455001831;0.275720387697220 0.278222441673279 0.912797987461090;0.273140817880631 0.300573468208313 0.926524519920349;0.270561218261719 0.322924494743347 0.940251052379608;0.267981618642807 0.345275491476059 0.953977525234222;0.265402019023895 0.367626518011093 0.967704057693481;0.262822449207306 0.389977544546127 0.981430590152741;0.260242849588394 0.412328571081162 0.995157122612000;0.244033336639404 0.435833334922791 0.998833358287811;0.220642849802971 0.460257142782211 0.997285723686218;0.196333333849907 0.484719038009644 0.989152371883392;0.183404758572578 0.507371425628662 0.979795217514038;0.179921418428421 0.528638124465942 0.965907096862793;0.176438093185425 0.549904763698578 0.952019035816193;0.168742850422859 0.570261895656586 0.935871422290802;0.153999999165535 0.590200006961823 0.921800017356873;0.146011903882027 0.608914256095886 0.909545242786408;0.138023808598518 0.627628564834595 0.897290468215942;0.123752377927303 0.645028591156006 0.884787321090698;0.109480954706669 0.662428557872772 0.872284114360809;0.0952095240354538 0.679828584194183 0.859780967235565;0.0688714310526848 0.694771409034729 0.839357137680054;0.0296666659414768 0.708166658878326 0.816333353519440;0.00357142859138548 0.720266640186310 0.791700005531311;0.00665714265778661 0.731214284896851 0.766014277935028;0.0433285720646381 0.741095244884491 0.739409506320953;0.0963952392339706 0.750000000000000 0.712038099765778;0.140771433711052 0.758400022983551 0.684157133102417;0.171700000762939 0.766961932182312 0.655442833900452;0.193892866373062 0.775630950927734 0.623871445655823;0.216085717082024 0.784300029277802 0.592299997806549;0.246957138180733 0.791795253753662 0.556742846965790;0.290614277124405 0.797290503978729 0.518828570842743;0.356100767850876 0.812243402004242 0.556194782257080;0.421587228775024 0.827196300029755 0.593561053276062;0.487073719501495 0.842149198055267 0.630927264690399;0.552560210227966 0.857102096080780 0.668293476104736;0.618046641349793 0.872054994106293 0.705659687519074;0.683533132076263 0.887007892131805 0.743025958538055;0.749019622802734 0.901960790157318 0.780392169952393;0.781372547149658 0.901960790157318 0.807843148708344;0.813725471496582 0.901960790157318 0.835294127464294;0.846078455448151 0.901960790157318 0.862745106220245;0.878431379795075 0.901960790157318 0.890196084976196;0.886274516582489 0.901960790157318 0.894117653369904;0.894117653369904 0.901960790157318 0.898039221763611;0.901960790157318 0.901960790157318 0.901960790157318;0.908496737480164 0.908496737480164 0.908496737480164;0.915032684803009 0.915032684803009 0.915032684803009;0.921568632125855 0.921568632125855 0.921568632125855;0.928104579448700 0.928104579448700 0.928104579448700;0.934640526771545 0.934640526771545 0.934640526771545;0.941176474094391 0.941176474094391 0.941176474094391;0.952941179275513 0.952941179275513 0.952941179275513;0.964705884456635 0.964705884456635 0.964705884456635;0.976470589637756 0.976470589637756 0.976470589637756;0.988235294818878 0.988235294818878 0.988235294818878;1 1 1];


fprintf('\n - Showing performance plot.\n');

fig1 = figure;
surface = trisurf(tri, X, Y, rbf_performances);
colormap(flipud(map));
shading('interp');
surface.EdgeColor = 'k';

savefig(fig1, '../fig/rbf_spread_perf.fig');

fprintf('Press any key to continue...');
pause;

if ishandle(fig1)
    close(fig1);
end

fprintf('\n\n');

fprintf('\n - Showing regression plot.\n');
 
fig1 = figure;
surface = trisurf(tri, X, Y, rbf_regressions);
colormap(map);
shading('interp');
surface.EdgeColor = 'k';

savefig(fig1, '../fig/rbf_spread_regr.fig');

fprintf('Press any key to continue...');
pause;

if ishandle(fig1)
    close(fig1);
end

fprintf('\n\n');




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