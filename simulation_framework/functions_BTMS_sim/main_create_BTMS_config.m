function [BTMSConfig] = main_create_BTMS_config(BTMSPara, SysPara, SysInfo, ModInfo)
%CREATE_BTMS_ARCHITECTURE Create the BTMS configs


%% Get system and module architecture

pe_mod = ModInfo.num_parallel_cells_per_layer_mod;
e_mod  = ModInfo.num_layers_mod;
s_mod  = ModInfo.num_serial_cells_mod;

pe_mod_sys = SysInfo.num_parallel_mods_per_layer_sys;
e_mod_sys  = SysInfo.num_layers_sys;
s_mod_sys  = SysInfo.num_serial_mods_sys;

pe_sys = pe_mod * pe_mod_sys;
e_sys  = e_mod * e_mod_sys;
s_sys  = s_mod * s_mod_sys;         % TODO: Assignment auf SysPara

dim_x_sys = SysInfo.dim_x_sys;
dim_y_sys = SysInfo.dim_y_sys;
dim_z_sys = SysInfo.dim_z_sys;

A_transf_x = SysPara.thermal.transfer.A_x;
A_transf_y = SysPara.thermal.transfer.A_y;
A_transf_z = SysPara.thermal.transfer.A_z;


%% Get desired BTMS config

sys_b    = BTMSPara.enable_sys_bottom;
sys_t    = BTMSPara.enable_sys_top;
sys_lr   = BTMSPara.enable_sys_leftright;
sys_fb   = BTMSPara.enable_sys_frontback;

sys_x    = BTMSPara.enable_sys_inside_x;
sys_y    = BTMSPara.enable_sys_inside_y;
sys_z    = BTMSPara.enable_sys_inside_z;

mod_x    = BTMSPara.enable_mod_inside_x;
mod_y    = BTMSPara.enable_mod_inside_y;
mod_z    = BTMSPara.enable_mod_inside_z;

x_layers = BTMSPara.mod_inside_x_layers;
y_layers = BTMSPara.mod_inside_y_layers;
z_layers = BTMSPara.mod_inside_z_layers;


%% Physical fluid and channel definitions

Vdot_BTMS      = BTMSPara.Vdot_fluid;
T_fluid        = BTMSPara.T_fluid_in;

ch_width            = BTMSPara.ch_width;
ch_ratio_sys_length = BTMSPara.ch_ratio_sys;
ch_ratio_cell       = BTMSPara.ch_ratio_cell;

wall_thickness = BTMSPara.wt;
lambda_wall    = BTMSPara.lambda_wall;

ref_pressure = BTMSPara.ref_pressure;
fluid_type   = BTMSPara.FluidType;


%% Get number, starting layer and orientation of cooling channels

% Sort enabled systems after type
enable_vec_sys_out = [sys_b, sys_t, sys_lr, sys_fb];
enable_vec_sys_in  = [sys_x, sys_y, sys_z]; 
enable_vec_mod_in  = [mod_x, mod_y, mod_z];

enable_vec = [enable_vec_sys_out, enable_vec_sys_in, enable_vec_mod_in];

% Number of channels outside of system
num_sys_outside = sum(enable_vec_sys_out(1:2)) + 2*enable_vec_sys_out(3) + 2*enable_vec_sys_out(4);

% Number of channels inside of system
num_sys_inside_x = sum(enable_vec_sys_in(1) * (s_mod_sys - 1));
num_sys_inside_y = sum(enable_vec_sys_in(2) * (pe_mod_sys - 1));
num_sys_inside_z = sum(enable_vec_sys_in(3) * (e_mod_sys - 1));

num_sys_inside  = sum([num_sys_inside_x, num_sys_inside_y, num_sys_inside_z]);

% Number of channels inside of modules
num_mod_inside_x = sum(enable_vec_mod_in(1) * (length(x_layers) * s_mod_sys));
num_mod_inside_y = sum(enable_vec_mod_in(2) * (length(y_layers) * pe_mod_sys));
num_mod_inside_z = sum(enable_vec_mod_in(3) * (length(z_layers) * e_mod_sys));

num_mod_inside  = sum([num_mod_inside_x, num_mod_inside_y, num_mod_inside_z]);

% Total number of channels
num_channels    = sum([num_sys_outside, num_sys_inside, num_mod_inside]);

% Preallocate vectors
ch_orient_sys_out = NaN(1,num_sys_outside);
ch_orient_sys_in  = NaN(1,num_sys_inside);
ch_orient_mod_in  = NaN(1,num_mod_inside);

% We work on the cell level, so every layer is the cell level of the whole
% system!

ch_start_layer_sys_out = NaN(1,num_sys_outside);
ch_start_layer_sys_in  = NaN(1,num_sys_inside);
ch_start_layer_mod_in  = NaN(1,num_mod_inside);

