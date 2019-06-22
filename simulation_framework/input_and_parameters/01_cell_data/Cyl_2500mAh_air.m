%% Disclaimer

% This data is for testing and debugging purposes only!
% The data is mainly used to test the model so it may have been randomly changed 
% meaning it has nothing to do with reality. 

% Use at your own risk!


%% Cell type

% Specify name of parameter set. Format: 'CELL-TYPE'_'CAPACITY'Ah_'COOLING-TYPE'

BatPara.cell_type = 'Cyl';    % Select either 'Pouch', 'Pris' or 'Cyl'


%% Electrical parameters (edit here)

% Specify Electrical LIB-Parameters. 

% Specify the BatPara structure. Details can be found at https://github.com/TUMFTM/sim_battery_system

% For reasons of simplicity and comparability we assume the dynamical values 
% used in the initial release of the electrical system simulation which can 
% be found at https://github.com/TUMFTM/sim_battery_system.

run cell_parameters_NCR18650PF

BatPara.electrical.C_A = 2.5;           % Overwrite original CA value. We want to have a Pouch-Cell with 10 Ah capacity

BatPara.electrical.U_max = 4.2;        % Maximum cell voltage in V IN THE LATER USE-CASE
BatPara.electrical.U_min = 4.2;        % Minimum cell voltage in V IN THE LATER USE-CASE
BatPara.electrical.U_nom = 3.6;        % Nominal cell voltage in V
BatPara.electrical.I_max = 20;         % Maximum cell current in A


%% Physical and thermal parameters (edit here)

% Note: Because we use a different thermal simulation model in this model
% compared to https://github.com/TUMFTM/sim_battery_system, we don't use
% the thermal parameters and the format of this model, but our own.

BatPara.physical.rho = 2453;                      % Density [kg/m^3]
BatPara.physical.c = 1066;                        % specific heat capacity [J/(kg*K)]
BatPara.physical.lambda = [26.04, 0.84, 0.84];   % Thermal conductivity in x-,y-,z-dimension [W/(m*K)]

% Cell dimensions. Note: For cylindrical cells two of those values must be
% the same --> This will be considered as diameter. The diameter must be
% identical or smaller as the length!

BatPara.physical.dim_x = 18.3e-3;     % Cell dimension in x-direction
BatPara.physical.dim_y = 18.3e-3;     % Cell dimension in y-direction
BatPara.physical.dim_z = 64.85e-3;     % Cell dimension in z-direction

% Cell mass (Calculated from the cell's dimensions and density)

BatPara.physical.m = get_cell_mass(BatPara.physical.dim_x, BatPara.physical.dim_y, BatPara.physical.dim_z, BatPara.physical.rho, BatPara.cell_type);