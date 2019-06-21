%% Disclaimer

% This data is for testing and debugging purposes only!
% The data is mainly used to test the model so it may have been randomly changed 
% meaning it has nothing to do with reality. 

% Use at your own risk!


%% Cell type

% Specify name of parameter set. Format: 'CELL-TYPE'_'CAPACITY'Ah_'COOLING-TYPE'

BatPara.cell_type = 'Pouch';    % Select either 'Pouch', 'Pris' or 'Cyl'


%% Electrical parameters (edit here)

% Specify Electrical LIB-Parameters. 

% Specify the BatPara structure. Details can be found at https://github.com/TUMFTM/sim_battery_system

% For reasons of simplicity and comparability we assume the dynamical values 
% used in the initial release of the electrical system simulation which can 
% be found at https://github.com/TUMFTM/sim_battery_system.

run cell_parameters_NCR18650PF

BatPara.electrical.C_A = 20;           % Overwrite original CA value. We want to have a Pouch-Cell with 10 Ah capacity

BatPara.electrical.U_max = 4.2;        % Maximum cell voltage in V IN THE LATER USE-CASE
BatPara.electrical.U_min = 4.2;        % Minimum cell voltage in V IN THE LATER USE-CASE
BatPara.electrical.U_nom = 3.6;        % Nominal cell voltage in V
BatPara.electrical.I_max = 10;         % Maximum cell current in A


%% Physical and thermal parameters (edit here)

% Note: Because we use a different thermal simulation model in this model
% compared to https://github.com/TUMFTM/sim_battery_system, we don't use
% the thermal parameters and the format of this model, but our own.

BatPara.physical.A_K = [0.006,0.16,0.170];                                 % Height (x), Width (y) and Length (z) (in m)
        
BatPara.physical.rho = 2453;                                                % Density [kg/m^3]
BatPara.physical.m = BatPara.physical.rho*prod(BatPara.physical.A_K);       % Mass [kg] (here it's calculated from the cell's dimension and density)
BatPara.physical.c = 1066;                                                  % specific heat capacity [J/(kg*K)]
BatPara.physical.lambda = [0.84, 26.05, 26.05];                             % Thermal conductivity in x-,y-,z-dimension [W/(m*K)]

if strcmp(BatPara.cell_type, 'Cyl')
    BatPara.physical.length = 65.0;         % Cylindrical cell only: Length in m
    BatPara.physical.diameter = 18;         % Cylindrical cell only: Diameter in m
    
elseif strcmp(BatPara.cell_type, 'Pouch') || strcmp(BatPara.cell_type, 'Pris')
    BatPara.physical.thickness = 0.006;     % Pouch/Prismatic cell only: Thickness in m
    BatPara.physical.width     = 0.082;     % Pouch/Prismatic cell only: Width in m
    BatPara.physical.height    = 0.170;     % Pouch/Prismatic cell only: Height in m
    
else
    error('Unknown cell type!')
end