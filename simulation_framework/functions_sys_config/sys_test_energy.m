function [config, passed] = sys_test_energy(config)

% This function tests the energy in kWh of a pack and compares it to the
% specifications made in 'system_specifications'



%% Get relevant data out of the structure


% Module data

C_mod     = config.ModInfo.C_mod;       % Module capacity in Ah
U_nom_mod = config.ModInfo.U_nom_mod;   % Nominal module voltage in Ah

U_min_mod = config.ModInfo.U_min_mod;   % Minimum module voltage in Ah
U_max_mod = config.ModInfo.U_max_mod;   % Maximum module voltage in Ah


% Electrical pack connection data

p = config.SysInfo.num_parallel_mods_sys;  % Total number of parallel modules
s = config.SysInfo.num_mods_sys;           % Total number of serial modules



%% Calculate some module info and module energy 

C_sys = C_mod * p;                  % Module capacity Ah
U_nom_sys = U_nom_mod * s;          % Nominal module voltage in V

E_sys = C_sys * U_nom_sys * 1e-3;   % Module energy in kWh

U_min_sys = U_min_mod * s;         % Minimum module voltage in V
U_max_sys = U_max_mod * s;         % Maximum module voltage in V



%% Test system against criteria

passed = struct('energy_sys',false);

if E_sys >= config.SysSpec.E_sys_min
    passed.energy_sys = true;
end


%% Write system info

config.SysInfo.C_sys = C_sys;
config.SysInfo.E_sys = E_sys;
config.SysInfo.U_nom_sys = U_nom_sys;
config.SysInfo.U_min_sys = U_min_sys;
config.SysInfo.U_max_sys = U_max_sys;
