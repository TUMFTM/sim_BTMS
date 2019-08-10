function [config, passed] = test_dimensions_BTMS(config)

% This function tests the dimension of the pack and compares it to the
% specifications made in 'system_specifications'



%% Get relevant data out of the structure

% Module and system dimensions without BTMS

dim_x_sys_no_BTMS = config.SysInfo.dim_x_sys;
dim_y_sys_no_BTMS = config.SysInfo.dim_y_sys;
dim_z_sys_no_BTMS = config.SysInfo.dim_z_sys;

dim_x_mod_no_BTMS = config.ModInfo.dim_x_mod;
dim_y_mod_no_BTMS = config.ModInfo.dim_y_mod;
dim_z_mod_no_BTMS = config.ModInfo.dim_z_mod;


% BTMS info

num_x_dim_mod = config.BTMSConfig.info.num_channels_inside_mod_x_dir;
num_y_dim_mod = config.BTMSConfig.info.num_channels_inside_mod_y_dir;
num_z_dim_mod = config.BTMSConfig.info.num_channels_inside_mod_z_dir;

num_x_dim_sys = config.BTMSConfig.info.num_channels_inside_sys_x_dir + num_x_dim_mod + config.BTMSPara.enable_sys_frontback * 2;
num_y_dim_sys = config.BTMSConfig.info.num_channels_inside_sys_y_dir + num_y_dim_mod + config.BTMSPara.enable_sys_leftright * 2;
num_z_dim_sys = config.BTMSConfig.info.num_channels_inside_sys_z_dir + num_z_dim_mod + config.BTMSPara.enable_sys_top + config.BTMSPara.enable_sys_bottom;


%% Calculate module and system dimensions

dim_x_sys_BTMS = get_dim(dim_x_sys_no_BTMS, num_x_dim_sys, config.BTMSPara.ch_width, config.BTMSPara.wt);
dim_y_sys_BTMS = get_dim(dim_y_sys_no_BTMS, num_y_dim_sys, config.BTMSPara.ch_width, config.BTMSPara.wt);
dim_z_sys_BTMS = get_dim(dim_z_sys_no_BTMS, num_z_dim_sys, config.BTMSPara.ch_width, config.BTMSPara.wt);

dim_x_mod_BTMS = get_dim(dim_x_mod_no_BTMS, num_x_dim_mod, config.BTMSPara.ch_width, config.BTMSPara.wt);
dim_y_mod_BTMS = get_dim(dim_y_mod_no_BTMS, num_y_dim_mod, config.BTMSPara.ch_width, config.BTMSPara.wt);
dim_z_mod_BTMS = get_dim(dim_z_mod_no_BTMS, num_z_dim_mod, config.BTMSPara.ch_width, config.BTMSPara.wt);


%% Test system against criteria

passed = struct('dim_x_sys_BTMS',false, 'dim_y_sys_BTMS',false, 'dim_z_sys_BTMS',false, ...
    'dim_x_mod_BTMS',false, 'dim_y_mod_BTMS',false, 'dim_z_mod_BTMS',false);

% System level

if dim_x_sys_BTMS <= config.SysSpec.dim_x_sys_max
    passed.dim_x_sys_BTMS = true;
end

if dim_y_sys_BTMS <= config.SysSpec.dim_y_sys_max
    passed.dim_y_sys_BTMS = true;
end

if dim_z_sys_BTMS <= config.SysSpec.dim_z_sys_max
    passed.dim_z_sys_BTMS = true;
end

% Module level

if dim_x_mod_BTMS <= config.SysSpec.dim_x_mod_max
    passed.dim_x_mod_BTMS = true;
end

if dim_y_mod_BTMS <= config.SysSpec.dim_y_mod_max
    passed.dim_y_mod_BTMS = true;
end

if dim_z_mod_BTMS <= config.SysSpec.dim_z_mod_max
    passed.dim_z_mod_BTMS = true;
end



%% Write module and system info

config.SysInfo.dim_x_sys_BTMS = dim_x_sys_BTMS;
config.SysInfo.dim_y_sys_BTMS = dim_y_sys_BTMS;
config.SysInfo.dim_z_sys_BTMS = dim_z_sys_BTMS;

config.ModInfo.dim_x_mod_BTMS = dim_x_mod_BTMS;
config.ModInfo.dim_y_mod_BTMS = dim_y_mod_BTMS;
config.ModInfo.dim_z_mod_BTMS = dim_z_mod_BTMS;

end

function dim_BTMS = get_dim(dim, num, ch_width, ch_wt)
% Calc system size

dim_BTMS = dim + num*(ch_width + 2*ch_wt);

end

