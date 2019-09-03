function save_sim_result(results, test_results, name_prefix, sys_lvl, status)

% Save results from module or system simulation

%% Expand struct

mod_ID  = results.mod_ID;
SysPara = results.SysPara;
I_cell  = results.I_cell;
I_load  = results.I_load;
SOC     = results.SOC;
U_Pack  = results.U_Pack;
U_cell  = results.U_cell;

if strcmp(sys_lvl, 'sys') 
    sys_ID          = results.sys_ID;
    T_cell          = results.T_cell;
    T_cell_gradient = results.T_cell_gradient;
    T_BTMS_out_max  = results.T_BTMS_out_max;
end


%% Create save name

name = strcat('BTMS_simulation_results/', name_prefix, '_', sys_lvl, '_ID_', '%i_', status);

switch sys_lvl
    case 'mod'
        name = sprintf(name, mod_ID);
    case 'sys'
        name = sprintf(name, sys_ID);
    otherwise
        error('Wrong sys_lvl option given!')
end

%% Save results

save(name, '-regexp', '^(?!(name|name_prefix|results|status|sys_lvl)$).', '-v7.3')


end