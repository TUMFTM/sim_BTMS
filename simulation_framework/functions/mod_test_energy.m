function [config, passed] = mod_test_energy(config)

% This function tests the energy in kWh of a module and compares it to the
% specifications made in 'system_specifications'



%% Get relevant data out of the structure

% Cell data

C_A_cell   = config.BatPara.electrical.C_A;     % Cell capacity in Ah
U_nom_cell = config.BatPara.electrical.U_nom;   % Nominal cell voltage in Ah

U_min_cell = config.BatPara.electrical.U_min;   % Minimum cell voltage in Ah
U_max_cell = config.BatPara.electrical.U_max;   % Maximum cell voltage in Ah

% Electrical connection data

p =  config.SysPara.p;  % Total number of parallel cells
s =  config.SysPara.s;  % Total number of serial cells



%% Calculate some module info and module energy 

C_mod = C_A_cell * p;               % Module capacity Ah
U_nom_mod = U_nom_cell * s;         % Nominal module voltage in V

E_mod = C_mod * U_nom_mod * 1e-3;   % Module energy in kWh

U_min_mod = U_min_cell * s;         % Minimum module voltage in V
U_max_mod = U_max_cell * s;         % Maximum module voltage in V



%% Test module against criteria

passed = struct('energy_mod',false);

if E_mod >= config.SysSpec.E_mod_min
    passed.energy_mod = true;
end


%% Write module info

config.ModInfo.C_mod = C_mod;
config.ModInfo.E_mod = E_mod;
config.ModInfo.U_nom_mod = U_nom_mod;
config.ModInfo.U_min_mod = U_min_mod;
config.ModInfo.U_max_mod = U_max_mod;


%% Also include information about the electrical interconnection

% This is also included in config.SysSpec (as a later simulation input),
% but we also include it to config.ModInfo so all relevant info can be
% gathered in first sight.

config.ModInfo.num_cells_mod = config.SysPara.p * config.SysPara.s;
config.ModInfo.num_serial_cells_mod = config.SysPara.s;
config.ModInfo.num_parallel_cells_mod = config.SysPara.p;
config.ModInfo.num_layers_mod = config.SysPara.e;
config.ModInfo.num_parallel_cells_per_layer_mod = config.SysPara.pe;
