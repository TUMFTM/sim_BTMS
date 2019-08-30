function [res, passed] = check_results_mod(res, config)

% Check electrical simulation results


%% Get relevant params

I_max_cell = config.BatPara.electrical.I_max;
U_min_cell = config.BatPara.electrical.U_min;
U_max_cell = config.BatPara.electrical.U_max;


%% Check for overload

I_max_mod = max(max(max(res.I_cell.Data)));
SOC_max_mod = max(max(max(res.SOC.Data)));
SOC_min_mod = min(min(min(res.SOC.Data)));
U_min_mod = min(min(min(res.U_cell.Data)));
U_max_mod = max(max(max(res.U_cell.Data)));


%% Create test matrix

passed.I_max = false;
passed.U_min = false;
passed.U_max = false;
passed.SOC_max = false;
passed.SOC_min = false;

if I_max_mod <= I_max_cell
    passed.I_max = true;
end

if U_min_mod >= U_min_cell
    passed.U_max = true;
end

if U_max_mod <= U_max_cell
    passed.U_min = true;
end

if SOC_max_mod <= 1
    passed.SOC_min = true;
end

if SOC_min_mod >= 0
    passed.SOC_max = true;
end


%% Append results to res struct

res.Tests_mod_el.I_max   = passed.I_max;
res.Tests_mod_el.SOC_max = passed.SOC_max;
res.Tests_mod_el.SOC_min = passed.SOC_min;
res.Tests_mod_el.U_min   = passed.U_min;
res.Tests_mod_el.U_max   = passed.U_max;


end