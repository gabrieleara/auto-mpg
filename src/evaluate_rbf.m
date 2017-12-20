function [best_network_size, perf_values, regr_values, best_spread] = ...
    rbf_performance_evaluation(inputs, outputs, ...
        neurons_range, num_trainings, ...
        training_type, num_spreads)

% TODO: best spread for each network size

h = waitbar(0, strcat('RBF Evaluation - type: ', training_type));

x = inputs';
t = outputs';

[n,m] = size(x);

DisplayFigure = 0; % Suppresses the window

goal = 0;

perf_values = zeros(length(neurons_range), num_spreads);
regr_values = zeros(length(neurons_range), num_spreads);

best_spread = zeros(length(neurons_range));

distances = pdist(inputs);
max_dist = max(distances);
min_dist = min(distances);

% base_increment = 2^3 * 3^3 * 5^2 * 7 * 11 * 13 * 17 * 19;

set(0,'DefaultFigureVisible','off'); % Does not work, but I tried

% i = index of the number neurons in the current network
for i = 1:length(neurons_range)
    
    number_neurons = neurons_range(i);
    
    % increment = gcd(gcd(base_increment, number_neurons), floor(number_neurons / 3));
    increment = number_neurons;
    
    % s = counter of the number of spreads with the same network size
    for s = 1:num_spreads
        
        waitbar(((i*num_spreads + s) / (length(neurons_range)*num_spreads)), h);
        
        tmp_perf_values = zeros(num_trainings, 1);
        tmp_regr_values = zeros(num_trainings, 1);
        
        % j = counter of different trainings with the same network size and
        % spread count
        for j = 1:num_trainings
            
            update_waitbar(((((i-1)*num_spreads+(s-1))*num_trainings + (j-1)) / (length(neurons_range)*num_spreads*num_trainings)), h);
            
            switch(training_type)
                case 'non-exact'
                    spread = current_static_spread(min_dist, max_dist, s, num_spreads);
                    
                    xset_i = sort(datasample(1:length(x),floor(length(x)*0.7), 'Replace', false));
                    xset = x(:, xset_i);
                    tset = t(xset_i);

                    % [~, net] = evalc('newrb(x, t, goal, spread, number_neurons, 1)');
                    [~, net] = evalc('newrb(xset, tset, goal, spread, number_neurons, increment)');
                    
                case 'exact-clustering'
                    
                    xcopy = x;
                    tcopy = t;
                    
                    xset = zeros(n, number_neurons);
                    
                    [~, C] = kmeans(x',number_neurons);
                    
                    for z = 1:number_neurons
                        
                        x_ = xcopy';
                        
                        dist = pdist2(C(z, :), x_);     % compute distances
                        mindist = min(dist);            % minimum distance
                        center = find(dist==mindist, 1);
                        
                        xset(:, z) = xcopy(:, center);
                        tset(:, z) = tcopy(center);
                        
                        [~, w] = size(xcopy);
                        indexes = true(w, 1);
                        indexes(center) = false;
                        
                        xcopy = xcopy(:, indexes);
                        tcopy = tcopy(indexes);
                    end
                    
                    % Calculate spread
                    spread = max(pdist(xset')) / sqrt(number_neurons);
                    
                    % Perform newrbe
                    net = newrbe(xset, tset, spread);
                    
                otherwise
                    error('Incorrect value of training_type!');
            end
            
            % Choose a Performance Function
            net.performFcn = 'mse';  % Mean Squared Error
            
            % Test the Network
            y = net(x);

            % Performance is evaluated on the whole training set
            performance = perform(net,t,y);

            % Saving data
            tmp_perf_values(j) = performance;
            tmp_regr_values(j) = regression(t, y);
        end
        
        perf_values(i, s) = mean(tmp_perf_values);
        regr_values(i, s) = mean(tmp_regr_values);
    end
end

close(h);
delete(findall(0,'Type','figure'));

perf_values = mean(perf_values, 2);
regr_values = mean(regr_values, 2);

[~, best] = min(perf_values);

best_network_size = neurons_range(best);

set(0,'DefaultFigureVisible','on');

end


function spread = current_static_spread(min_dist, max_dist, s, num_spread)

diff = max_dist - min_dist;

start = diff * 0.1 + min_dist;
stop = diff * 0.9 + max_dist;

norm_value = (s-num_spread) / num_spread * 6;

spread = exp(norm_value) * (stop - start) + start;

end