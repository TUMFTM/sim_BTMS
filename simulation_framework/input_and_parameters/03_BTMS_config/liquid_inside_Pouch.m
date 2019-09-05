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

% For air as cooling medium it is always assumed that all cells/modules are
% in the airflow if internal cooling is selected. In this case the parameter
% sys_inside_x determine the direction of the airflow. Note that only one
% sys_inside_* may be set true in this case!

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



%% Basic information

BTMSPara.name = mfilename;                      % Get config name from filename (for better overview)

BTMSPara.T_fluid_in     = 20;                   % Inlet temperature of cooling fluid in �C
BTMSPara.Vdot_fluid     = 0.0045;               % Overall fluid mass flow in m^3/s                 % Value for air cooling: 0.0625
BTMSPara.ref_pressure   = 101325;               % Reference pressure in Pa

BTMSPara.FluidType      = 'INCOMP::MEG-50%';    % Specify fluid type for CoolProp (see: http://www.coolprop.org/) (Water with 50% ethylenglycol)

BTMSPara.lambda_wall    = 236;                  % Thermal conductivity of the material of the cooling installation in W/m*K (copper)
BTMSPara.wt             = 0.00015;              % Wall thickness of the cooling installation in m

BTMSPara.ch_width       = 0.003;                % Width of cooling channels in m
BTMSPara.ch_ratio_sys   = 0.95;                 % Ratio of channel size relative to x,y or z dimensions of battery system
BTMSPara.ch_ratio_cell  = 0.90;                 % Ratio of channel size relative to x,y or z dimensions of battery system


%% Natural convection around cells

% The framework disregards heat dissipation of the battery system to the
% environment due to natural convection to comply with the worst-case
% assumption used to design the BTMS.
% If required this can easily been added to the simulation framework by
% adding the heat transfer coefficient and the environmental temperature to
% the signals 'T_cell_ambient' and 'alpha_cell_ambient'. Refer to the
% subsystem 'Create BTMS input' to see how those values are scaled to
% incorporate more than one heat transfer path.



%% System-level: Bottom cooling

% Assumes all modules are standing on a cooling plate with uniform temperature. 
% Fluid flow along x-dim of battery system.
% This only affects the bottom layer of modules in the battery system. So
% all module with a num_layers_sys >= 2 won't be directly affected by this
% option.

BTMSPara.enable_sys_bottom = false;


%% System-level: Top cooling

% Assumes a cooling plate with uniform temperature on top of the battery system. 
% Fluid flow along x-dim of battery system.
% This only affects the top layer of modules in the battery system.

BTMSPara.enable_sys_top = false;


%% System-level: Cooling of left/right of battery system

% Assumes a cooling plate with uniform temperat%%ure on the left and right of the battery system. 
% Fluid flow along x-dim of battery system.
% This only affects the outer left and right modules.

BTMSPara.enable_sys_leftright = false;


%% System-level: Cooling of front/back

% Assumes a cooling plate with uniform temperature on the front and back of the battery system. 
% Fluid flow along x-dim of battery system.
% This only affects the outer left and right modules.

BTMSPara.enable_sys_frontback = true;


%% System-level: Cooling between the modules in the spacial directions

% Assumes a cooling plate with uniform temperature between the modules.

% Fluid flow perpendicular to x-dim of battery system.

BTMSPara.enable_sys_inside_x = false;


% Fluid flow perpendicular to y-dim of battery system.

BTMSPara.enable_sys_inside_y = false;


% Fluid flow perpendicular to z-dim of battery system

BTMSPara.enable_sys_inside_z = false;



%% About cooling inside of the battery system

% Every '*_inside_*' option will place cooling channels in the specified
% spacial direction on the module level. This is specified by a vector
% specifying the position of the cooling plates relative to the cell count
% inside the module. 

% Example for a 4s module:

% 4s --> Only cells in x-direction

% Legend: o = cell, | = cooling plate

% Design 1:    o o o o     mod_inside_x_layers = [] (same as enable_sys_inside_* = false)
% Design 2:    o o|o o     mod_inside_x_layers = [2]
% Design 3:    o|o o|o     mod_inside_x_layers = [1,3]
% Design 4:    o|o|o|o     mod_inside_x_layers = [1,2,3]

% To only cool the outside of module use 'enable_sys_between_*' above.

% Some hints:
% - This requires information about the module design (number of cells in 
%   all directions). It is recommended to first do a rough design without
%   this option and only turn this option one once you have an idea how
%   your modules will look like and know you really need cooling inside the
%   modules
% - In 'mod_inside_*_layers' only numbers from 1 to the number of cells in
%   the spacial direction within the module -1 is supported. Everything else
%   will throw an error in the BTMS configuration.
% - There is a possibility to plot your system design for better
%   visualisation. Run the configuration 'main_sim_BTMS_1_system_setup' and 
%   refer to 'main_sim_BTMS_2_system_simulation'.


%% Module-level: Cooling inside modules perpendicular to x-direction

BTMSPara.enable_mod_inside_x = true;
BTMSPara.mod_inside_x_layers = [4, 7, 10];     


%% Module-level: Cooling inside modules perpendicular to y-direction

BTMSPara.enable_mod_inside_y = false;
BTMSPara.mod_inside_y_layers = []; 


%% Module-level: Cooling inside modules perpendicular to z-direction

BTMSPara.enable_mod_inside_z = false;
BTMSPara.mod_inside_z_layers = [];

