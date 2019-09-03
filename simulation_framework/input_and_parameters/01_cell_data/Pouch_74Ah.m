%% Disclaimer

% This is no real cell data! Use at your own risk!

% The assumptions for cell capacities and dimensions are based on the
% following publication: Fraunhofer-Allianz Batterien (Hg.) (2017): 
% Enwicklungsperspektiven für Zellformate von Lithium-Ionen-Batterien 
% in der Elektromobilität.



%% Cell type

BatPara.name = mfilename;       % Get cell name from filename (for better overview)

BatPara.cell_type = 'Pouch';    % Select either 'Pouch', 'Pris' or 'Cyl'


%% Electrical parameters (edit here)

% Specify Electrical LIB-Parameters. 

% Specify the BatPara structure. Details can be found at https://github.com/TUMFTM/sim_battery_system

% For reasons of simplicity and comparability we assume the dynamical values 
% used in the initial release of the electrical system simulation which can 
% be found at https://github.com/TUMFTM/sim_battery_system.

run cell_parameters_NCR18650PF

t_cell_capacity = 73.6;   % Cell capacigy C_A  in Ah

% Scale sample parameter set to approximate dynamic behavior
[BatPara] = scale_BatPara(BatPara, t_cell_capacity);

BatPara.electrical.U_max = 4.2;                     % Maximum allowed cell voltage in V IN THE LATER USE-CASE
BatPara.electrical.U_min = 2.5;                     % Minimum allowed cell voltage in V IN THE LATER USE-CASE
BatPara.electrical.U_nom = 3.6;                     % Nominal cell voltage in V
BatPara.electrical.I_max = 2 * t_cell_capacity;     % Maximum cell current in A (assumption: 2C) --> Warning, this is very high for current gen cells!


%% Physical and thermal parameters (edit here)

% Note: Because we use a different thermal simulation model in this model
% compared to https://github.com/TUMFTM/sim_battery_system, we don't use
% the thermal parameters and the format of this model, but our own.

% Source: Xia, Et al. (2018): A reliability design method for a lithium-ion battery pack considering the thermal disequilibrium in electric vehicles. 
% In: Journal of Power Sources 386, S. 10–20. DOI: 10.1016/j.jpowsour.2018.03.036.

BatPara.physical.rho = 2460.50;     % Density [kg/m^3]
BatPara.physical.c = 696.07;        % specific heat capacity [J/(kg*K)]

% Cell dimensions. Note: For cylindrical cells two of those values must be
% the same --> This will be considered as diameter. The diameter must be
% identical or smaller as the length!

BatPara.physical.dim_x = 7e-3;   % Cell dimension in x-direction
BatPara.physical.dim_y = 330e-3;    % Cell dimension in y-direction
BatPara.physical.dim_z = 162e-3;     % Cell dimension in z-direction

% Cell mass (Calculated from the cell's dimensions and density)
BatPara.physical.m = get_cell_mass(BatPara.physical.dim_x, BatPara.physical.dim_y, BatPara.physical.dim_z, BatPara.physical.rho, BatPara.cell_type);

%% Clear temporary vars

clearvars t_*