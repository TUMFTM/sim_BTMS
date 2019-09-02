function configs = append_configs_step_1(BatPara, BTMSPara, SysPara, SysSpec, configs)

% Check if first run in this simulation. If first run write at first array
% position, otherwise append data to already existing data.

persistent first_run

if isempty(first_run)
    index = 1;  
    first_run = false;
else
    index = size(configs,2)+1;
end

configs(index).mod_ID = index;
configs(index).cell_ID = BatPara.name;
configs(index).BatPara = BatPara;
configs(index).BTMSPara = BTMSPara;
configs(index).SysPara = SysPara;
configs(index).SysSpec = SysSpec;

end