function check_feasible_configs(configs)

num_of_configs = size(configs, 2);

try
   isempty(configs.BatPara);
   error('No feasible concepts in %s!', inputname(1))
   
catch
   fprintf('There are %i concepts in %s.\n', num_of_configs ,inputname(1))
end