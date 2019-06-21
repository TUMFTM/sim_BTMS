function [config, passed] = sys_test_dimensions_no_BTMS(config)

% This function tests the dimension of the pack and compares it to the
% specifications made in 'system_specifications'



%% Get relevant data out of the structure

% Module data

length_mod = config.ModInfo.length_mod;
width_mod = config.ModInfo.width_mod;
height_mod = config.ModInfo.height_mod;
mass_mod = config.ModInfo.mass_mod;


% interconnection data

tot = config.PackInfo.num_mods_sys;                     % Total number of modules
s   = config.PackInfo.num_serial_mods_sys;              % Total number of serial modules
pe  = config.PackInfo.num_layers_sys;                   % Total number of parallel cells on one level
e   = config.PackInfo.num_parallel_mods_per_layer_sys;  % Total number of levels


% Correction and safety factors

sf_dim_sys  = 1 + config.SysSpec.sf_dim_sys;     % Safety factor for module dimensions (x,y,z)
sf_mass_sys = 1 + config.SysSpec.sf_mass_sys;    % Safety factor for module mass



%% Calculate system mass and dimensions

% We always assume the same orientation of the modules inside the system.

mass_sys = mass_mod * tot * sf_mass_sys;

length_sys = length_mod * s * sf_dim_sys;       
width_sys = width_mod * pe * sf_dim_sys;
height_sys = height_mod * e * sf_dim_sys;


%% Test system against criteria

passed = struct('mass_sys',false, 'length_sys',false, 'width_sys',false, 'height_sys',false);

if mass_sys <= config.SysSpec.m_sys_max
    passed.mass_sys = true;
end

if length_sys <= config.SysSpec.l_sys_max
    passed.length_sys = true;
end

if width_sys <= config.SysSpec.w_sys_max
    passed.width_sys = true;
end

if height_sys <= config.SysSpec.h_sys_max
    passed.height_sys = true;
end



%% Write system info

config.PackInfo.mass_sys = mass_sys;
config.PackInfo.length_sys = length_sys;
config.PackInfo.width_sys = width_sys;
config.PackInfo.height_sys = height_sys;
