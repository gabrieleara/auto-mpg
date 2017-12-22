function main(varargin)
%MAIN   Executes the whole assignment. It may take some time.
%
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
%   - 'safeMode' (default: false) valid only when evaluation part is not
%   skipped. Uses standard newrb function instead of a modified one, see
%   EVALUATE_RBF for futher details.
%   Accepted values:
%        .) 0, false, 'false', 'off' -> evaluation not in safe mode;
%        .) 1, true, 'true', 'on'    -> evaluation in safe mode.
%
%   - 'verbose' (default: true) if enabled it will print multiple messages
%   on the console. If not command is completely silent.
%   Accepted values:
%        .) 0, false, 'false', 'off' -> verbose mode off;
%        .) 1, true, 'true', 'on'    -> verbose mode on.
%
%   - 'equalAxis' (default: false) valid only when display part is not
%   skipped. It uses same axis on both sides of each subplot.
%   Accepted values:
%        .) 0, false, 'false', 'off' -> each plot has its own limits;
%        .) 1, true, 'true', 'on'    -> each plot will have same limits.
%
%
%   See also EVALUATE, DISPLAY_RESULTS.

%% Arguments initialization

deterministic   = false;
evaluate_only   = false;
display_only    = false;
safe_mode       = false;
verbose         = true;
equal_axis      = false;

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
                valarg = true;
            case 'off'
                valarg = false;
            case 'ON'
                valarg = true;
            case 'OFF'
                valarg = false;
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
            evaluate_only = valarg;
        case 'displayOnly'
            display_only = valarg;
        case 'safeMode'
            safe_mode = valarg;
        case 'verbose'
            safe_mode = valarg;
        case 'equalAxis'
            equal_axis = valarg;
        otherwise
            error('Argument %d is invalid, unrecognized argument: %s.', i, mat2str(varargin{i}));
    end
end

if display_only && evaluate_only
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
if not(display_only)
    evaluate(verbose, safe_mode);
end

% Picks results from evaluation from data folder and displays them in a
% window
if not(evaluate_only)
    display_results(equal_axis);
end

if deterministic
    rng(seed);
end

end