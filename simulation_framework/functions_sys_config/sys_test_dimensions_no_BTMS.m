function [config, passed] = sys_test_dimensions_no_BTMS(config)

% This function tests the dimension of the pack and compares it to the
% specifications made in 'system_specifications'



%% Get relevant data out of the structure

% Module data

mass_mod = config.ModInfo.mass_mod;

dim_x_mod = config.ModInfo.dim_x_mod;
dim_y_mod = config.ModInfo.dim_y_mod;
dim_z_mod = config.ModInfo.dim_z_mod;



% interconnection data

tot = config.SysInfo.num_mods_sys;                     % Total number of modules
s   = config.SysInfo.num_serial_mods_sys;              % Total number of serial modules
pe  = config.SysInfo.num_parallel_mods_per_layer_sys;  % Total number of parallel cells on one level
e   = config.SysInfo.num_layers_sys;                   % Total number of levels


% Correction and safety factors

sf_dim_sys  = 1 + config.SysSpec.sf_dim_sys;     % Safety factor for module dimensions (x,y,z)
sf_mass_sys = 1 + config.SysSpec.sf_mass_sys;    % Safety factor for module mass



%% Calculate system mass and dimensions

% We always assume the same orientation of the modules inside the system.

mass_sys = mass_mod * tot * sf_mass_sys;

dim_x_sys = dim_x_mod * s * sf_dim_sys;       
dim_y_sys = dim_y_mod * pe * sf_dim_sys;
dim_z_sys = dim_z_mod * e * sf_dim_sys;


%% Test system against criteria

passed = struct('mass_sys',false, 'dim_x_sys',false, 'dim_y_sys',false, 'dim_z_sys',false);

if mass_sys <= config.SysSpec.m_sys_max
    passed.mass_sys = true;
end

if dim_x_sys <= config.SysSpec.dim_x_sys_max
    passed.dim_x_sys = true;
end

if dim_y_sys <= config.SysSpec.dim_y_sys_max
    passed.dim_y_sys = true;
end

if dim_z_sys <= config.SysSpec.dim_z_sys_max
    passed.dim_z_sys = true;
end



%% Write system info

config.SysInfo.mass_sys = mass_sys;
config.SysInfo.dim_x_sys = dim_x_sys;
config.SysInfo.dim_y_sys = dim_y_sys;
config.SysInfo.dim_z_sys = dim_z_sys;
