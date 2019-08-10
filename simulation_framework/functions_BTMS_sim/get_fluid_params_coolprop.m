function fluid_struct = get_fluid_params_coolprop(mean_fluid_temp, ref_pressure, fluid_type)
%Call CoolProp to get the fluid parameters.

% Refer to www.coolprop.org for further information

mean_fluid_temp = mean_fluid_temp + 273.15;     % °C --> K


fluid_struct.kin_vis = CoolProp.PropsSI('VISCOSITY','T',mean_fluid_temp,'P',ref_pressure,fluid_type)/CoolProp.PropsSI('DMASS','T',mean_fluid_temp,'P',ref_pressure,fluid_type);      % kinematic viscosity in[m^2/s]
fluid_struct.lambda  = CoolProp.PropsSI('CONDUCTIVITY','T',mean_fluid_temp,'P',ref_pressure,fluid_type);                                                                             % Thermal conductivity in [W/mK]
fluid_struct.rho     = CoolProp.PropsSI('DMASS','T',mean_fluid_temp,'P',ref_pressure,fluid_type);                                                                                    % Density in [kg/m^3]
fluid_struct.cp      = CoolProp.PropsSI('CPMASS','T',mean_fluid_temp,'P',ref_pressure,fluid_type);                                                                                   % specific heat capacity [J/kgK]
fluid_struct.Pr      = CoolProp.PropsSI('PRANDTL','T',mean_fluid_temp,'P',ref_pressure,fluid_type);                                                                                  % Prandtl number

end

