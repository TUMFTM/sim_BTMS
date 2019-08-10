function [config, passed] = mod_test_dimensions_no_BTMS(config)

% This function tests the dimension of the module and compares it to the
% specifications made in 'system_specifications'



%% Get relevant data out of the structure

% Cell data

m_cell = config.BatPara.physical.m;

dim_x = config.BatPara.physical.dim_x;
dim_y= config.BatPara.physical.dim_y;
dim_z = config.BatPara.physical.dim_z;
    

% Electrical connection data

p  =  config.SysPara.p_mod;  % Total number of parallel cells
s  =  config.SysPara.s_mod;  % Total number of serial cells
pe =  config.SysPara.pe_mod; % Total number of parallel cells on one level
e  =  config.SysPara.e_mod;  % Total number of levels


% Correction and safety factors

sf_mod_dim  = 1 + config.SysSpec.sf_dim_mod;     % Safety factor for module dimensions (x,y,z)
sf_mod_mass = 1 + config.SysSpec.sf_mass_mod;    % Safety factor for module mass



%% Calculate module mass and dimensions

% We distinguish between pouch/primatic and cylidrical cells.
% Pouch/Prismatic is considered as 'standing' in the module, cylindrical
% cells are considered as 'horizontal'.

mass_mod = m_cell * s * p * sf_mod_mass;    % Total module mass   

dim_x_mod = dim_x * s * sf_mod_dim;
dim_y_mod = dim_y * pe * sf_mod_dim;
dim_z_mod = dim_z * e * sf_mod_dim;




%% Test module against criteria

passed = struct('mass_mod',false, 'dim_x_mod',false, 'dim_y_mod',false, 'dim_z_mod',false);

if mass_mod <= config.SysSpec.m_mod_max
    passed.mass_mod = true;
end

if dim_x_mod <= config.SysSpec.dim_x_mod_max
    passed.dim_x_mod = true;
end

if dim_y_mod <= config.SysSpec.dim_y_mod_max
    passed.dim_y_mod = true;
end

if dim_z_mod <= config.SysSpec.dim_z_mod_max
    passed.dim_z_mod = true;
end



%% Write module info

config.ModInfo.mass_mod = mass_mod;
config.ModInfo.dim_x_mod = dim_x_mod;
config.ModInfo.dim_y_mod = dim_y_mod;
config.ModInfo.dim_z_mod = dim_z_mod;
