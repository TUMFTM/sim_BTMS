%% Info

% The desired system performance and the restrictions to which the battery 
% system is subjected are specified here.

% The cell, system, and BTMS parameters with which the algorithm attempts 
% to meet the requirements defined here are defined in the folders 
% '01_cell_data', '02_system_data' and '03_BTMS_config'.

% All variables must be defined. If you don't want one specific parameter
% to be considered set it as '0' in case of minimums or 'inf' in case of
% maximums.

%% Some basic definitions

SysSpec.name = mfilename;         % Get config name from filename (for better overview)


SysSpec.num_higher_p_mod = 2;     % Not only look for one parallel cell connection for each module, but also consider up t0 p+n --> More e*pe-distributions will be found.
SysSpec.num_higher_p_sys = 1;     % Not only look for one parallel module connection for each system, but also consider up t0 p+n --> More e*pe-distributions will be found. Note that this will potentially massivey overdimension your system!


%% Electric battery system parameters

% Module level

SysSpec.U_mod_nom   = 48;       % Nominal module voltage in V
SysSpec.C_mod_min   = 200;      % Minimum module capacity in Ah
SysSpec.E_mod_min   = 10;       % Minimum module energy in kWh
SysSpec.I_mod_max   = 50;       % Maximum continuous current the module must withstand in A
SysSpec.s_mod_max   = inf;      % Hard limit for serially connected cells per Module (may e.g. be implied by BMS hardware)


% System Level

SysSpec.I_sys_max   = 100;     % Maximum continuous current the system must withstand in A
SysSpec.U_sys_nom   = 150;     % Nominal voltage of battery system
SysSpec.C_sys_min   = 400;     % Minimum system capacity in Ah
SysSpec.E_sys_min   = 85;      % Minimum system energy in kWh



%% Geometric and mass constraints

% Module level

SysSpec.m_mod_max   = 75;           % Maximum module mass in kg

SysSpec.dim_x_mod_max   = 1.0;      % Maximum module dimension in x-direction in m
SysSpec.dim_y_mod_max   = 0.5;      % Maximum module dimension in y-direction in m
SysSpec.dim_z_mod_max   = 0.4;      % Maximum module dimension in z-direction in m


% System level

SysSpec.m_sys_max   = 1500;         % Maximum module mass in kg

SysSpec.dim_x_sys_max   = 2.7;      % Maximum system dimension in x-direction in m
SysSpec.dim_y_sys_max   = 1.53;     % Maximum system dimension in y-direction in m
SysSpec.dim_z_sys_max   = 0.50;     % Maximum system dimension in z-direction in m



%% Correction and safety factors

SysSpec.sf_dim_sys      = 0.05; % Safety factor (range 0-1) to account for additional space need in the battery system (e.g. additional components or air gaps)
SysSpec.sf_dim_mod      = 0.05; % Safety factor (range 0-1) to account for additional space need in the modules (e.g. additional components or air gaps)
SysSpec.sf_mass_sys     = 0.1;  % Safety factor (range 0-1) to account for additional mass of the battery system (e.g. additional components or structure)
SysSpec.sf_mass_mod     = 0.1;  % Safety factor (range 0-1) to account for additional mass of the modules (e.g. additional components or structure)


%% Thermal constraints

SysSpec.T_grad_max      = 5;    % Maximum thermal gradient between the cells in °C
SysSpec.T_max           = 50;   % Maximum absolute temperature inside the battery system in °C
SysSpec.T_fluid_out_max = 50;   % Maximum outlet temperature of BTMS in °C



