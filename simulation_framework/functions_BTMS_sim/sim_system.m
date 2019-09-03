function results = sim_system(config)

[sys_ID, mod_ID, SysSpec, BatPara, SysPara, ~, ModInfo, SysInfo, BTMSConfig] = expand_config(config);


%% Check if this system was already simulated during this run

% If yes: No simulation

persistent sys_ID_tracker

if isempty(sys_ID)
    sys_ID_tracker = sys_ID;
else
    if isempty( sys_ID_tracker( sys_ID_tracker == sys_ID ) )
        sys_ID_tracker = cat(2, sys_ID_tracker, sys_ID);
    else
        results = [];
        return
    end
end

fprintf('Starting system simulation of sys_ID %i\n', sys_ID);


%% Setting up the simulation (user input)

% Refer to 'https://github.com/TUMFTM/sim_battery_system' for an
% explanation of what all of this means

SimPara.t_step               = 0.01;
SimPara.t_sim                = 3*3600;
SimPara.LoggingOutput        = true;
SimPara.OutputDataType       = 'single';
SimPara.OutputDecimation     = 100;
SimPara.LoadSpectra_enable   = false;

SysPara.I_charge_min   = 10;    % Stop charging when charging current drops below this value in A
SysPara.SOC_charge_max = 1;  % Stop charging when any cell SOC in the battery system is over this value


% All thermal resistances and heat transfer effects between the cells are
% combined in a thermal transmittance alpha for each spacial direction.
% Set so zero if there is no heat transfer in one or more spacial
% directions.

SysPara.thermal.transfer.alpha_x = 5;       % thermal transmittance between the cells in x-direction in W/(m^2*K)
SysPara.thermal.transfer.alpha_y = 5;       % thermal transmittance between the cells in y-direction in W/(m^2*K)
SysPara.thermal.transfer.alpha_z = 5;       % thermal transmittance between the cells in z-direction in W/(m^2*K)

SysPara.thermal.transfer.alpha_mod_gap = 1;  % heat transfer coefficient between the cells in all direction between different modules in W/(m^2*K)


% Worst-Case: No heat exchange of battery with environment
% Note this is only valid for the case of cooling if T_ambient < T_battery!

SysPara.thermal.T_cell_ambient = 25;
SysPara.thermal.alpha_cell_ambient = 0;


%% Providing the system parameters for the simulation

SysPara.p = SysPara.p_sys;
SysPara.s = SysPara.s_sys;

SysPara.I_charge = SysSpec.I_sys_max;
SysPara.U_charge_target = interp1(BatPara.electrical.OCV.SOC, BatPara.electrical.OCV.U, SysPara.SOC_charge_max, 'linear', 'extrap');

SysPara.DeviationMap = SysPara_DeviationMap(BatPara, SysPara.p, SysPara.s);


%% Providing the thermal system parameters for simulation

% Get position, spacial direction and heat transfer coefficient of gaps between modules
% We assume the same value for all spacial directions and positions. 

[SysPara.thermal.transfer.layer, SysPara.thermal.transfer.dir, SysPara.thermal.transfer.alpha] = special_heat_transfer_positons(SysPara.thermal.transfer.alpha_mod_gap, ModInfo, SysInfo);

% Caluclate the heat transfer matrix

SysPara.thermal.transfer.K_transfer = calc_heat_transfer_matrix(SysPara.pe_sys, SysPara.e_sys, SysPara.s_sys,...    % System interconnection info
    SysPara.thermal.transfer.A_x, SysPara.thermal.transfer.A_y, SysPara.thermal.transfer.A_z,...                    % Heat conducting surfaces in all spacial directions
    SysPara.thermal.transfer.alpha_x, SysPara.thermal.transfer.alpha_y, SysPara.thermal.transfer.alpha_z,...        % Heat transfer coefficients between cells in all spacial directions
    SysPara.thermal.transfer.layer, SysPara.thermal.transfer.alpha, SysPara.thermal.transfer.dir);                  % Position, spacial direction and heat transfer coefficient of gaps between modules


%% Initial State

% Initial state of every individual cell insode the system (hence the
% 'ones(BatSys.p,BatSys.s)'). This allows the adaption to measurement data or to induce
% initial load imbalances or thermal gradients.

% In our example, there is a inbalance of SOC, represented as a normal
% distribution randn(BatSys.p,BatSys.s).

SysPara.BatStateInit.electrical.SOC    = ones(SysPara.p,SysPara.s) * 0;  
SysPara.BatStateInit.electrical.U_hyst = ones(SysPara.p,SysPara.s) * 0;
SysPara.BatStateInit.electrical.U_RC1  = ones(SysPara.p,SysPara.s) * 0;
SysPara.BatStateInit.electrical.U_RC2  = ones(SysPara.p,SysPara.s) * 0;
SysPara.BatStateInit.electrical.U_RC3  = ones(SysPara.p,SysPara.s) * 0;
SysPara.BatStateInit.electrical.U_RC4  = ones(SysPara.p,SysPara.s) * 0;
SysPara.BatStateInit.electrical.I_cell = ones(SysPara.p,SysPara.s) * 0;

% Thermal initialization. Even if you don't use the thermal submodel you
% must specify something!

SysPara.BatStateInit.thermal.T_cell    = ones(SysPara.p,SysPara.s) * 25;


%% Setting up the simulation

% We only want to simulation the electrical side so all thermal simulation
% is deactivated

SimPara.thermal_sim_enable   = true;
SimPara.heat_exchange_enable = true;
SimPara.TempSensors_enable   = false;
SimPara.BTMS_sim_enable      = true;


%% Remove incompatible fields

% Those are fields containing data-types which will lead to an error in
% Simulink and aren't needed for simulation anyway.

BTMSConfig = rmfield(BTMSConfig,'info');
BatPara = rmfield(BatPara,{'name', 'cell_type'});
SysPara = rmfield(SysPara,'name');


%% Starting the simulation

% Write variables to model workspace

model = 'sim_BTMS';

load_system(model);
mod_wrksp = get_param(model,'ModelWorkspace');
assignin(mod_wrksp,'SysPara',SysPara)
assignin(mod_wrksp,'BatPara',BatPara)
assignin(mod_wrksp,'BTMSConfig',BTMSConfig)

% SimPara must be assigned to base workspace because of limitation of
% Simulink Variant Subsystem configuration
assignin('base','SimPara',SimPara)

simOut = sim(model);


%% Clear model workspace

clear(mod_wrksp)
close_system(model)


%% Clear unneeded variables

results.sys_ID = sys_ID;
results.mod_ID = mod_ID;

results.SysPara = SysPara;
results.I_cell = simOut.I_cell;
results.I_load = simOut.I_load;
results.SOC = simOut.SOC;
results.U_Pack = simOut.U_Pack;
results.U_cell = simOut.U_cell;

results.T_cell = simOut.T_cell;
results.T_cell_gradient = simOut.T_cell_gradient;
results.T_BTMS_out = simOut.T_BTMS_out;

end