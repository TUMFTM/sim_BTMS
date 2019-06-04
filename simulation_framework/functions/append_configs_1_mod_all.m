function configs = append_configs_1_mod_all(BatPara, BTMS, SimPara, SysPara, SysSpec, configs)

% Check if first run in this simulation. If first run write at first array
% position, otherwise append data to already existing data.

persistent first_run

if isempty(first_run)
    index = 1;  
    first_run = false;
else
    index = size(configs,2)+1;
end

 configs(index).BatPara = BatPara;
 configs(index).BTMS = BTMS;
 configs(index).SimPara = SimPara;
 configs(index).SysPara = SysPara;
 configs(index).SysSpec = SysSpec;