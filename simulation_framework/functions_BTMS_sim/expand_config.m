function [sys_ID, mod_ID, SysSpec, BatPara, SysPara, BTMSPara, ModInfo, SysInfo, BTMSConfig] = expand_config(config)

sys_ID     = config.sys_ID;
mod_ID     = config.mod_ID;
SysSpec    = config.SysSpec;
BatPara    = config.BatPara;
SysPara    = config.SysPara;
BTMSPara   = config.BTMSPara;
ModInfo    = config.ModInfo;
SysInfo    = config.SysInfo;
BTMSConfig = config.BTMSConfig;

end