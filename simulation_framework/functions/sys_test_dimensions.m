function [config, passed] = sys_test_dimensions(config)

% This function tests the dimension of the module and compares it to the
% specifications made in 'system_specifications'



%% Get relevant data out of the structure

% Cell data

m_cell = config.BatPara.physical.m;

if strcmp(config.BatPara.cell_type, 'Cyl')
    length_cell = config.BatPara.physical.length;
    diameter_cell = config.BatPara.physical.diameter;
    
elseif strcmp(config.BatPara.cell_type, 'Pouch') || strcmp(config.BatPara.cell_type, 'Pris')
    thickness_cell = config.BatPara.physical.thickness;
    width_cell = config.BatPara.physical.width;
    height_cell = config.BatPara.physical.height;
    
else
    error('Unknown cell type!')
end


% Electrical connection data

p =  config.SysPara.p;  % Total number of parallel cells
s =  config.SysPara.s;  % Total number of serial cells
pe = config.SysPara.pe; % Total number of parallel cells on one level
e =  config.SysPara.e;  % Total number of levels


% Correction and safety factors

sf_mod_dim  = 1 + config.SysSpec.sf_dim_mod;     % Safety factor for module dimensions (x,y,z)
sf_mod_mass = 1 + config.SysSpec.sf_mass_mod;    % Safety factor for module mass



%% Calculate module mass and dimensions

% We distinguish between pouch/primatic and cylidrical cells.
% Pouch/Prismatic is considered as 'standing' in the module, cylindrical
% cells are considered as 'horizontal'.

mass_mod = m_cell * s * p * sf_mod_mass;    % Total module mass   

if strcmp(config.BatPara.cell_type, 'Cyl')
    length_mod = length_cell * s * sf_mod_dim;       
    width_mod = diameter_cell * pe * sf_mod_dim;
    height_mod = diameter_cell * e * sf_mod_dim;
    
else
    length_mod = thickness_cell * s * sf_mod_dim;
    width_mod = width_cell * pe * sf_mod_dim;
    height_mod = height_cell * e * sf_mod_dim;
end



%% Test module against criteria

passed = struct('mass_mod',false, 'length_mod',false, 'width_mod',false, 'height_mod',false);

if mass_mod <= config.SysSpec.m_mod_max
    passed.mass_mod = true;
end

if length_mod <= config.SysSpec.l_mod_max
    passed.length_mod = true;
end

if width_mod <= config.SysSpec.w_mod_max
    passed.width_mod = true;
end

if height_mod <= config.SysSpec.h_mod_max
    passed.height_mod = true;
end



%% Write module info

config.ModInfo.mass_mod = mass_mod;
config.ModInfo.length_mod = length_mod;
config.ModInfo.width_mod = width_mod;
config.ModInfo.height_mod = height_mod;
