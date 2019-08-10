%% System parameters

SysPara.name = mfilename;  % Get config name from filename (for better overview)


%% Electrical Interconnection

SysPara.p = p;  % Number of parallel cells      --> Get from external value
SysPara.s = s;  % Number of serial cells        --> Get from external value


%% Initial State

% Initial state of every individual cell insode the system (hence the
% 'ones(BatSys.p,BatSys.s)'). This allows the adaption to measurement data or to induce
% initial load imbalances or thermal gradients.

SysPara.BatStateInit.electrical.SOC    = ones(SysPara.p,SysPara.s) * 0;  
SysPara.BatStateInit.electrical.U_hyst = ones(SysPara.p,SysPara.s) * 0;
SysPara.BatStateInit.electrical.U_RC1  = ones(SysPara.p,SysPara.s) * 0;
SysPara.BatStateInit.electrical.U_RC2  = ones(SysPara.p,SysPara.s) * 0;
SysPara.BatStateInit.electrical.U_RC3  = ones(SysPara.p,SysPara.s) * 0;
SysPara.BatStateInit.electrical.U_RC4  = ones(SysPara.p,SysPara.s) * 0;
SysPara.BatStateInit.electrical.I_cell = ones(SysPara.p,SysPara.s) * 0;

SysPara.BatStateInit.thermal.T_cell    = ones(SysPara.p,SysPara.s) * 20;


%% Cell balancing parameters

% Simple dissipate Balancing. Model assumption: Every individual cell has
% own balancing resistor. This allows individual balancing resistances per cell. 
% To represent one resistor per parallel connection use R_bal/BatSys.p

SysPara.Balancing.R       = ones(SysPara.p,SysPara.s) * 33 / SysPara.p;    % Balancing resistance per cell in Ohm
SysPara.Balancing.U_Delta = 0.01;                                        % Minimum voltage difference between cells to start balancing in V                              
SysPara.Balancing.U_Limit = 3.8;                                         % Lower voltage limit to allow balancing
SysPara.Balancing.I_Limit = SysPara.p * 0.5;                              % Upper limit of battery system furrent load to allow balancing in A

SysPara.Balancing.t_Start = 0;                                             % Specify simulation time after witch balancing is allowed. Set to 'inf' to disable balancing


%% Thermal system parameters (constant ambient temperatures)

% UNUSED FOR sim_BTMS --> WE USE A DIFFERENT, MORE COMPLEX THERMAL MODEL

% Enable or disable thermal simulation by setting "true" or "false". 
% If disabled: T_cell remains constant with the values specified in 'Initial State'.
% Hint: Enable all thermal system variables with dummy values to avoid errors.

SysPara.thermal.convection_enable = false; 

% Simple thermal model. Assume constant ambient temperature around each
% cell and constant heat transfer coefficient. Again, one value must be
% specified for each cell. Dynamic inputs can be specified in the
% simulation model.

SysPara.thermal.convection_T_ambient = ones(SysPara.p,SysPara.s) * 25;   % Ambient temperature around each cell in °C

SysPara.thermal.convection_alpha = ones(SysPara.p,SysPara.s) * 10;       % Heat transfer coefficient between cells and environment in W/(m^2*K)



%% Heat Conduction between the cells (in x-, y- and z-direction)

% Heat conduction between cells. This will be hard to determine and the
% distances are also influenced by the later dimensioning of the battery
% system and the BTMS. To make it somewhat controllable fixed distances are
% assumed

SysPara.thermal.conduction_x_enable = true;         % Enable heat conduction in x-direction

SysPara.thermal.conduction_x_lambda = 5;            % Thermal conductivity between cells in the x-direction [W/m*K]
SysPara.thermal.conduction_x_wt     = 0.00015;      % distance between cells in the x-direction [m]


SysPara.thermal.conduction_y_enable = true;         % Enable heat conduction in y-direction

SysPara.thermal.conduction_y_enable = 5;            % Thermal conductivity between cells in the y-direction [W/m*K]
SysPara.thermal.conduction_y_enable     = 0.00015;  % distance between cells in the y-direction [m]


SysPara.thermal.conduction_z_enable = true;         % Enable heat conduction in z-direction

SysPara.thermal.conduction_z_lambda = 5;            % Thermal conductivity between cells in the z-direction [W/m*K]
SysPara.thermal.conduction_z_wt     = 0.00015;      % distance between cells in the z-direction [m]


