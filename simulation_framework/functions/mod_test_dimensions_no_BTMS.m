function [config, passed] = mod_test_dimensions_no_BTMS(config)

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

m_mod = m_cell * s * p * sf_mod_mass;    % Total module mass   

if strcmp(config.BatPara.cell_type, 'Cyl')
    l_mod = length_cell * s * sf_mod_dim;
    w_mod = diameter_cell * pe * sf_mod_dim;
    h_mod = diameter_cell * e * sf_mod_dim;
    
else
    l_mod = thickness_cell * s * sf_mod_dim;
    w_mod = width_cell * pe * sf_mod_dim;
    h_mod = height_cell * e * sf_mod_dim;
end



%% Test module against criteria

passed = struct('m_mod',false, 'l_mod',false, 'w_mod',false, 'h_mod',false);

if m_mod <= config.SysSpec.m_mod_max
    passed.m_mod = true;
end

if l_mod <= config.SysSpec.l_mod_max
    passed.l_mod = true;
end

if w_mod <= config.SysSpec.w_mod_max
    passed.w_mod = true;
end

if h_mod <= config.SysSpec.h_mod_max
    passed.h_mod = true;
end



%% Return config

config.ModInfo.m_mod = m_mod;
config.ModInfo.l_mod = l_mod;
config.ModInfo.w_mod = w_mod;
config.ModInfo.h_mod = h_mod;
