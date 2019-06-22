%% Disclaimer

% This data is for testing and debugging purposes only!
% The data is mainly used to test the model so it may have been randomly changed 
% meaning it has nothing to do with reality. 

% Use at your own risk!



%% Info

% Specify details of physical BTMS configuration on the cell, module and
% system level. There are many different possibilities and if you select
% everything the configuration and simulation may take a very long time!
% It is recommended to slowly iterate through the different possibilities.

% There are several options for cooling your battery system.

% On the system level:
% Bottom cooling of the modules (bottom layer only)                          --> sys_bottom
% Top cooling of the modules (top layer only)                                --> sys_top
% Cooling the left/right side of the battery system (all outside modules)    --> sys_leftright
% Cooling the front/back side of the battery system (all outside modules)    --> sys_frontback
% Cooling the module sides inside of the battery system 
%     perpendicular to the x, y and z axis                                   --> sys_inside_x, sys_inside_y, sys_inside_z, 
%     
% On the module level:
% Cooling of the outer cells of a module (gets implied via system-level definitions)
% Cooling of the cells inside the module
%     perpendicular to the x, y and z axis                                   --> mod_inside_x, mod_inside_y, mod_inside_z
    
% Every 'mod_inside_*' option will iterate through all possibilities of BTMS
% cooling channel placement. For a module of n cells ( o ) and liquid cooling
% channels ( | ) this will look like this:

% Iteration 1:    o o o o     (no  internal cooling channel)
% Iteration 2:    o o|o o     ( 1  internal cooling channel)
% Iteration 3:    o|o o|o     ( 2  internal cooling channels)
% Iteration 4:    o|o|o|o     (n-1 internal cooling channels)

% Note that the algorithm on the module level only offers symmetrical
% solutions. 

% For air as cooling medium it is always assumed that all cells/modules are
% in the airflow if internal cooling is selected. In this case the parameter
% mod_inside_x determine the direction of the airflow. Note that only one
% mod_inside_x may be set true in this case!

% For the case of liquid cooling, setting more than one *_inside_* value to
% true will lead to a "crossing" of cooling channels. The model assumes
% this doesn't lead to any thermal interaction or even mixing of the
% fluids. Every cooling channel is simulated independently.

% For the simulation you provide the overall fluid mass flow as well as the
% width and the height of the cooling channels of each method. The
% individual mass flow is calculated according to the number of all cooling
% channels inside the config. This is necessary, because we don't now yet
% how the models and the battery pack looks like and therefore cannot
% determine the number of cooling channels.

% Use the value 'min_flow_speed' or 'max_flow_speed' to exclude configs with 
% unrealitically high flow speeds.



%% Basic information

BTMSPara.name = mfilename;              % Get config name from filename (for better overview)
BTMSPara.cooling_method = 'liquid';     % specify cooling method. Either 'air' or 'liquid'. This gets used for the calculation of the heat transfer coefficients

BTMSPara.T_fluid_in     = 20;           % Inlet temperature of cooling fluid in °C
BTMSPara.Vdot_fluid     = 0.0045;       % Overall fluid mass flow in m^3/s                 % Value for air cooling: 0.0625
BTMSPara.ref_pressure   = 101325;       % Reference pressure in Pa

BTMSPara.FluidType      = 'water';      % Specify fluid type for CoolProp (see: http://www.coolprop.org/)



%% Natural convection around cells

% Heat losses of cells due to natural convection. The assumption is that
% the total surface area of the cells exchanges heat with a environmental
% temperature. There are two different values for cells inside the module
% and cells at the surface area of the module.

BTMSPara.enable_convection = false;    % Enable Subsystem for calculation of natural convection

BTMSPara.NatKonv.T_inf_inside  = 20;   % Ambient temperatures around the outside cells in °C
BTMSPara.NatKonv.alpha_inside  = 0;    % Heat transfer coefficient for outside cells in W/m^2*K

BTMSPara.NatKonv.T_inf_outside = 20;   % Ambient temperatures around the inside cells in °C
BTMSPara.NatKonv.alpha_outside = 0;    % Heat transfer coefficient for inside cells in W/m^2*K



%% System-level: Bottom cooling

% Assumes all modules are standing on a cooling plate with uniform temperature. 
% Fluid flow along x-dim of battery system

BTMSPara.enable_sys_bottom = true;      % Enable Subsystem for side/sheath cooling

BTMSPara.sys_bottom.lambda = 5;         % Thermal conductivity of the material of the cooling installation in W/m*K
BTMSPara.sys_bottom.wt     = 0.00015;   % Wall thickness of the cooling installation in m

BTMSPara.sys_bottom.ch_width = 0.003;   % Width of cooling channel in m
BTMSPara.sys_bottom.ch_ratio = 0.95;    % Ratio of channel size relative to y-dim of battery pack)



%% System-level: 

BTMSPara.enable_sys_top = true;     % Enable Subsystem for side/sheath cooling

BTMSPara.sys_top.lambda = 5;        % Thermal conductivity of the material of the cooling installation in W/m*K
BTMSPara.sys_top.wt     = 0.00015;  % Wall thickness of the cooling installation in m

