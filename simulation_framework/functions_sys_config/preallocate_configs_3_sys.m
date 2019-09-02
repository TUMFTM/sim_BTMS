function configs = preallocate_configs_3_sys

configs = preallocate_configs_2_mod;    % Include old structure
configs.sys_ID = NaN;   % Unique system ID
configs.SysInfo = [];   % Infos about the system tests

% Arrange field order (move 'sys_config_no' to first position)

permutation_vec = [9 1 2 3 4 5 6 7 8 10];
configs = orderfields(configs, permutation_vec);