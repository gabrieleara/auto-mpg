function main(varargin)
% MAIN  Executes the whole assignment. It may take some time.
%   MAIN(param, value, ...) executes the assignment with the given
%       parameter, see list of parameters below. Multiple parameters can be
%       given to the same call.
%
%   List of Parameters:
%   
%   - 'deterministic' (default: false), executes the main in deterministic
%   mode, results obtained are always the same. It may change state of
%   random number generators for whole MATLAB environment.
%   Accepted values:
%        .) 0, false, 'false', 'off' -> deterministic mode off;
%        .) 1, true, 'true', 'on'    -> deterministic mode on.
%
%   - 'evaluateOnly' (default: false) executes only the training and
%   evaluation of trained networks, skipping the display part. It saves
%   obtained data inside the data folder.
%   Accepted values:
%        .) 0, false, 'false', 'off' -> executes also display;
%        .) 1, true, 'true', 'on'    -> executes only evaluation.
%
%   - 'displayOnly' (default: false) executes only the display of the
%   results contained in the data folder, skipping the evaluation part. It
%   may arise an error if there are not data to be displayed or data are
%   incomplete.
%   Accepted values:
%        .) 0, false, 'false', 'off' -> executes evaluation first;
%        .) 1, true, 'true', 'on'    -> skips evaluation.
%
%
%   See also EVALUATE, DISPLAY_RESULTS.

%% Arguments initialization

deterministic = false;
evaluateOnly = false;
displayOnly = false;

%% Arguments evaluation

for i = 1:2:nargin
    if(i ~= nargin)
        valarg = varargin{i+1};
        switch(valarg)
            case 0
            case 1
            case false
            case true
            case 'false'
            case 'true'
            case 'on'
                valarg = 1;
            case 'off'
                valarg = 0;
            case 'ON'
                valarg = 1;
            case 'OFF'
                valarg = 0;
            otherwise
                error('Argument %d is invalid: given value: %s.', i+1, mat2str(valarg));
        end
    else
        valarg = true;
    end
    
    switch(varargin{i})
        case 'deterministic'
            deterministic = valarg;
        case 'evaluateOnly'
            evaluateOnly = valarg;
        case 'displayOnly'
            displayOnly = valarg;
        otherwise
            error('Argument %d is invalid, unrecognized argument: %s.', i, mat2str(varargin{i}));
    end
end

if displayOnly && evaluateOnly
    error("Conflicting arguments: you can't use both evaluateOnly and displayOnly.");
end

%% Main assignment

seed = rng;

% Execution in deterministic mode sets the seed for each Matlab random
% number generator, hence providing always the same results.
if deterministic
    rng(1337);
end

% Evaluates input data, trains networks and saves results in the data
% folder
if not(displayOnly)
    evaluate;
end

% Picks results from evaluation from data folder and displays them in a
% window
if not(evaluateOnly)
    display_results;
end

if deterministic
    rng(seed);
end

end