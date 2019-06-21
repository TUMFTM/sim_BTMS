function configs = append_configs(configs, config_append, passed, status)

persistent first_run_fail
persistent first_run_pass

% Check if first run in this simulation. If first run write at first array
% position, otherwise append data to already existing data.

switch nargin
    case 2
        if isempty(first_run_fail) 
            first_run_fail = false;
            first_run_pass = false;
            index = 1;
        else
            index = size(configs,2)+1;
        end
         
    case 4
        if isempty(first_run_fail) && strcmp(status, 'fail')
            index = 1;  
            first_run_fail = false;         
        elseif isempty(first_run_pass) && strcmp(status, 'pass')
            index = 1;  
            first_run_pass = false;
        else
            index = size(configs,2)+1;
        end
        
        if isfield(configs, 'Tests_sys')
            config_append.Tests_sys = passed;
        elseif isfield(configs, 'Tests_mod')
            config_append.Tests_mod = passed;
        end
        
    otherwise
        error('Wrong number of input arguments!')
end

configs(index) = config_append;