function results = sim_module(config)

[sys_ID, mod_ID, SysSpec, BatPara, SysPara, BTMSPara, ModInfo, SysInfo, BTMSConfig] = expand_config(config);


%% Check if this module was already simulated during this run

% If yes: No simulation

persistent mod_ID_tracker

if isempty(mod_ID)
    mod_ID_tracker = mod_ID;
else
    if isempty( mod_ID_tracker( mod_ID_tracker == mod_ID ) )
        mod_ID_tracker = cat(2, mod_ID_tracker, mod_ID);
    else
        results = [];
        return
    end
end

fprintf('Starting module simulation of mod_ID %i\n', mod_ID);


%% Setting up the simulation (user input)

% Refer to 'https://github.com/TUMFTM/sim_battery_system' for an
% explanation of what all of this means

SimPara.t_step               = 0.01;
SimPara.t_sim                = 100;
SimPara.LoggingOutput        = true;
SimPara.OutputDataType       = 'single';
SimPara.OutputDecimation     = 100;
SimPara.LoadSpectra_enable   = false;

SysPara.thermal.T_cell_ambient = 25;


%% Providing the system parameters for the simulation

SysPara.p = SysPara.p_mod;
SysPara.s = SysPara.s_mod;

SysPara.I_charge = SysSpec.I_mod_max;

SysPara.DeviationMap = SysPara_DeviationMap(BatPara, SysPara.p, SysPara.s);


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


%% Setting up the simulation (don't edit)

% We only want to simulation the electrical side so all thermal simulation
% is deactivated

SimPara.thermal_sim_enable   = false;
SimPara.heat_exchange_enable = false;
SimPara.TempSensors_enable   = false;
SimPara.BTMS_sim_enable      = false;

SysPara.thermal.alpha_cell_ambient = 0;


%% Remove incopatible fields

BTMSConfig = rmfield(BTMSConfig,'info');
BatPara = rmfield(BatPara,{'name', 'cell_type'});
SysPara = rmfield(SysPara,'name');


%% Starting the simulation

% Write variables to model workspace

model = 'sim_BTMS';

% % Get model workspace
% hws = get_param(model, 'modelworkspace');
% % Get the list of variables defined within the function
% list = whos;        
% N = length(list);
% % Assign everything from the local fucntion workspace to the model workspace
% for  i = 1:N
%       hws.assignin(list(i).name,list(i));
% end

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

results.mod_ID = mod_ID;
results.SysPara = SysPara;
results.I_cell = simOut.I_cell;
results.I_load = simOut.I_load;
results.SOC = simOut.SOC;
results.U_Pack = simOut.U_Pack;
results.U_cell = simOut.U_cell;
results.U_R = simOut.U_R;
results.sum_U_RC = simOut.sum_U_RC;

