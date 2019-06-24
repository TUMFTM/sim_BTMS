function configs = preallocate_configs_2_mod

configs = preallocate_configs_1_mod_all;    % Include old structure
configs.ModInfo = [];       % Infos about the module configuration
configs.Tests_mod = [];     % Results of module tests