function configs = append_configs_2_mod(configs, config_append, passed, status)

% Check if first run in this simulation. If first run write at first array
% position, otherwise append data to already existing data.

persistent first_run_fail
persistent first_run_pass

if isempty(first_run_fail) && strcmp(status, 'fail')
    index = 1;  
    first_run_fail = false;
    
elseif isempty(first_run_pass) && strcmp(status, 'pass')
    index = 1;  
    first_run_pass = false;
    
else
    index = size(configs,2)+1;
end

config_append.Tests = passed;

 configs(index) = config_append;