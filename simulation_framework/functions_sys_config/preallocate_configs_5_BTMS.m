function configs = preallocate_configs_5_BTMS

configs = preallocate_configs_4_sys;
configs.BTMSConfig = [];
configs.BTMS_ID = [];

% Arrrange fields (move BTMS name to the beginning)

permutation_vec = [1 2 3 13 4 5 6 7 8 9 10 11 12];
configs = orderfields(configs, permutation_vec);

