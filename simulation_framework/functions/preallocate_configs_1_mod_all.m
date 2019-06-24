function configs = preallocate_configs_1_mod_all

% Create an empty structure

dummy_field = cell(1);

configs = struct(...
    'mod_ID', NaN, ...              % Unique module configuration ID
    'SysSpec', dummy_field, ...     % Specified system parameters (target specs for the algorithm)
    'BatPara', dummy_field, ...     % Battery parameters (for battery config and simulation)
    'SysPara', dummy_field, ...     % System parameters (for system config and simulation)
    'BTMSPara', dummy_field);       % BTMS parameters (for BTMS config and simulation)

