function check_feasible_configs(configs)

num_of_configs = size(configs, 2);

if isnan(configs(1).mod_ID)
    error('No feasible concepts in %s!', inputname(1))
else
   fprintf('There are %i concepts in %s.\n', num_of_configs ,inputname(1))
end