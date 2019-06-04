function configs = preallocate_configs_2_mod

dummy_field = cell(1);

configs = preallocate_configs_1_mod_all;
configs.ModInfo = [];
configs.Tests = [];