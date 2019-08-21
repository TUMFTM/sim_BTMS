function Map = SysPara_DeviationMap(BatPara, p, s)

% Calculate the normal distributed parameter deviations using the values
% defined in parameters\cell_parameters_XXXX.m. Optionally also specific
% deviation can be assigned to each cell.

% Based on 'deviations_stat.m' from 'https://github.com/TUMFTM/sim_battery_system'

Map.C_A  = 1 + randn(p,s)*BatPara.variances.electrical.C_A;
Map.R_0  = 1 + randn(p,s)*BatPara.variances.electrical.R_0;
Map.C1   = 1 + randn(p,s)*BatPara.variances.electrical.C1;
Map.C2   = 1 + randn(p,s)*BatPara.variances.electrical.C2;
Map.C3   = 1 + randn(p,s)*BatPara.variances.electrical.C3;
Map.C4   = 1 + randn(p,s)*BatPara.variances.electrical.C4;
Map.R1   = 1 + randn(p,s)*BatPara.variances.electrical.R1;
Map.R2   = 1 + randn(p,s)*BatPara.variances.electrical.R2;
Map.R3   = 1 + randn(p,s)*BatPara.variances.electrical.R3;
Map.R4   = 1 + randn(p,s)*BatPara.variances.electrical.R4;

Map.m    = 1 + randn(p,s)*BatPara.variances.physical.m;
Map.c    = 1 + randn(p,s)*BatPara.variances.thermal.c;
Map.EnCo = 1 + randn(p,s)*BatPara.variances.thermal.EnCo;