% Variables to count the feasible configurations
c_out = 1;
c_in  = 1;
c_m_in  = 1;

% Iterate through the possible BTMS types
for ii = 1:length(enable_vec)

    if enable_vec(ii) == true      % See if variant is enabled, otherwise do nothing
        
        switch ii       % Choose different actions for the different variants
        
            % System out
            case 1      % sys_b
                
                idx = c_out;
                
                ch_start_layer_sys_out(idx) = 0;
                ch_orient_sys_out(idx) = 'z';
                
                c_out = c_out + 1;
                
                
            case 2      % sys_t
                
                idx = c_out;
                
                ch_start_layer_sys_out(idx) = e_sys;
                ch_orient_sys_out(idx) = 'z';
                
                c_out = c_out + 1;
                
                
            case 3      % sys_lr
                
                idx = c_out : c_out+1;
                
                ch_start_layer_sys_out(idx) = [0, pe_sys];
                ch_orient_sys_out(idx) = 'y';
                
                c_out = c_out + 2;
                
                
            case 4      % sys_fb
                
                idx = c_out : c_out+1;
                
                ch_start_layer_sys_out(idx) = [0, s_sys];
                ch_orient_sys_out(idx) = 'x';
                
                c_out = c_out + 2;
                
                
                
            % System in
            case 5      % sys_x
                
                idx = c_in : c_in+num_sys_inside_x-1;
                
                ch_start_layer_sys_in(idx) = s_mod * (1:(s_mod_sys-1));
                ch_orient_sys_in(idx) = 'x';
                
                c_in = c_in + num_sys_inside_x;
                
                
            case 6      % sys_y
                
                idx = c_in : c_in+num_sys_inside_y-1;
                
                ch_start_layer_sys_in(idx) = pe_mod * (1:(pe_mod_sys-1));
                ch_orient_sys_in(idx) = 'y';
                
                c_in = c_in + num_sys_inside_y;
                
                
            case 7      % sys_z
                
                idx = c_in : c_in+num_sys_inside_z-1;
                
                ch_start_layer_sys_in(idx) = e_mod * (1:(e_mod_sys-1));
                ch_orient_sys_in(idx) = 'z';
                
                c_in = c_in + num_sys_inside_z;
            
                
                
            % Module in
            case 8      % mod_x
                
                idx = c_m_in : c_m_in+num_mod_inside_x-1;
                
                ch_start_layer_mod_in(idx) = starting_layers_mod_in(x_layers, s_mod, s_mod_sys);
                ch_orient_mod_in(idx) = 'x';
                
                c_m_in = c_m_in + num_mod_inside_x;
                
                
            case 9      % mod_y
                
                idx = c_m_in : c_m_in+num_mod_inside_y-1;
                
                ch_start_layer_mod_in(idx) = starting_layers_mod_in(y_layers, pe_mod, pe_mod_sys);
                ch_orient_mod_in(idx) = 'y';
                
                c_m_in = c_m_in + num_mod_inside_y;
                
                
            case 10     % mod_z
                
                idx = c_m_in : c_m_in+num_mod_inside_z-1;
                
                ch_start_layer_mod_in(idx) = starting_layers_mod_in(z_layers, e_mod, e_mod_sys);
                ch_orient_mod_in(idx) = 'z';
                
                c_m_in = c_m_in + num_mod_inside_z;
                
                
                
            otherwise
                
                error('Option not defined. Did you add another BTMS type?')
                
        end
    end 
end


%% Define channel types

% Needed for calculation of heat transfer coefficient. 'true' for a channel
% inside of the battery system (heated from both sides), 'false' for a
% channel outside of the battery system

ch_type_sys_out = false(1,num_sys_outside);
ch_type_sys_in  = true(1, num_sys_inside);
ch_type_mod_in  = true(1, num_mod_inside);


%% Sort layer and type vectors according to dimension

start_layers_unsorted = [ch_start_layer_sys_out, ch_start_layer_sys_in, ch_start_layer_mod_in];
channel_inside_unsorted = [ch_type_sys_out, ch_type_sys_in, ch_type_mod_in];
ch_orient_unsorted = [ch_orient_sys_out, ch_orient_sys_in, ch_orient_mod_in];

start_layers_x_dir = start_layers_unsorted( ch_orient_unsorted == 'x' );
start_layers_y_dir = start_layers_unsorted( ch_orient_unsorted == 'y' );
start_layers_z_dir = start_layers_unsorted( ch_orient_unsorted == 'z' );

ch_inside_x_dir = channel_inside_unsorted( ch_orient_unsorted == 'x' );
ch_inside_y_dir = channel_inside_unsorted( ch_orient_unsorted == 'y' );
ch_inside_z_dir = channel_inside_unsorted( ch_orient_unsorted == 'z' );

