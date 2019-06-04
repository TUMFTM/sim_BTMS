function [config, passed] = mod_test_energy(config)

% This function tests the dimension of the module and compares it to the
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



%% Calculate some module info and module energy content

C_mod = C_A_cell * p;               % Module capacity Ah
U_nom_mod = U_nom_cell * s;         % Nominal module voltage in V

E_mod = C_mod * U_nom_mod * 1e-3;   % Module energy content in kWh

U_min_mod = U_min_cell * s;         % Minimum module voltage in V
U_max_mod = U_max_cell * s;         % Maximum module voltage in V



%% Test module against criteria

passed = struct('E_mod',false);

if E_mod >= config.SysSpec.E_mod_min
    passed.E_mod = true;
end


%% Return config

config.ModInfo.C_mod = C_mod;
config.ModInfo.E_mod = E_mod;
config.ModInfo.U_nom_mod = U_nom_mod;
config.ModInfo.U_min_mod = U_min_mod;
config.ModInfo.U_max_mod = U_max_mod;
