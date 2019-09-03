%% System parameters

SysPara.name = mfilename;  % Get config name from filename (for better overview)


%% Electrical Interconnection

SysPara.p = p;  % Number of parallel cells      --> Get from external value
SysPara.s = s;  % Number of serial cells        --> Get from external value


%% Cell balancing parameters

% Simple dissipate Balancing. Model assumption: Every individual cell has
% own balancing resistor. This allows individual balancing resistances per cell. 
% To represent one resistor per parallel connection use R_bal/BatSys.p

SysPara.Balancing.R       = 33 / SysPara.p;     % Balancing resistance per cell in Ohm
SysPara.Balancing.U_Delta = 0.05;               % Minimum voltage difference between cells to start balancing in V                              
SysPara.Balancing.U_Limit = 3.8;                % Lower voltage limit to allow balancing
SysPara.Balancing.I_Limit = SysPara.p * 0.5;    % Upper limit of battery system furrent load to allow balancing in A

SysPara.Balancing.t_Start = 0;                  % Specify simulation time after witch balancing is allowed. Set to 'inf' to disable balancing


%% Thermal system parameters

% Found in 'functions_BTMS_sim/sim_system', so they can be be tuned once
% you have an idea, how the system will look like