ch_start_layers = [start_layers_x_dir, start_layers_y_dir, start_layers_z_dir];
ch_inside       = [ch_inside_x_dir, ch_inside_y_dir, ch_inside_z_dir];
ch_orient       = ['x' * ones(1,length(start_layers_x_dir)), 'y' * ones(1,length(start_layers_y_dir)), 'z' * ones(1,length(start_layers_z_dir))];


%% Get cell IDs of cells adjacent to each channel

% Defintion of channels as cell array (good readability)
ch_def = cell(1, num_channels);

% Iterate trough the channels
for ii = 1:num_channels
    
    ch_def{ii} = get_IDs_cells_channels(ch_start_layers(ii), ch_orient(ii), e_sys, pe_sys, s_sys);
    
end

% Definition of channels in matrix form (input for simulation model)
ch_def_mat = create_channel_def_matrix(ch_def);


%% Calculate some physical infos about the BTMS

% Length of channels in m
ch_length = get_BTMS_channel_length(ch_orient, ch_ratio_sys_length, dim_x_sys, dim_y_sys, dim_z_sys);

% Number of cells adjacent to a cooling channel
[~, ch_num_adj_cells] = cellfun(@size, ch_def);

% Total heat tranferring area of cells adjacent to cooling channel in m^2
ch_A_heat = calc_total_A_heat_transfer(ch_num_adj_cells, ch_orient, [A_transf_x, A_transf_y, A_transf_z] * ch_ratio_cell);

% Cross-section of the cooling channels in m^2
ch_crosss = get_BTMS_channel_cross_section(ch_orient, ch_ratio_sys_length, dim_x_sys, dim_y_sys, dim_z_sys, ch_width);

% Ratio of channel cross-sections
ch_crosss_ratio = ch_crosss/sum(ch_crosss);


%% Calculate fluid properties

% Done once because we are assuming constant inlet temperatures. Move this
% function to 'Create BTMS input' in the simulation model to dynamically
% compute the heat transfer coefficient during runtime.

fluid_para = get_fluid_params_coolprop(T_fluid, ref_pressure, fluid_type);


%% Volume, mass flow and flow speed for the channels

% Volume flow through each channel in m^3/s
ch_Vdot = Vdot_BTMS .* ch_crosss_ratio;

% Mass flow through each channel in kg/s
ch_mdot = ch_Vdot .* fluid_para.rho;      

% Flow speed of fluid in each channel in m/s
ch_w = ch_Vdot ./ ch_crosss;         


%% Calculate heat transfer coefficient for each channel

% Done once because we are assuming constant volume flow. Move this
% function to 'Create BTMS input' in the simulation model to dynamically
% compute the heat transfer coefficient during runtime.

ch_alpha = calc_alpha_channel(fluid_para, ch_w, ch_width, ch_length, ch_inside);



%% Output BTMSConfig structure for simulation


% Everything needed for the simulation

BTMSConfig.T_fluid = T_fluid;
BTMSConfig.Vdot_BTMS = Vdot_BTMS;

BTMSConfig.channel_def_mat = ch_def_mat;
BTMSConfig.channel_num_adj_cells = ch_num_adj_cells;
BTMSConfig.num_channels = num_channels;
BTMSConfig.channel_length = ch_length;
BTMSConfig.channel_mdot = ch_mdot;
BTMSConfig.fluid_para = fluid_para;
BTMSConfig.lambda_wall = lambda_wall;
BTMSConfig.channel_alpha = ch_alpha;
BTMSConfig.channel_orientation = ch_orient;


% Further information about the BTMS architecture

BTMSConfig.info.num_channels_outside = num_sys_outside;

BTMSConfig.info.num_channels_inside_sys_x_dir = num_sys_inside_x;
BTMSConfig.info.num_channels_inside_sys_y_dir = num_sys_inside_y;
BTMSConfig.info.num_channels_inside_sys_z_dir = num_sys_inside_z;

BTMSConfig.info.num_channels_inside_sys = num_sys_inside;

BTMSConfig.info.num_channels_inside_mod_x_dir = num_mod_inside_x;
BTMSConfig.info.num_channels_inside_mod_y_dir = num_mod_inside_y;
BTMSConfig.info.num_channels_inside_mod_z_dir = num_mod_inside_z;

BTMSConfig.info.num_channels_inside_mod = num_mod_inside;

BTMSConfig.info.channel_start_layers = ch_start_layers;

BTMSConfig.info.channel_definition_cell = ch_def;

BTMSConfig.info.channel_cross_sections = ch_crosss;
BTMSConfig.info.channel_chross_section_ratio = ch_crosss_ratio;

BTMSConfig.info.channel_heat_tranfer_surface_cells = ch_A_heat;

BTMSConfig.info.channel_flow_speed = ch_w(1);
BTMSConfig.info.channel_volume_flow = ch_Vdot;

BTMSConfig.info.channel_wall_thickness = wall_thickness;

end

