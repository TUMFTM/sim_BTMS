%% Thermal system parameters


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

SysPara.thermal.thermal_sim_enable = false; 

% Simple thermal model. Assume constant ambient temperature around each
% cell and constant heat transfer coefficient. Again, one value must be
% specified for each cell. Dynamic inputs can be specified in the
% simulation model.

SysPara.thermal.T_cell_ambient = ones(SysPara.p,SysPara.s) * 25;   %Ambient temperature around each cell in °C

SysPara.thermal.alpha_cell_ambient = ones(SysPara.p,SysPara.s) * 10;   % Heat transfer coefficient between cells and environment in W/(m^2*K)
