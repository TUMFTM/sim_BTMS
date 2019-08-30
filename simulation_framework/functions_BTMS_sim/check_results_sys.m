function [res, passed] = check_results_sys(res, config)

% Check electrical and thermal simulation results


%% Get relevant params

I_max_cell = config.BatPara.electrical.I_max;
U_min_cell = config.BatPara.electrical.U_min;
U_max_cell = config.BatPara.electrical.U_max;

T_grad_max      = config.SysSpec.T_grad_max ;
T_max           = config.SysSpec.T_max ;
T_fluid_out_max = config.SysSpec.T_fluid_out_max;


%% Check for overload (electric)

I_max_sys = max(max(max(res.I_cell.Data)));
SOC_max_sys = max(max(max(res.SOC.Data)));
SOC_min_sys = min(min(min(res.SOC.Data)));
U_min_sys = min(min(min(res.U_cell.Data)));
U_max_sys = max(max(max(res.U_cell.Data)));


%% Check for overload (thermal)

T_max_sys       = max(max(max(res.T_cell.Data)));
T_grad_max_sys  = 0; % TODO!
T_fluid_out_sys = max(max(max(res.T_BTMS_out.Data)));


%% Create test matrix

passed.I_max = false;
passed.SOC_max = false;
passed.SOC_min = false;
passed.U_max = false;
passed.U_min = false;
passed.U_max = false;
passed.U_max = false;
passed.U_max = false;

if I_max_sys <= I_max_cell
    passed.I_max = true;
end

if U_min_sys >= U_min_cell
    passed.U_max = true;
end

if U_max_sys <= U_max_cell
    passed.U_min = true;
end

if SOC_max_sys <= 1
    passed.SOC_min = true;
end

if SOC_min_sys >= 0
    passed.SOC_max = true;
end

if T_grad_max_sys <= T_grad_max
    passed.T_grad_max = true;
end

if T_max_sys <= T_max
    passed.T_max = true;
end

if T_fluid_out_sys <= T_fluid_out_max
    passed.T_fluid_out_max = true;
end


%% Append results to res struct

res.Tests_sys.I_max   = passed.I_max;
res.Tests_sys.SOC_max = passed.SOC_max;
res.Tests_sys.SOC_min = passed.SOC_min;
res.Tests_sys.U_min   = passed.U_min;
res.Tests_sys.U_max   = passed.U_max;

res.Tests_sys.T_grad_max      = passed.T_grad_max;
res.Tests_sys.T_max           = passed.T_max;
res.Tests_sys.T_fluid_out_max = passed.T_fluid_out_max;


end