BTMSPara.sys_top.ch_width = 0.003;   % Width of cooling channel in m
BTMSPara.sys_top.ch_ratio = 0.95;    % Ratio of channel size relative to y-dim of battery pack)


%% System-level: 

BTMSPara.enable_sys_leftright = true;     % Enable Subsystem for side/sheath cooling

BTMSPara.sys_leftright.lambda = 5;        % Thermal conductivity of the material of the cooling installation in W/m*K
BTMSPara.sys_leftright.wt     = 0.00015;  % Wall thickness of the cooling installation in m

BTMSPara.sys_leftright.ch_width = 0.003;   % Width of cooling channel in m
BTMSPara.sys_leftright.ch_ratio = 0.95;    % Ratio of channel size relative to y-dim of battery pack)


%% System-level: 

BTMSPara.enable_sys_frontback = true;     % Enable Subsystem for side/sheath cooling

BTMSPara.sys_frontback.lambda = 5;        % Thermal conductivity of the material of the cooling installation in W/m*K
BTMSPara.sys_frontback.wt     = 0.00015;  % Wall thickness of the cooling installation in m

BTMSPara.sys_frontback.ch_width = 0.003;   % Width of cooling channel in m
BTMSPara.sys_frontback.ch_ratio = 0.95;    % Ratio of channel size relative to y-dim of battery pack)


%% System-level: 

BTMSPara.enable_sys_inside_x = true;     % Enable Subsystem for side/sheath cooling

BTMSPara.sys_inside_x.lambda = 5;        % Thermal conductivity of the material of the cooling installation in W/m*K
BTMSPara.sys_inside_x.wt     = 0.00015;  % Wall thickness of the cooling installation in m

BTMSPara.sys_inside_x.ch_width = 0.003;   % Width of cooling channel in m
BTMSPara.sys_inside_x.ch_ratio = 0.95;    % Ratio of channel size relative to y-dim of battery pack)


%% System-level: 

BTMSPara.enable_sys_inside_y = true;     % Enable Subsystem for side/sheath cooling

BTMSPara.sys_inside_y.lambda = 5;        % Thermal conductivity of the material of the cooling installation in W/m*K
BTMSPara.sys_inside_y.wt     = 0.00015;  % Wall thickness of the cooling installation in m

BTMSPara.sys_inside_y.ch_width = 0.003;   % Width of cooling channel in m
BTMSPara.sys_inside_y.ch_ratio = 0.95;    % Ratio of channel size relative to y-dim of battery pack)


%% System-level: 

BTMSPara.enable_sys_inside_z = true;     % Enable Subsystem for side/sheath cooling

BTMSPara.sys_inside_z.lambda = 5;        % Thermal conductivity of the material of the cooling installation in W/m*K
BTMSPara.sys_inside_z.wt     = 0.00015;  % Wall thickness of the cooling installation in m

BTMSPara.sys_inside_z.ch_width = 0.003;   % Width of cooling channel in m
BTMSPara.sys_inside_z.ch_ratio = 0.95;    % Ratio of channel size relative to y-dim of battery pack)


%% Module-level: 

BTMSPara.enable_mod_inside_x = true;     % Enable Subsystem for side/sheath cooling

BTMSPara.mod_inside_x.lambda = 5;        % Thermal conductivity of the material of the cooling installation in W/m*K
BTMSPara.mod_inside_x.wt     = 0.00015;  % Wall thickness of the cooling installation in m

BTMSPara.mod_inside_x.ch_width = 0.003;   % Width of cooling channel in m
BTMSPara.mod_inside_x.ch_ratio = 0.95;    % Ratio of channel size relative to y-dim of battery pack)


%% Module: Side cooling (Prismativ and Pouch) and sheath cooling (Cylindrical) of cells

BTMSPara.enable_mod_inside_y = true;     % Enable Subsystem for side/sheath cooling

BTMSPara.mod_inside_y.lambda = 5;        % Thermal conductivity of the material of the cooling installation in W/m*K
BTMSPara.mod_inside_y.wt     = 0.00015;  % Wall thickness of the cooling installation in m

BTMSPara.mod_inside_y.ch_width = 0.003;   % Width of cooling channel in m
BTMSPara.mod_inside_y.ch_ratio = 0.95;    % Ratio of channel size relative to y-dim of battery pack)


%% Module: Side cooling (Prismativ and Pouch) and sheath cooling (Cylindrical) of cells

BTMSPara.enable_mod_inside_z = true;     % Enable Subsystem for side/sheath cooling

BTMSPara.mod_inside_z.lambda = 5;        % Thermal conductivity of the material of the cooling installation in W/m*K
BTMSPara.mod_inside_z.wt     = 0.00015;  % Wall thickness of the cooling installation in m

BTMSPara.mod_inside_z.ch_width = 0.003;   % Width of cooling channel in m
BTMSPara.mod_inside_z.ch_ratio = 0.95;    % Ratio of channel size relative to y-dim of battery pack)


%% Check validity of configuration

check_validity_BTMS_config(BTMSPara);