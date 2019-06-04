%% Info

% Specify details of physical BTMS configuration on the cell level.



%% Basic information

BTMS.config_name    = 'liquid_Pouch';
BTMS.cooling_method = 'liquid';     % specify cooling method. Either 'air' or 'liquid'. This gets used for the calculation of the heat transfer coefficients

BTMS.T_fluid_in     = 20;           % Inlet temperature of cooling fluid in °C
BTMS.Vdot_fluid     = 0.0045;       % Fluid mass flow in m^3/s                 % Value for air cooling: 0.0625
BTMS.ref_pressure   = 101325;       % Reference pressure in Pa

BTMS.channel_wid    = 0.003;        % Width of one fluid channel in m
BTMS.ax_channel_h   = 0.01;         % Height of one fluid channel for axial cooling (cylindical cells only) (TODO)


%% Natural convection around cells

% Heat losses of cells due to natural convection. The assumption is that
% the total surface area of the cells exchanges heat with a environmental
% temperature. There are two different values for cells inside the module
% and cells at the surface area of the module.

BTMS.NatKonv.enable = false;       % Enable Subsystem for calculation of natural convection

BTMS.NatKonv.T_inf = 20;           % Ambient temperatures around the cells in °C
BTMS.NatKonv.alpha = 0;            % Heat transfer coefficient for natural convection in W/m^2*K


%% Side cooling (Prismativ and Pouch) and sheath cooling (Cylindrical) of cells

BTMS.Side.enable = true;           % Enable Subsystem for side/sheath cooling

BTMS.Side.lambda = 5;             % Thermal conductivity of the material of the side cooling installation [W/m*K]
BTMS.Side.wt     = 0.00015;       % Wall thickness of the side cooling installation [m]



%% Top/Bottom (Prismatic and Pouch) or axial cooling (Cylindrical) of cells (z-direction)

BTMS.TopBottom.enable = false;          % Enable top/bottom cooling subsystem. To have either one set lamba of other option to '0'

% Top Cooling (Primatic and Pouch: This is the side with the terminals!)

BTMS.TopBottom.Top.lambda = 5;          % Thermal conductivity of the material of the top cooling installation [W/m*K]
BTMS.TopBottom.Top.wt     = 0.00015;    % Wall thickness of the top cooling installation [m]


% Bottom Cooling

BTMS.TopBottom.Bottom.lambda = 5;        % Thermal conductivity of the material of the bottom cooling installation [W/m*K]
BTMS.TopBottom.Bottom.wt     = 0.00015;  % Wall thickness of the bottom cooling installation [m]



%% Heat Conduction between the cells (in x-, y- and z-direction)

% Heat conduction between cells. This will be hard to determine and the
% distances are also influenced by the later dimensioning of the battery
% system and the BTMS. To make it somewhat controllable fixed distances are
% assumed


BTMS.HeatConduction.enable = true;                   % Enable heat conduction in x-direction

BTMS.TopBottom.Bottom.lambda = 5;                    % Thermal conductivity between cells in the x-direction [W/m*K]
BTMS.TopBottom.Bottom.wt     = 0.00015;              % distance between cells in the x-direction [m]


BTMS.HeatConduction.y_direction.enable = true;       % Enable heat conduction in y-direction

BTMS.TopBottom.Bottom.lambda = 5;                    % Thermal conductivity between cells in the y-direction [W/m*K]
BTMS.TopBottom.Bottom.wt     = 0.00015;              % distance between cells in the y-direction [m]


BTMS.HeatConduction.z_direction.enable = true;       % Enable heat conduction in z-direction

BTMS.TopBottom.Bottom.lambda = 5;                    % Thermal conductivity between cells in the z-direction [W/m*K]
BTMS.TopBottom.Bottom.wt     = 0.00015;              % distance between cells in the z-direction [m]