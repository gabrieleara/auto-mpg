function [bestN, performances, regressions] = evaluate_mlp(inputs, outputs, neurons_range, num_training)
% EVALUATE_MLP  Evaluates the best MLP network size N for the given problem.
%   bestN = EVALUATE_MLP(inputs, outputs, neurons_range, num_training)
%       returns the best network size inside neurons_range for the given
%       problem. To do so, it trains num_traning different networks for
%       each network size.
%
%   [bestN, performances] = EVALUATE_MLP(___)
%       returns both the best network size and an array of performance
%       evalutations, one for each network size. Values in performances are
%       obtained by averaging performance evaluations of each trained
%       networks of the same size.
%
%   [bestN, performances, regressions] = EVALUATE_MLP(___)
%       returns the best network size, an array of performance
%       evalutations and mean regression values, one for each network size.
%       Values in regressions are obtained by averaging performance
%       evaluations of each trained networks of the same size.
%
%   NOTICE: input and output samples shall be one sample per row.
%
%   See also EVALUATE, EVALUATE_RBF.
%

%% Initialization

% Variables used to update the waitbar
waitbar_total = length(neurons_range)*num_training;
waitbar_partial = 0;
waitbar_h = waitbar(0, 'MLP Evaluation');

% x are inputs, t are targets, one per column.
x = inputs';
t = outputs';

% Placeholders for outputs
regressions = zeros(length(neurons_range), num_training);
performances = zeros(length(neurons_range), num_training);

% Other constant parameters
trainFcn = 'trainlm';

% i = index of the number neurons in the current network
for i = 1:length(neurons_range)
    
    neurons_number = neurons_range(i);
    
    % j = counter of different trainings with the same network size
    for j = 1:num_training
        
        % Updating waitbar content, it will abort any operation if the
        % waitbar has been closed.
        waitbar_partial = waitbar_partial+1;
        waitbar_update(waitbar_partial/waitbar_total, waitbar_h);
        
        
        % Initializating the network
        net = fitnet(neurons_number, trainFcn);
        net.input.processFcns = {'removeconstantrows','mapminmax'};
        net.output.processFcns = {'removeconstantrows','mapminmax'};
        
        % Dividing the data
        net.divideFcn = 'dividerand';  % Divide data randomly
        net.divideMode = 'sample';  % Divide up every sample
        net.divideParam.trainRatio = 70/100;
        net.divideParam.valRatio = 15/100;
        net.divideParam.testRatio = 15/100;
        
        % Disabling both prints on command line and window to show up
        net.trainParam.showWindow = false;
        net.trainParam.showCommandLine = false;

        % Choose a Performance Function
        net.performFcn = 'mse';                 % Mean Squared Error

        % Train the Network
        [net] = train(net, x, t);

        % Test the Network
        y = net(x);
        
        % Performance is evaluated on the whole training set
        performance = perform(net, t, y);
        
        % Saving data
        performances(i, j) = performance;
        regressions(i, j) = regression(t, y);
    end
end

% Obtaining mean performances for each network size
performances = mean(performances, 2);
regressions = mean(regressions, 2);

% Chosing best index from performances array
[~, best] = min(performances);

% Obtaining then best network size
bestN = neurons_range(best);

close(waitbar_h);

end