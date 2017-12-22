function [bestN, bestS, mean_performances, mean_regressions, ...
    performances, regressions] = ...
        evaluate_rbf(inputs, outputs, neurons_range, spread_range, num_training, safe_mode)
% EVALUATE_RBF  Evaluates the best RBF network size N and spread S for the
%               given problem.
%
%   [bestN, bestS] = EVALUATE_RBF(inputs, outputs, neurons_range, ...
%                                 spread_range)
%       returns the best network size inside neurons_range and the best
%       spread inside spread_range for the given problem.
%       To do so, it trains num_traning different networks for each network
%       size, one for each spread.
%
%   [bestN, bestS] = EVALUATE_RBF(___, num_training)
%       num_training argument is optional and allows for each network size
%       and spread multiple trainings. It takes more time and each training
%       uses only a subset of all the possible inputs in the global set.
%
%   [bestN, bestS, mean_performances, mean_regressions] = EVALUATE_RBF(___)
%       returns the best network size, best spread, an array of performance
%       evalutations and mean regression values, one for each network size.
%       Values in performances and regressions are obtained by averaging
%       performance evaluations and regressions of each trained networks of
%       the same size.
%
%   [___, performances] = EVALUATE_RBF(___)
%       returns also all the performances of each network that has been
%       trained.
%
%   [___, performances, regressions] = EVALUATE_RBF(___)
%       returns also all the regressions of each network that has been
%       trained.
%
%   NOTICE: input and output samples shall be one sample per row.
%
%   NOTICE: this function uses a modified version of newrb called
%           newrb_mod. This has been done only to disable annoying figures
%           that show up each time a new training is performed and to speed
%           up the whole process. The newrb version used in this project is
%           the one provided with MATLAB R2017b.
%
%           If you want to use the standard newrb instead than the modified
%           one, last argument shall be a boolean equal to true. It doesn't
%           matter if there is or not the optional num_training argument.
%
%   See also EVALUATE, EVALUATE_MLP.
%

% If no num_training argument is provided, only one training per network
% size and spread is executed.
% Since the output of newrb is deterministic if same inputs are given, to
% train multiple times with different data the network we need to limit
% training inputs to a randomly chosen subset of the global input set.
if nargin < 4
    error('At least 4 arguments shall be provided.');
elseif nargin < 5
    num_training = 1;
elseif nargin < 6
    if islogical(num_training)
        safe_mode = num_training;
        num_training = 1;
    else
        safe_mode = false;
    end
end

if num_training < 1
    num_training = 1;
end

if safe_mode
    newrb_f = 'newrb';
else
    newrb_f = 'newrb_mod';
end

% This is the command that will be used to train the network
command = strcat(newrb_f, '(xset, tset, goal, spread, neurons_number, increment)');

% Variables used to update the waitbar
waitbar_total   = length(neurons_range)*length(spread_range)*num_training;
waitbar_partial = 0;
waitbar_h = waitbar(0, 'RBF Evaluation');

% x are inputs, t are targets, one per column.
x = inputs';
t = outputs';

% Placeholders for outputs
regressions  = zeros(length(neurons_range), length(spread_range));
performances = zeros(length(neurons_range), length(spread_range));

% The error we want to achieve each training
goal = 0;

% i = index of the number neurons in the current network
for i = 1:length(neurons_range)
    
    neurons_number = neurons_range(i);
    
    % The increment used in the newrb function to display output, we set it
    % to the number of neurons to reduce computation time.
    increment = neurons_number;
    
    % s = index of the current evaluated spread size
    for s = 1:length(spread_range)
        
        spread = spread_range(s);
        
        if num_training > 1
            
            performances_temp   = zeros(1, num_training);
            regressions_temp    = zeros(1, num_training);
            
            % j = counter of different trainings with the same network size
            % and spread
            for j = 1:num_training
                
                % Updating waitbar content, it will abort any operation if the
                % waitbar has been closed.
                waitbar_partial = waitbar_partial+1;
                waitbar_update(waitbar_partial/waitbar_total, waitbar_h);
                
                % Generate a set of indexes randomly, covering 70% of
                % inputs
                xset_i = sort(datasample(1:length(x), ...
                    floor(length(x)*0.7), 'Replace', false));

                % Obtain inputs and targets
                xset = x(:, xset_i);
                tset = t(xset_i);

                % Evalc is needed to avoid unintended prints on the screen
                [~, net] = evalc(command);
                
                % Testing and evaluating network performances
                [performance, regression_v] = test_and_evaluate_net(net, x, t);

                performances_temp(j)  = performance;
                regressions_temp(j)   = regression_v;
            end
            
            % Performances and regressions for each network size and spread
            % are the average of the respective values of each training
            performances(i, s)  = mean(performances_temp);
            regressions(i, s)   = mean(regressions_temp);
            
        else
            % Updating waitbar content, it will abort any operation if the
            % waitbar has been closed.
            waitbar_partial = waitbar_partial+1;
            waitbar_update(waitbar_partial/waitbar_total, waitbar_h);
            
            xset = x;
            tset = t;
            
            % Evalc is needed to avoid unintended prints on the screen
            [~, net] = evalc(command);
            
            % Testing and evaluating network performances
            [performance, regression_v] = test_and_evaluate_net(net, x, t);

            performances(i, s)  = performance;
            regressions(i, s)   = regression_v;
        end
    end
end

% Obtaining mean performances for each network size
mean_performances   = mean(performances, 2);
mean_regressions    = mean(regressions, 2);

% Chosing best index from performances array
[~, best] = min(mean_performances);

% Obtaining then best network size
bestN = neurons_range(best);

% Chosing best index for spread, based on performances array
[~, best] = min(squeeze(performances(best, :)));

% Obtaining then best spread
bestS = spread_range(best);

close(waitbar_h);

% TODO: remove
delete(findall(0,'Type','figure'));

end

function [performance, regression_v] = test_and_evaluate_net(net, x, t)

% Choose a Performance Function
net.performFcn = 'mse';             % Mean Squared Error

% Test the Network
y = net(x);

% Performance is evaluated on the whole training set
performance = perform(net,t,y);

% Saving data
regression_v = regression(t, y);

end